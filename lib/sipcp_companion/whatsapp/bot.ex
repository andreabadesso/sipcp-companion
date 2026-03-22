defmodule SipcpCompanion.WhatsApp.Bot do
  @moduledoc """
  WhatsApp bot that processes incoming messages.
  Each phone number gets its own conversation context.
  """

  require Logger

  alias SipcpCompanion.AI.Claude
  alias SipcpCompanion.Book
  alias SipcpCompanion.Conversations
  alias SipcpCompanion.WhatsApp

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def handle_message(from_number, text) do
    Task.start(fn ->
      process_message(from_number, text)
    end)
  end

  defp process_message(from_number, text) do
    Logger.info("[WhatsApp Bot] Message from #{from_number}: #{String.slice(text, 0, 50)}")

    state = get_state(from_number)

    # Search book context
    context = Book.search(text, limit: 3)

    # Build message with context available but Claude decides relevance
    augmented = build_prompt(text, context)
    messages = state.messages ++ [%{role: "user", content: augmented}]

    system = system_prompt()

    case Claude.chat(messages, system: system, tools: Claude.book_editing_tools()) do
      {:ok, response} ->
        updated_messages = messages ++ [%{role: "assistant", content: response}]
        update_state(from_number, %{state | messages: maybe_condense(updated_messages)})

        if state.db_session_id do
          Conversations.add_message(state.db_session_id, "user", text)
          Conversations.add_message(state.db_session_id, "assistant", response)
        end

        WhatsApp.send_text(from_number, response)

        Logger.info("[WhatsApp Bot] Generating TTS audio...")
        send_audio_response(from_number, response)
        Logger.info("[WhatsApp Bot] Audio send complete")

      {:error, reason} ->
        Logger.error("[WhatsApp Bot] Claude error: #{inspect(reason)}")
        WhatsApp.send_text(from_number, "Desculpe, tive um problema técnico. Pode repetir?")
    end
  end

  defp send_audio_response(from_number, text) do
    clean_text =
      text
      |> String.replace(~r/[#*_`~\[\]()]/, "")
      |> String.replace(~r/\n+/, ". ")
      |> String.slice(0, 3000)

    case generate_audio(clean_text) do
      {:ok, audio_bytes} ->
        Logger.info("[WhatsApp Bot] TTS generated #{byte_size(audio_bytes)} bytes, sending...")
        audio_b64 = Base.encode64(audio_bytes)
        result = WhatsApp.send_audio(from_number, audio_b64)
        Logger.info("[WhatsApp Bot] Audio send result: #{inspect(elem(result, 0))}")

      {:error, reason} ->
        Logger.warning("[WhatsApp Bot] TTS failed: #{inspect(reason)}")
    end
  end

  defp generate_audio(text) do
    config = Application.fetch_env!(:sipcp_companion, :elevenlabs)
    voice_id = Keyword.fetch!(config, :voice_id)
    model_id = Keyword.fetch!(config, :model_id)

    url = "https://api.elevenlabs.io/v1/text-to-speech/#{voice_id}"

    body = %{
      text: text,
      model_id: model_id,
      voice_settings: %{
        stability: Keyword.fetch!(config, :stability),
        similarity_boost: Keyword.fetch!(config, :similarity_boost),
        style: Keyword.fetch!(config, :style),
        use_speaker_boost: Keyword.fetch!(config, :use_speaker_boost)
      }
    }

    api_key = System.get_env("ELEVENLABS_API_KEY") || raise "ELEVENLABS_API_KEY not set"

    case Req.post(url,
           json: body,
           headers: [{"xi-api-key", api_key}, {"Accept", "audio/mpeg"}],
           receive_timeout: 60_000
         ) do
      {:ok, %{status: 200, body: audio_bytes}} -> {:ok, audio_bytes}
      {:ok, %{status: status, body: body}} -> {:error, {status, body}}
      {:error, reason} -> {:error, reason}
    end
  end

  # --- State ---

  defp get_state(number) do
    Agent.get(__MODULE__, fn states -> Map.get(states, number) end) || create_state(number)
  end

  defp create_state(number) do
    {:ok, session} = Conversations.create_session(%{title: "WhatsApp #{number}"})
    state = %{messages: [], db_session_id: session.id}
    update_state(number, state)
    state
  end

  defp update_state(number, state) do
    Agent.update(__MODULE__, fn states -> Map.put(states, number, state) end)
  end

  # --- Condensation ---

  defp maybe_condense(messages) when length(messages) <= 10, do: messages

  defp maybe_condense(messages) do
    {old, recent} = Enum.split(messages, length(messages) - 6)

    summary =
      old
      |> Enum.filter(&is_binary(&1.content))
      |> Enum.map(fn %{role: r, content: c} ->
        label = if r == "user", do: "Fernando", else: "Assistente"
        "#{label}: #{String.slice(c, 0, 150)}"
      end)
      |> Enum.join("\n")

    case Claude.chat(
           [%{role: "user", content: "Resuma em 2 frases:\n\n#{summary}"}],
           system: "Resuma conversas em português brasileiro.",
           max_tokens: 150
         ) do
      {:ok, s} -> [%{role: "user", content: "[Resumo]: #{s}"}] ++ recent
      _ -> recent
    end
  end

  # --- Helpers ---

  defp build_prompt(text, []), do: text

  defp build_prompt(text, context) do
    passages =
      context
      |> Enum.map(fn %{content: c, page: p, section: s} ->
        "[Pág. #{p} – #{s}]: #{String.slice(c, 0, 300)}"
      end)
      |> Enum.join("\n\n")

    "#{text}\n\n[Trechos do livro disponíveis para referência, use SOMENTE se relevante para a pergunta]:\n#{passages}"
  end

  defp system_prompt do
    Claude.default_system_prompt() <>
      """

      REGRA ADICIONAL PARA WHATSAPP:
      - Você está conversando via WhatsApp. Respostas curtas e diretas — máximo 3 parágrafos.
      - Se o Sr. Fernando fizer uma saudação simples (oi, olá, bom dia), responda apenas com uma saudação calorosa e breve. NÃO mencione trechos do livro, páginas ou seções — ele só está dizendo oi.
      - Os trechos do livro anexados à mensagem são apenas referência. Use-os SOMENTE quando a pergunta for sobre o conteúdo do livro. Ignore-os completamente para saudações e conversas casuais.
      """
  end
end
