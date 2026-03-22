defmodule SipcpCompanion.AI.Transcription do
  @moduledoc """
  Audio transcription using Groq Whisper large-v3.
  Best quality for noisy/elderly speech in Portuguese.
  """

  @groq_url "https://api.groq.com/openai/v1/audio/transcriptions"

  def transcribe(audio_bytes) do
    api_key = System.get_env("GROQ_API_KEY") || raise "GROQ_API_KEY not set"

    # Build multipart form manually
    boundary = "----SipcpBoundary#{:rand.uniform(1_000_000)}"

    body =
      build_multipart(boundary, [
        {:file, "file", "audio.ogg", "audio/ogg", audio_bytes},
        {:field, "model", "whisper-large-v3"},
        {:field, "language", "pt"},
        {:field, "prompt", "Conversa em português brasileiro sobre cibernética, administração industrial, e o livro SIPCP."}
      ])

    case Req.post(@groq_url,
           body: body,
           headers: [
             {"authorization", "Bearer #{api_key}"},
             {"content-type", "multipart/form-data; boundary=#{boundary}"}
           ],
           receive_timeout: 30_000
         ) do
      {:ok, %{status: 200, body: %{"text" => text}}} ->
        {:ok, String.trim(text)}

      {:ok, %{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def transcribe_from_url(url) do
    case Req.get(url, receive_timeout: 30_000) do
      {:ok, %{status: 200, body: audio_bytes}} when is_binary(audio_bytes) ->
        transcribe(audio_bytes)

      {:ok, %{status: status}} ->
        {:error, {:download_failed, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp build_multipart(boundary, parts) do
    parts
    |> Enum.map(fn
      {:file, name, filename, content_type, data} ->
        "--#{boundary}\r\n" <>
          "Content-Disposition: form-data; name=\"#{name}\"; filename=\"#{filename}\"\r\n" <>
          "Content-Type: #{content_type}\r\n\r\n" <>
          data <> "\r\n"

      {:field, name, value} ->
        "--#{boundary}\r\n" <>
          "Content-Disposition: form-data; name=\"#{name}\"\r\n\r\n" <>
          value <> "\r\n"
    end)
    |> Enum.join("")
    |> Kernel.<>("--#{boundary}--\r\n")
  end
end
