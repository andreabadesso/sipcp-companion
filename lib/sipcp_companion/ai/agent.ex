defmodule SipcpCompanion.AI.Agent do
  @moduledoc """
  Agentic AI loop for the SIPCP Companion.
  Manages conversation state, RAG context injection, and tool execution.
  Each session is a GenServer — OTP IS the agent framework.
  """
  use GenServer

  alias SipcpCompanion.AI.Claude
  alias SipcpCompanion.Book
  alias SipcpCompanion.Conversations

  defstruct [
    :session_id,
    :db_session_id,
    :live_view_pid,
    messages: [],
    current_response: "",
    book_context: nil
  ]

  # --- Client API ---

  def start_link(opts) do
    session_id = Keyword.fetch!(opts, :session_id)
    GenServer.start_link(__MODULE__, opts, name: via(session_id))
  end

  def send_message(session_id, text) do
    GenServer.cast(via(session_id), {:user_message, text})
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
    # 1. Search relevant book passages via RAG
    context = Book.search(text, limit: 3)

    # 2. Build augmented message with book context
    augmented_text = build_augmented_prompt(text, context)

    # 3. Add to conversation history
    messages = state.messages ++ [%{role: "user", content: augmented_text}]

    # 4. Stream response from Claude
    Claude.stream(messages,
      stream_to: self(),
      system: system_prompt_with_context(context)
    )

    {:noreply, %{state | messages: messages, current_response: "", book_context: context}}
  end

  @impl true
  def handle_info({:ai_delta, text}, state) do
    send(state.live_view_pid, {:ai_delta, text})
    {:noreply, %{state | current_response: state.current_response <> text}}
  end

  @impl true
  def handle_info(:ai_done, state) do
    response = state.current_response

    # Store assistant reply in conversation history for multi-turn coherence
    messages = state.messages ++ [%{role: "assistant", content: response}]

    send(state.live_view_pid, :ai_done)

    # Condense conversation if it's getting long
    messages = maybe_condense(messages, state)

    {:noreply, %{state | messages: messages, current_response: ""}}
  end

  @impl true
  def handle_call(:get_history, _from, state) do
    {:reply, state.messages, state}
  end

  # --- Condensation ---

  # Keep last 6 messages (3 turns) + a summary of older ones
  @max_messages 10

  defp maybe_condense(messages, _state) when length(messages) <= @max_messages, do: messages

  defp maybe_condense(messages, state) do
    # Split: older messages to summarize, recent to keep
    keep_count = 6
    {old, recent} = Enum.split(messages, length(messages) - keep_count)

    summary = condense_messages(old)

    # Persist summary to DB if we have a db_session_id
    if state.db_session_id do
      Conversations.update_session_summary(state.db_session_id, summary)
    end

    [%{role: "user", content: "[Resumo da conversa anterior]: #{summary}"}] ++ recent
  end

  defp condense_messages(messages) do
    conversation =
      messages
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

  # --- Private ---

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

    if context != [] do
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
