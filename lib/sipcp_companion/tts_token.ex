defmodule SipcpCompanion.TtsToken do
  @moduledoc """
  Short-lived signed tokens for TTS audio streaming.
  Prevents the /tts endpoint from being an open proxy.
  """

  @salt "tts_token"
  @max_age 120

  def sign(text) do
    Phoenix.Token.sign(SipcpCompanionWeb.Endpoint, @salt, text)
  end

  def verify(token) do
    Phoenix.Token.verify(SipcpCompanionWeb.Endpoint, @salt, token, max_age: @max_age)
  end
end
