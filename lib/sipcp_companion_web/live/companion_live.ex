defmodule SipcpCompanionWeb.CompanionLive do
  use SipcpCompanionWeb, :live_view

  alias SipcpCompanion.AI.Agent
  alias SipcpCompanion.Conversations
  alias SipcpCompanion.TtsToken

  @impl true
  def mount(_params, _session, socket) do
    session_id = Ecto.UUID.generate()

    if connected?(socket) do
      {:ok, db_session} = Conversations.create_session(%{title: "Sessão #{Date.utc_today()}"})

      Agent.start_link(
        session_id: session_id,
        db_session_id: db_session.id,
        live_view_pid: self()
      )

      {:ok,
       socket
       |> assign(
         session_id: session_id,
         db_session_id: db_session.id,
         messages: [],
         current_response: "",
         streaming: false,
         listening: false,
         input_text: ""
       )}
    else
      {:ok,
       socket
       |> assign(
         session_id: nil,
         db_session_id: nil,
         messages: [],
         current_response: "",
         streaming: false,
         listening: false,
         input_text: ""
       )}
    end
  end

  @impl true
  def handle_event("send_message", %{"text" => text}, socket) when text != "" do
    send_user_message(socket, String.trim(text))
  end

  def handle_event("send_message", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("voice_text", %{"text" => text}, socket) when text != "" do
    send_user_message(socket, String.trim(text))
  end

  def handle_event("voice_text", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("toggle_listen", _, socket) do
    {:noreply, assign(socket, listening: !socket.assigns.listening)}
  end

  @impl true
  def handle_event("update_input", params, socket) do
    text = params["text"] || ""
    {:noreply, assign(socket, input_text: text)}
  end

  @impl true
  def handle_info({:ai_delta, text}, socket) do
    {:noreply,
     socket
     |> assign(current_response: socket.assigns.current_response <> text)
     |> push_event("scroll_down", %{})}
  end

  @impl true
  def handle_info(:ai_done, socket) do
    response = socket.assigns.current_response

    Conversations.add_message(socket.assigns.db_session_id, "assistant", response)

    messages =
      socket.assigns.messages ++ [%{role: "assistant", content: response}]

    {:noreply,
     socket
     |> assign(
       messages: messages,
       current_response: "",
       streaming: false
     )
     |> push_event("speak_url", %{url: "/tts?token=#{URI.encode_www_form(TtsToken.sign(response))}"})
     |> push_event("scroll_down", %{})}
  end

  defp send_user_message(socket, text) do
    Conversations.add_message(socket.assigns.db_session_id, "user", text)

    messages = socket.assigns.messages ++ [%{role: "user", content: text}]

    Agent.send_message(socket.assigns.session_id, text)

    {:noreply,
     socket
     |> assign(
       messages: messages,
       streaming: true,
       current_response: "",
       listening: false,
       input_text: ""
     )
     |> push_event("scroll_down", %{})}
  end

  defp clean_markdown(text) do
    text
    |> String.replace(~r/^\#{1,4}\s+/m, "")
    |> String.replace(~r/\*\*(.+?)\*\*/, "\\1")
    |> String.replace(~r/\*(.+?)\*/, "\\1")
    |> String.replace(~r/`(.+?)`/, "\\1")
    |> String.replace(~r/^\s*[-*]\s+/m, "• ")
    |> String.replace(~r/^\s*\d+\.\s+/m, "")
    |> String.replace(~r/\|[-:]+\|[-:|\s]+\n?/, "")
    |> String.replace(~r/\n{3,}/, "\n\n")
    |> String.trim()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="companion"
      class="h-dvh flex flex-col paper-texture"
      phx-hook="SpeechHook"
    >
      <%!-- ═══ Header — thin, elegant ═══ --%>
      <header class="shrink-0 px-4 py-2" style="border-bottom: 1px solid var(--parchment-deep);">
        <div class="max-w-2xl mx-auto flex items-center justify-center gap-2">
          <span class="font-serif text-base font-bold tracking-wide" style="color: var(--ink);">
            SIPCP
          </span>
          <span class="font-sans text-xs font-medium tracking-widest uppercase" style="color: var(--ink-faded);">
            Companion
          </span>
        </div>
      </header>

      <%!-- ═══ Chat Area ═══ --%>
      <main
        id="chat-area"
        class="flex-1 overflow-y-auto px-3 md:px-6"
        phx-hook="ScrollHook"
      >
        <div class="max-w-2xl mx-auto py-3 space-y-2">

          <%!-- Welcome --%>
          <div :if={@messages == [] && @current_response == ""} class="py-8 md:py-14">
            <div class="text-center mb-6">
              <h2 class="font-serif text-2xl md:text-3xl font-bold mb-3" style="color: var(--ink);">
                Bem-vindo, Professor.
              </h2>
              <p class="font-serif text-lg md:text-xl leading-relaxed max-w-md mx-auto" style="color: var(--ink-light);">
                Estou aqui para ajudá-lo com o seu livro. Fale ou escreva abaixo.
              </p>
            </div>

            <div class="gold-rule max-w-32 mx-auto mb-6"></div>

            <div class="space-y-3 max-w-md mx-auto">
              <button
                phx-click="send_message"
                phx-value-text="Como posso atualizar o capítulo sobre feedback cibernético com conceitos de Indústria 4.0?"
                class="w-full text-left rounded-lg px-4 py-3 font-serif text-base md:text-lg transition-all duration-200 cursor-pointer"
                style="background: var(--warm-white); color: var(--ink-light); border: 1px solid var(--parchment-deep);"
              >
                "Como atualizar o capítulo sobre feedback cibernético?"
              </button>
              <button
                phx-click="send_message"
                phx-value-text="Me mostre o que escrevi sobre a Lei do Valor Ótimo."
                class="w-full text-left rounded-lg px-4 py-3 font-serif text-base md:text-lg transition-all duration-200 cursor-pointer"
                style="background: var(--warm-white); color: var(--ink-light); border: 1px solid var(--parchment-deep);"
              >
                "Me mostre o que escrevi sobre a Lei do Valor Ótimo."
              </button>
            </div>
          </div>

          <%!-- Messages --%>
          <div :for={msg <- @messages} class={[
            "rounded-lg px-4 py-3 msg-enter",
            if(msg.role == "user", do: "msg-user", else: "msg-assistant")
          ]}>
            <div class="flex items-center gap-1.5 mb-1">
              <span class="font-sans text-xs font-bold uppercase tracking-widest" style="color: var(--ink-faded);">
                {if msg.role == "user", do: "Professor", else: "Assistente"}
              </span>
            </div>
            <div class="font-serif text-lg md:text-xl leading-relaxed whitespace-pre-wrap" style="color: var(--ink);">
              {clean_markdown(msg.content)}
            </div>
          </div>

          <%!-- Streaming response --%>
          <div :if={@current_response != ""} class="msg-assistant rounded-lg px-4 py-3 msg-enter">
            <div class="flex items-center gap-1.5 mb-1">
              <span class="font-sans text-xs font-bold uppercase tracking-widest" style="color: var(--ink-faded);">
                Assistente
              </span>
              <span class="inline-block w-1.5 h-1.5 rounded-full animate-pulse" style="background: var(--gold);"></span>
            </div>
            <div class="font-serif text-lg md:text-xl leading-relaxed whitespace-pre-wrap" style="color: var(--ink);">
              {clean_markdown(@current_response)}<span class="inline-block w-0.5 h-5 ml-0.5 animate-pulse" style="background: var(--ink);"></span>
            </div>
          </div>

          <%!-- Thinking indicator — BIG and obvious --%>
          <div :if={@streaming && @current_response == ""} class="loading-overlay rounded-lg px-4 py-6 msg-enter text-center">
            <div class="thinking-dots flex gap-2 justify-center mb-2">
              <span></span>
              <span></span>
              <span></span>
            </div>
            <span class="font-serif text-base" style="color: var(--ink-faded);">
              Preparando resposta...
            </span>
          </div>

        </div>
      </main>

      <%!-- ═══ Input — single compact row ═══ --%>
      <footer class="shrink-0 safe-bottom" style="background: var(--cream); border-top: 1px solid var(--parchment-deep);">
        <form phx-submit="send_message" class="max-w-2xl mx-auto px-3 py-2 flex items-center gap-2">
          <button
            type="button"
            id="voice-btn"
            phx-click="toggle_listen"
            disabled={@streaming}
            class={[
              "shrink-0 rounded-full w-10 h-10 flex items-center justify-center",
              "text-white cursor-pointer",
              "focus:outline-none",
              "disabled:opacity-40 disabled:cursor-not-allowed",
              if(@listening, do: "voice-btn-active", else: "voice-btn-idle")
            ]}
            data-listening={to_string(@listening)}
            aria-label={if @listening, do: "Parar de ouvir", else: "Falar"}
          >
            <div :if={!@listening}>
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 18.75a6 6 0 006-6v-1.5m-6 7.5a6 6 0 01-6-6v-1.5m6 7.5v3.75m-3.75 0h7.5M12 15.75a3 3 0 01-3-3V4.5a3 3 0 116 0v8.25a3 3 0 01-3 3z" />
              </svg>
            </div>
            <div :if={@listening} class="sound-wave-sm">
              <div class="bar"></div>
              <div class="bar"></div>
              <div class="bar"></div>
            </div>
          </button>

          <input
            type="text"
            id="message-input"
            name="text"
            value={@input_text}
            placeholder="Escreva aqui..."
            autocomplete="off"
            class="input-field flex-1 rounded-lg px-3 py-2.5 font-serif text-base md:text-lg resize-none transition-all duration-200"
            style={"background: var(--warm-white); color: var(--ink); border: 1px solid var(--parchment-deep); #{if @streaming, do: "opacity: 0.5;", else: ""}"}
            disabled={@streaming}
          />

          <button
            type="submit"
            disabled={@streaming}
            class="shrink-0 rounded-lg px-4 py-2.5 font-sans text-sm font-bold text-white cursor-pointer transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
            style="background: var(--leather);"
          >
            Enviar
          </button>
        </form>
      </footer>
    </div>
    """
  end
end
