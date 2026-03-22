defmodule SipcpCompanionWeb.AdminController do
  use SipcpCompanionWeb, :controller

  alias SipcpCompanion.WhatsApp

  def status(conn, _params) do
    case WhatsApp.instance_status() do
      {:ok, %{status: 200, body: body}} -> json(conn, body)
      {:ok, %{body: body}} -> json(conn, %{error: body})
      {:error, reason} -> json(conn, %{error: inspect(reason)})
    end
  end

  def create_instance(conn, _params) do
    case WhatsApp.create_instance() do
      {:ok, %{status: status, body: body}} when status in [200, 201] -> json(conn, body)
      {:ok, %{body: body}} -> json(conn, %{error: body})
      {:error, reason} -> json(conn, %{error: inspect(reason)})
    end
  end

  def qrcode(conn, _params) do
    case WhatsApp.get_qrcode() do
      {:ok, %{status: 200, body: %{"base64" => b64}}} when b64 != nil ->
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, """
        <html>
        <head><title>SIPCP WhatsApp QR</title></head>
        <body style="display:flex;justify-content:center;align-items:center;height:100vh;background:#1a1a1a;">
          <div style="text-align:center;">
            <h1 style="color:white;font-family:sans-serif;">Escanear com WhatsApp</h1>
            <img src="#{b64}" style="width:400px;height:400px;" />
            <p style="color:#888;font-family:sans-serif;">Configurações → Aparelhos Conectados → Conectar</p>
            <p style="color:#666;font-family:sans-serif;"><a href="/admin/status" style="color:#4a9;">Ver status</a></p>
          </div>
        </body>
        </html>
        """)

      {:ok, %{status: 200, body: %{"code" => code}}} when code != nil ->
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, """
        <html>
        <head>
          <title>SIPCP WhatsApp QR</title>
          <script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
        </head>
        <body style="display:flex;justify-content:center;align-items:center;height:100vh;background:#1a1a1a;">
          <div style="text-align:center;">
            <h1 style="color:white;font-family:sans-serif;">Escanear com WhatsApp</h1>
            <canvas id="qr" style="width:400px;height:400px;"></canvas>
            <p style="color:#888;font-family:sans-serif;">Configurações → Aparelhos Conectados → Conectar</p>
            <p style="color:#666;font-family:sans-serif;"><a href="/admin/status" style="color:#4a9;">Ver status</a></p>
            <script>QRCode.toCanvas(document.getElementById('qr'), '#{code}', {width:400})</script>
          </div>
        </body>
        </html>
        """)

      {:ok, %{status: 200, body: body}} ->
        json(conn, %{status: "waiting", message: "QR not ready yet. Try again in a few seconds.", raw: body})

      {:ok, %{body: body}} ->
        json(conn, %{error: "Instance not found. Create one first at /admin/setup", raw: body})

      {:error, reason} ->
        json(conn, %{error: inspect(reason)})
    end
  end

  def setup(conn, _params) do
    # Delete existing instance if any
    WhatsApp.delete_instance()
    Process.sleep(2000)

    # Create new instance
    case WhatsApp.create_instance() do
      {:ok, %{status: status, body: body}} when status in [200, 201] ->
        # Wait for QR to generate
        Process.sleep(5000)
        redirect(conn, to: "/admin/qr")

      {:ok, %{body: body}} ->
        json(conn, %{error: "Failed to create instance", details: body})

      {:error, reason} ->
        json(conn, %{error: inspect(reason)})
    end
  end
end
