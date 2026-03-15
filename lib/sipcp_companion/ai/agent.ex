defmodule SipcpCompanion.AI.Agent do
  @moduledoc """
  Agentic AI loop for the SIPCP Companion.
  Manages conversation state, RAG context injection, and tool execution.
  Each session is a GenServer — OTP IS the agent framework.
  """
  use GenServer

  alias SipcpCompanion.AI.Claude
  alias SipcpCompanion.Book

  defstruct [
    :session_id,
    :live_view_pid,
    messages: [],
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

    {:noreply, %{state | messages: messages, book_context: context}}
  end

  @impl true
  def handle_info({:ai_delta, text}, state) do
    send(state.live_view_pid, {:ai_delta, text})
    {:noreply, state}
  end

  @impl true
  def handle_info(:ai_done, state) do
    send(state.live_view_pid, :ai_done)
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_history, _from, state) do
    {:reply, state.messages, state}
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
