defmodule SipcpCompanion.AI.ElevenLabs do
  @moduledoc """
  ElevenLabs TTS streaming client.
  Streams audio chunks from the ElevenLabs API directly to a Plug.Conn.
  """

  @api_base "https://api.elevenlabs.io/v1"

  def stream_to_conn(conn, text) do
    voice_id = config(:voice_id)
    model_id = config(:model_id)
    url = "#{@api_base}/text-to-speech/#{voice_id}/stream"

    body = %{
      text: clean_text(text),
      model_id: model_id,
      voice_settings: %{
        stability: config(:stability),
        similarity_boost: config(:similarity_boost),
        style: config(:style),
        use_speaker_boost: config(:use_speaker_boost)
      }
    }

    Req.post!(url,
      json: body,
      headers: [
        {"xi-api-key", api_key()},
        {"Accept", "audio/mpeg"}
      ],
      receive_timeout: 60_000,
      into: fn {:data, chunk}, {req, resp} ->
        case Plug.Conn.chunk(conn, chunk) do
          {:ok, _conn} -> {:cont, {req, resp}}
          {:error, _} -> {:halt, {req, resp}}
        end
      end
    )

    conn
  end

  defp clean_text(text) do
    text
    |> String.replace(~r/[#*_`~\[\]()]/, "")
    |> String.replace(~r/\n+/, ". ")
    |> String.slice(0, 3000)
  end

  defp api_key do
    System.get_env("ELEVENLABS_API_KEY") ||
      raise "ELEVENLABS_API_KEY not set"
  end

  defp config(key) do
    Application.fetch_env!(:sipcp_companion, :elevenlabs)
    |> Keyword.fetch!(key)
  end
end
