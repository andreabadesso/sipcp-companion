defmodule SipcpCompanionWeb.CompanionLive do
  use SipcpCompanionWeb, :live_view

  alias SipcpCompanion.AI.Agent
  alias SipcpCompanion.Conversations

  @impl true
  def mount(_params, _session, socket) do
    session_id = Ecto.UUID.generate()

    if connected?(socket) do
      {:ok, db_session} = Conversations.create_session(%{title: "Sessão #{Date.utc_today()}"})

      Agent.start_link(
        session_id: session_id,
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
  def handle_event("update_input", %{"text" => text}, socket) do
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
     |> push_event("speak", %{text: response})
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

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="companion"
      class="h-screen flex flex-col paper-texture"
      phx-hook="SpeechHook"
    >
      <%!-- ═══ Header — like a book spine ═══ --%>
      <header class="shrink-0 px-6 pt-6 pb-4">
        <div class="max-w-3xl mx-auto">
          <div class="flex items-center justify-center gap-4">
            <div class="w-10 h-10 rounded-full flex items-center justify-center"
                 style="background: radial-gradient(circle at 40% 35%, var(--gold-bright), var(--gold-dim));">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
              </svg>
            </div>
            <div class="text-center">
              <h1 class="font-serif text-2xl md:text-3xl font-bold tracking-wide" style="color: var(--ink);">
                SIPCP Companion
              </h1>
              <p class="font-sans text-sm md:text-base font-medium tracking-widest uppercase mt-0.5" style="color: var(--ink-faded);">
                Assistente do Professor Fernando
              </p>
            </div>
          </div>
          <div class="gold-rule mt-4"></div>
        </div>
      </header>

      <%!-- ═══ Chat Area ═══ --%>
      <main
        id="chat-area"
        class="flex-1 overflow-y-auto px-4 md:px-8"
        phx-hook="ScrollHook"
      >
        <div class="max-w-3xl mx-auto py-6 space-y-5">

          <%!-- Welcome — empty state --%>
          <div :if={@messages == [] && @current_response == ""} class="py-8 md:py-16">
            <div class="text-center mb-10">
              <div class="inline-block mb-6">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-16 md:w-20 md:h-20 mx-auto" style="color: var(--gold);" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="0.8">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
                </svg>
              </div>
              <h2 class="font-serif text-3xl md:text-4xl font-bold mb-3" style="color: var(--ink);">
                Bem-vindo, Professor.
              </h2>
              <p class="font-serif text-xl md:text-2xl leading-relaxed max-w-xl mx-auto" style="color: var(--ink-light);">
                Estou aqui para ajudá-lo a dar nova vida ao seu livro.
                Fale comigo ou escreva abaixo.
              </p>
            </div>

            <div class="gold-rule max-w-xs mx-auto mb-8"></div>

            <div class="space-y-4 max-w-lg mx-auto">
              <p class="font-sans text-base text-center uppercase tracking-widest mb-4" style="color: var(--ink-faded);">
                Experimente perguntar
              </p>
              <button
                phx-click="send_message"
                phx-value-text="Como posso atualizar o capítulo sobre feedback cibernético com conceitos de Indústria 4.0?"
                class="w-full text-left rounded-xl px-5 py-4 font-serif text-lg md:text-xl transition-all duration-200 cursor-pointer"
                style="background: var(--warm-white); color: var(--ink-light); border: 1px solid var(--parchment-deep);"
                onmouseover="this.style.borderColor='var(--gold)'; this.style.background='var(--cream)'"
                onmouseout="this.style.borderColor='var(--parchment-deep)'; this.style.background='var(--warm-white)'"
              >
                "Como atualizar o capítulo sobre feedback cibernético?"
              </button>
              <button
                phx-click="send_message"
                phx-value-text="Me mostre o que escrevi sobre a Lei do Valor Ótimo."
                class="w-full text-left rounded-xl px-5 py-4 font-serif text-lg md:text-xl transition-all duration-200 cursor-pointer"
                style="background: var(--warm-white); color: var(--ink-light); border: 1px solid var(--parchment-deep);"
                onmouseover="this.style.borderColor='var(--gold)'; this.style.background='var(--cream)'"
                onmouseout="this.style.borderColor='var(--parchment-deep)'; this.style.background='var(--warm-white)'"
              >
                "Me mostre o que escrevi sobre a Lei do Valor Ótimo."
              </button>
            </div>
          </div>

          <%!-- Messages --%>
          <div :for={msg <- @messages} class={[
            "rounded-xl px-6 py-5 msg-enter",
            if(msg.role == "user", do: "msg-user", else: "msg-assistant")
          ]}>
            <div class="flex items-center gap-3 mb-3">
              <div :if={msg.role == "user"} class="w-8 h-8 rounded-full flex items-center justify-center shrink-0"
                   style="background: var(--gold); color: white;">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0" />
                </svg>
              </div>
              <div :if={msg.role == "assistant"} class="w-8 h-8 rounded-full flex items-center justify-center shrink-0"
                   style="background: var(--leather); color: white;">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
                </svg>
              </div>
              <span class="font-sans text-sm font-semibold uppercase tracking-wider" style="color: var(--ink-faded);">
                {if msg.role == "user", do: "Professor", else: "Assistente"}
              </span>
            </div>
            <div class="font-serif text-lg md:text-xl leading-relaxed whitespace-pre-wrap pl-11" style="color: var(--ink);">
              {msg.content}
            </div>
          </div>

          <%!-- Streaming response --%>
          <div :if={@current_response != ""} class="msg-assistant rounded-xl px-6 py-5 msg-enter">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-8 h-8 rounded-full flex items-center justify-center shrink-0"
                   style="background: var(--leather); color: white;">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
                </svg>
              </div>
              <span class="font-sans text-sm font-semibold uppercase tracking-wider" style="color: var(--ink-faded);">
                Assistente
              </span>
              <span class="inline-block w-2 h-2 rounded-full animate-pulse" style="background: var(--gold);"></span>
            </div>
            <div class="font-serif text-lg md:text-xl leading-relaxed whitespace-pre-wrap pl-11" style="color: var(--ink);">
              {@current_response}<span class="inline-block w-0.5 h-5 ml-0.5 animate-pulse" style="background: var(--ink);"></span>
            </div>
          </div>

          <%!-- Thinking indicator --%>
          <div :if={@streaming && @current_response == ""} class="flex items-center gap-4 px-6 py-5 msg-enter">
            <div class="w-8 h-8 rounded-full flex items-center justify-center shrink-0"
                 style="background: var(--leather); color: white;">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
              </svg>
            </div>
            <div class="thinking-dots flex gap-1.5">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>

        </div>
      </main>

      <%!-- ═══ Input Area ═══ --%>
      <footer class="shrink-0" style="background: var(--cream); border-top: 1px solid var(--parchment-deep);">
        <div class="max-w-3xl mx-auto px-4 md:px-8 py-4">

          <%!-- Voice Button — the hero --%>
          <div class="flex justify-center mb-4">
            <button
              id="voice-btn"
              phx-click="toggle_listen"
              disabled={@streaming}
              class={[
                "rounded-full w-20 h-20 md:w-24 md:h-24 flex items-center justify-center",
                "text-white cursor-pointer",
                "focus:outline-none focus:ring-4 focus:ring-[var(--gold)]/30",
                "disabled:opacity-40 disabled:cursor-not-allowed",
                if(@listening, do: "voice-btn-active", else: "voice-btn-idle")
              ]}
              data-listening={to_string(@listening)}
              aria-label={if @listening, do: "Parar de ouvir", else: "Falar"}
            >
              <div :if={!@listening}>
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 md:w-10 md:h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 18.75a6 6 0 006-6v-1.5m-6 7.5a6 6 0 01-6-6v-1.5m6 7.5v3.75m-3.75 0h7.5M12 15.75a3 3 0 01-3-3V4.5a3 3 0 116 0v8.25a3 3 0 01-3 3z" />
                </svg>
              </div>
              <div :if={@listening} class="sound-wave">
                <div class="bar"></div>
                <div class="bar"></div>
                <div class="bar"></div>
                <div class="bar"></div>
                <div class="bar"></div>
              </div>
            </button>
          </div>

          <p class="text-center font-sans text-base mb-4" style={if @listening, do: "color: var(--voice-active); font-weight: 600;", else: "color: var(--ink-faded);"}>
            {if @listening, do: "Ouvindo... fale agora", else: "Toque no microfone para falar"}
          </p>

          <%!-- Text input — secondary but always available --%>
          <form phx-submit="send_message" class="flex gap-3 items-end">
            <div class="flex-1">
              <textarea
                id="message-input"
                name="text"
                value={@input_text}
                phx-change="update_input"
                placeholder="Ou escreva sua mensagem aqui..."
                rows="2"
                class="input-field w-full rounded-xl px-5 py-3 font-serif text-lg md:text-xl resize-none transition-all duration-200"
                style={"background: var(--warm-white); color: var(--ink); border: 1.5px solid var(--parchment-deep); #{if @streaming, do: "opacity: 0.5;", else: ""}"}
                disabled={@streaming}
              />
            </div>
            <button
              type="submit"
              disabled={@streaming}
              class="rounded-xl px-5 py-3 font-sans text-base font-semibold text-white cursor-pointer transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
              style="background: var(--leather); hover: var(--leather-dark);"
              onmouseover="this.style.background='var(--leather-dark)'"
              onmouseout="this.style.background='var(--leather)'"
            >
              Enviar
            </button>
          </form>

        </div>
      </footer>
    </div>
    """
  end
end
