defmodule SipcpCompanionWeb.TtsController do
  use SipcpCompanionWeb, :controller

  alias SipcpCompanion.TtsToken
  alias SipcpCompanion.AI.ElevenLabs

  def stream(conn, %{"token" => token}) do
    case TtsToken.verify(token) do
      {:ok, text} ->
        conn
        |> put_resp_content_type("audio/mpeg")
        |> put_resp_header("cache-control", "no-store")
        |> send_chunked(200)
        |> ElevenLabs.stream_to_conn(text)

      {:error, _reason} ->
        conn
        |> put_status(403)
        |> json(%{error: "invalid or expired token"})
    end
  end

  def stream(conn, _params) do
    conn |> put_status(400) |> json(%{error: "missing token"})
  end
end
