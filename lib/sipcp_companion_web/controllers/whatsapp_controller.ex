defmodule SipcpCompanionWeb.WhatsAppController do
  use SipcpCompanionWeb, :controller

  require Logger

  alias SipcpCompanion.WhatsApp.Bot
  alias SipcpCompanion.AI.Transcription
  alias SipcpCompanion.WhatsApp

  def webhook(conn, %{"event" => "messages.upsert", "data" => data, "sender" => sender}) do
    process_message_event(data, sender)
    json(conn, %{status: "ok"})
  end

  def webhook(conn, %{"event" => "messages.upsert", "data" => data}) do
    process_message_event(data, nil)
    json(conn, %{status: "ok"})
  end

  def webhook(conn, %{"event" => "connection.update", "data" => data}) do
    Logger.info("[WhatsApp] Connection: #{inspect(data["state"])}")
    json(conn, %{status: "ok"})
  end

  def webhook(conn, _params) do
    json(conn, %{status: "ok"})
  end

  defp process_message_event(data, sender) do
    message = extract_message(data, sender)

    if message do
      {from, text} = message

      unless data["key"]["fromMe"] do
        Bot.handle_message(from, text)
      end
    end
  end

  defp extract_message(%{"key" => %{"remoteJid" => jid}} = data, _sender) do
    number =
      cond do
        String.contains?(jid, "@lid") && data["key"]["senderPn"] ->
          data["key"]["senderPn"]

        true ->
          jid |> String.split("@") |> hd()
      end

    text =
      cond do
        data["message"]["conversation"] ->
          data["message"]["conversation"]

        get_in(data, ["message", "extendedTextMessage", "text"]) ->
          get_in(data, ["message", "extendedTextMessage", "text"])

        data["message"]["audioMessage"] ->
          handle_audio(data, number)

        true ->
          nil
      end

    if text, do: {number, text}, else: nil
  rescue
    e ->
      Logger.error("[WhatsApp] Extract error: #{inspect(e)}")
      nil
  end

  defp extract_message(_, _), do: nil

  defp handle_audio(data, _number) do
    # Download audio from Evolution API mediaUrl or WhatsApp URL
    audio_url =
      get_in(data, ["message", "audioMessage", "url"]) ||
        get_in(data, ["message", "audioMessage", "mediaUrl"])

    if audio_url do
      Logger.info("[WhatsApp] Transcribing audio from #{String.slice(audio_url, 0, 60)}...")

      case Transcription.transcribe_from_url(audio_url) do
        {:ok, text} ->
          Logger.info("[WhatsApp] Transcribed: #{String.slice(text, 0, 80)}")
          text

        {:error, reason} ->
          Logger.error("[WhatsApp] Transcription failed: #{inspect(reason)}")
          # Try getting audio via Evolution API media endpoint
          try_evolution_media(data)
      end
    else
      # No URL in message, try Evolution API media endpoint
      try_evolution_media(data)
    end
  end

  defp try_evolution_media(data) do
    message_id = data["key"]["id"]
    instance = data["owner"] || "sipcp-bot"

    # Evolution API v2 media endpoint
    url = "#{WhatsApp.base_url()}/chat/getBase64FromMediaMessage/#{instance}"

    case Req.post(url,
           json: %{message: %{key: data["key"]}, convertToMp4: false},
           headers: [{"apikey", WhatsApp.api_key()}],
           receive_timeout: 30_000
         ) do
      {:ok, %{status: status, body: %{"base64" => b64}}} when status in [200, 201] ->
        audio_bytes = Base.decode64!(b64)

        case Transcription.transcribe(audio_bytes) do
          {:ok, text} ->
            Logger.info("[WhatsApp] Transcribed via media API: #{String.slice(text, 0, 80)}")
            text

          {:error, reason} ->
            Logger.error("[WhatsApp] Transcription failed: #{inspect(reason)}")
            nil
        end

      {:ok, %{status: status, body: body}} ->
        Logger.error("[WhatsApp] Media API failed: #{status} #{inspect(body)}")
        nil

      {:error, reason} ->
        Logger.error("[WhatsApp] Media API error: #{inspect(reason)}")
        nil
    end
  end
end
