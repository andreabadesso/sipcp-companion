defmodule SipcpCompanion.AI.Agent do
  @moduledoc """
  Agentic AI loop for the SIPCP Companion.
  Manages conversation state, RAG context injection, and tool execution.
  Each session is a GenServer — OTP IS the agent framework.
  """
  use GenServer

  alias SipcpCompanion.AI.Claude
  alias SipcpCompanion.Book
  alias SipcpCompanion.Book.Edits
  alias SipcpCompanion.Conversations

  defstruct [
    :session_id,
    :db_session_id,
    :live_view_pid,
    messages: [],
    current_response: "",
    book_context: nil,
    pending_tool: nil
  ]

  # --- Client API ---

  def start_link(opts) do
    session_id = Keyword.fetch!(opts, :session_id)
    GenServer.start_link(__MODULE__, opts, name: via(session_id))
  end

  def send_message(session_id, text) do
    GenServer.cast(via(session_id), {:user_message, text})
  end

  def resolve_draft(session_id, edit_id, decision) do
    GenServer.cast(via(session_id), {:resolve_draft, edit_id, decision})
  end

  def get_history(session_id) do
    GenServer.call(via(session_id), :get_history)
  end

  # --- Server ---

  @impl true
  def init(opts) do
    state = %__MODULE__{
      session_id: Keyword.fetch!(opts, :session_id),
      db_session_id: Keyword.get(opts, :db_session_id),
      live_view_pid: Keyword.fetch!(opts, :live_view_pid)
    }

    {:ok, state}
  end

  @impl true
  def handle_cast({:user_message, text}, state) do
    context = Book.search(text, limit: 3)
    augmented_text = build_augmented_prompt(text, context)
    messages = state.messages ++ [%{role: "user", content: augmented_text}]

    stream_claude(messages, context, state)

    {:noreply, %{state | messages: messages, current_response: "", book_context: context}}
  end

  @impl true
  def handle_cast({:resolve_draft, edit_id, :approve}, state) do
    Edits.approve_edit(edit_id)

    synthetic = "[O Professor aprovou a proposta de edição. Confirme brevemente e pergunte se deseja continuar editando.]"
    messages = state.messages ++ [%{role: "user", content: synthetic}]

    stream_claude(messages, state.book_context, state)

    {:noreply, %{state | messages: messages, current_response: ""}}
  end

  @impl true
  def handle_cast({:resolve_draft, edit_id, :reject}, state) do
    Edits.reject_edit(edit_id)

    synthetic = "[O Professor rejeitou a proposta de edição. Pergunte o que gostaria de diferente e ofereça uma alternativa.]"
    messages = state.messages ++ [%{role: "user", content: synthetic}]

    stream_claude(messages, state.book_context, state)

    {:noreply, %{state | messages: messages, current_response: ""}}
  end

  # --- Streaming handlers ---

  @impl true
  def handle_info({:ai_delta, text}, state) do
    send(state.live_view_pid, {:ai_delta, text})
    {:noreply, %{state | current_response: state.current_response <> text}}
  end

  @impl true
  def handle_info({:tool_start, name, id}, state) do
    {:noreply, %{state | pending_tool: %{name: name, id: id, input: ""}}}
  end

  @impl true
  def handle_info({:tool_delta, json_fragment}, state) do
    updated_tool = Map.update!(state.pending_tool, :input, &(&1 <> json_fragment))
    {:noreply, %{state | pending_tool: updated_tool}}
  end

  @impl true
  def handle_info(:tool_done, state) do
    %{name: "propose_edit", id: tool_id, input: json} = state.pending_tool

    case Jason.decode(json) do
      {:ok, params} ->
        handle_propose_edit(params, tool_id, state)

      {:error, _} ->
        # Malformed tool input — tell Claude it failed
        messages = append_tool_result(state.messages, tool_id, "Erro ao processar proposta. Tente novamente.")
        stream_claude(messages, state.book_context, state)
        {:noreply, %{state | messages: messages, pending_tool: nil, current_response: ""}}
    end
  end

  @impl true
  def handle_info(:ai_done, state) do
    response = state.current_response

    unless response == "" do
      messages = state.messages ++ [%{role: "assistant", content: response}]
      messages = maybe_condense(messages, state)
      send(state.live_view_pid, :ai_done)
      {:noreply, %{state | messages: messages, current_response: ""}}
    else
      send(state.live_view_pid, :ai_done)
      {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get_history, _from, state) do
    {:reply, state.messages, state}
  end

  # --- Tool handling ---

  defp handle_propose_edit(params, tool_id, state) do
    page = params["page_number"] || 0
    section = params["section"]
    proposed = params["proposed_text"] || ""
    rationale = params["rationale"] || ""

    # Look up original text
    original =
      case Book.search("página #{page} #{section || ""}", limit: 1) do
        [%{content: c} | _] -> c
        _ -> nil
      end

    # Save to DB
    {:ok, edit} =
      Edits.create_pending_edit(state.db_session_id, %{
        page_number: page,
        section: section,
        original_text: original,
        proposed_text: proposed,
        rationale: rationale
      })

    # Notify LiveView
    send(state.live_view_pid, {:proposal_ready, edit})

    # Build tool_result and continue the agentic loop
    # The assistant message with tool_use must be recorded in history
    assistant_tool_msg = %{
      role: "assistant",
      content: [%{
        type: "tool_use",
        id: tool_id,
        name: "propose_edit",
        input: params
      }]
    }

    # Add any text that came before the tool call
    assistant_msg =
      if state.current_response != "" do
        [
          %{role: "assistant", content: [
            %{type: "text", text: state.current_response},
            %{type: "tool_use", id: tool_id, name: "propose_edit", input: params}
          ]}
        ]
      else
        [assistant_tool_msg]
      end

    messages = state.messages ++ assistant_msg
    messages = append_tool_result(messages, tool_id, "Proposta criada e exibida ao Professor. Aguardando aprovação.")

    # Continue — Claude will generate spoken introduction
    stream_claude(messages, state.book_context, state)

    {:noreply, %{state | messages: messages, pending_tool: nil, current_response: ""}}
  end

  defp append_tool_result(messages, tool_id, text) do
    messages ++ [%{
      role: "user",
      content: [%{
        type: "tool_result",
        tool_use_id: tool_id,
        content: text
      }]
    }]
  end

  # --- Condensation ---

  @max_messages 10

  defp maybe_condense(messages, _state) when length(messages) <= @max_messages, do: messages

  defp maybe_condense(messages, state) do
    keep_count = 6
    {old, recent} = Enum.split(messages, length(messages) - keep_count)

    summary = condense_messages(old)

    if state.db_session_id do
      Conversations.update_session_summary(state.db_session_id, summary)
    end

    [%{role: "user", content: "[Resumo da conversa anterior]: #{summary}"}] ++ recent
  end

  defp condense_messages(messages) do
    conversation =
      messages
      |> Enum.filter(&is_binary(&1.content))
      |> Enum.map(fn %{role: role, content: content} ->
        label = if role == "user", do: "Professor", else: "Assistente"
        "#{label}: #{String.slice(content, 0, 200)}"
      end)
      |> Enum.join("\n")

    case Claude.chat(
           [%{role: "user", content: "Resuma esta conversa em 2-3 frases em português:\n\n#{conversation}"}],
           system: "Você é um assistente que resume conversas de forma concisa em português brasileiro.",
           max_tokens: 200
         ) do
      {:ok, summary} -> summary
      {:error, _} -> "Conversa anterior sobre o livro SIPCP."
    end
  end

  # --- Helpers ---

  defp stream_claude(messages, context, _state) do
    Claude.stream(messages,
      stream_to: self(),
      system: system_prompt_with_context(context),
      tools: Claude.book_editing_tools()
    )
  end

  defp build_augmented_prompt(text, []), do: text

  defp build_augmented_prompt(text, context) do
    passages =
      context
      |> Enum.map(fn %{content: c, page: p, section: s} ->
        "[Página #{p} – #{s}]: #{c}"
      end)
      |> Enum.join("\n\n")

    """
    #{text}

    [Trechos relevantes do livro original para referência]:
    #{passages}
    """
  end

  defp system_prompt_with_context(context) do
    base = Claude.default_system_prompt()

    if context && context != [] do
      sections =
        context
        |> Enum.map(& &1.section)
        |> Enum.uniq()
        |> Enum.join(", ")

      base <> "\n\nSeções do livro carregadas no contexto atual: #{sections}"
    else
      base
    end
  end

  defp via(session_id) do
    {:via, Registry, {SipcpCompanion.AgentRegistry, session_id}}
  end
end
