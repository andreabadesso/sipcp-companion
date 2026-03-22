defmodule SipcpCompanion.WhatsApp do
  @moduledoc """
  WhatsApp integration via Evolution API.
  Handles sending text and audio messages.
  """

  @instance "sipcp-bot"

  def base_url, do: System.get_env("EVOLUTION_API_URL") || "http://localhost:8082"
  def api_key, do: System.get_env("EVOLUTION_API_KEY") || raise("EVOLUTION_API_KEY not set")

  def send_text(number, text) do
    url = "#{base_url()}/message/sendText/#{@instance}"

    Req.post(url,
      json: %{number: number, text: text},
      headers: [{"apikey", api_key()}]
    )
  end

  def send_audio(number, audio_base64) do
    url = "#{base_url()}/message/sendWhatsAppAudio/#{@instance}"

    Req.post(url,
      json: %{
        number: number,
        audio: audio_base64
      },
      headers: [{"apikey", api_key()}]
    )
  end

  def create_instance do
    url = "#{base_url()}/instance/create"

    Req.post(url,
      json: %{
        instanceName: @instance,
        integration: "WHATSAPP-BAILEYS",
        qrcode: true,
        webhook: %{
          url: webhook_url(),
          enabled: true,
          webhookByEvents: true,
          events: ["MESSAGES_UPSERT", "CONNECTION_UPDATE", "QRCODE_UPDATED"]
        }
      },
      headers: [{"apikey", api_key()}]
    )
  end

  def get_qrcode do
    url = "#{base_url()}/instance/connect/#{@instance}"

    Req.get(url, headers: [{"apikey", api_key()}])
  end

  def instance_status do
    url = "#{base_url()}/instance/connectionState/#{@instance}"

    Req.get(url, headers: [{"apikey", api_key()}])
  end

  def delete_instance do
    url = "#{base_url()}/instance/delete/#{@instance}"

    Req.delete(url, headers: [{"apikey", api_key()}])
  end

  defp webhook_url do
    System.get_env("WEBHOOK_URL") || "http://172.17.0.1:4000/api/whatsapp/webhook"
  end
end
