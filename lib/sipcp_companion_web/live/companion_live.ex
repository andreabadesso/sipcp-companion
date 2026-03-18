defmodule SipcpCompanionWeb.CompanionLive do
  use SipcpCompanionWeb, :live_view

  alias SipcpCompanion.AI.Agent
  alias SipcpCompanion.Conversations
  alias SipcpCompanion.TtsToken

  @approval_words ~w(sim aprovado certo isso exato perfeito pode concordo ok)
  @rejection_words ~w(não nao muda diferente outro errado discordo rejeito)

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
         input_text: "",
         pending_drafts: []
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
         input_text: "",
         pending_drafts: []
       )}
    end
  end

  @impl true
  def handle_event("send_message", %{"text" => text}, socket) when text != "" do
    handle_text_input(socket, String.trim(text))
  end

  def handle_event("send_message", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("voice_text", %{"text" => text}, socket) when text != "" do
    handle_text_input(socket, String.trim(text))
  end

  def handle_event("voice_text", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("stop_speaking", _, socket) do
    {:noreply, push_event(socket, "stop_audio", %{})}
  end

  @impl true
  def handle_event("toggle_listen", _, socket) do
    {:noreply, assign(socket, listening: !socket.assigns.listening)}
  end

  @impl true
  def handle_event("update_input", params, socket) do
    text = params["text"] || ""
    {:noreply, assign(socket, input_text: text)}
  end

  # --- AI streaming ---

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

    if response != "" do
      Conversations.add_message(socket.assigns.db_session_id, "assistant", response)
      messages = socket.assigns.messages ++ [%{role: "assistant", content: response}]

      {:noreply,
       socket
       |> assign(messages: messages, current_response: "", streaming: false)
       |> push_event("speak_url", %{url: tts_url(response)})
       |> push_event("scroll_down", %{})}
    else
      {:noreply, assign(socket, streaming: false)}
    end
  end

  @impl true
  def handle_info({:proposal_ready, edit}, socket) do
    drafts = socket.assigns.pending_drafts ++ [edit]

    tts_text =
      "Tenho uma proposta para a página #{edit.page_number}. " <>
        "#{edit.rationale} " <>
        "O texto seria: #{edit.proposed_text} " <>
        "O senhor aprova?"

    {:noreply,
     socket
     |> assign(pending_drafts: drafts)
     |> push_event("speak_url", %{url: tts_url(tts_text)})
     |> push_event("draft_ready", %{})
     |> push_event("scroll_down", %{})}
  end

  # --- Private ---

  defp handle_text_input(socket, text) do
    pending = socket.assigns.pending_drafts
    has_pending = Enum.any?(pending, &(&1.status == "pending"))

    cond do
      has_pending && approval_phrase?(text) ->
        latest = pending |> Enum.filter(&(&1.status == "pending")) |> List.last()
        resolve_draft(socket, latest.id, :approve)

      has_pending && rejection_phrase?(text) ->
        latest = pending |> Enum.filter(&(&1.status == "pending")) |> List.last()
        resolve_draft(socket, latest.id, :reject)

      true ->
        send_user_message(socket, text)
    end
  end

  defp approval_phrase?(text) do
    lower = String.downcase(text)
    Enum.any?(@approval_words, &String.contains?(lower, &1))
  end

  defp rejection_phrase?(text) do
    lower = String.downcase(text)
    Enum.any?(@rejection_words, &String.contains?(lower, &1))
  end

  defp resolve_draft(socket, edit_id, decision) do
    Agent.resolve_draft(socket.assigns.session_id, edit_id, decision)

    updated_drafts =
      Enum.map(socket.assigns.pending_drafts, fn d ->
        if d.id == edit_id, do: %{d | status: Atom.to_string(decision)}, else: d
      end)

    label = if decision == :approve, do: "Aprovei a proposta", else: "Rejeitei a proposta"
    messages = socket.assigns.messages ++ [%{role: "user", content: label}]

    {:noreply,
     socket
     |> assign(
       pending_drafts: updated_drafts,
       messages: messages,
       streaming: true,
       current_response: "",
       listening: false,
       input_text: ""
     )
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

  defp tts_url(text) do
    "/tts?token=#{URI.encode_www_form(TtsToken.sign(text))}"
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

  defp draft_status_label("pending"), do: "Aguardando"
  defp draft_status_label("approved"), do: "Aprovado"
  defp draft_status_label("rejected"), do: "Recusado"
  defp draft_status_label(_), do: ""

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="companion"
      class="h-dvh flex flex-col paper-texture"
      phx-hook="SpeechHook"
    >
      <%!-- Header --%>
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

      <%!-- Chat Area --%>
      <main
        id="chat-area"
        class="flex-1 overflow-y-auto px-3 md:px-6"
        phx-hook="ScrollHook"
      >
        <div class="max-w-2xl mx-auto py-3 space-y-3">

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

          <%!-- Draft proposal cards --%>
          <div :for={draft <- @pending_drafts} id={"draft-#{draft.id}"} class={[
            "draft-card rounded-xl px-4 py-4 msg-enter",
            if(draft.status == "pending", do: "draft-pending", else: ""),
            if(draft.status == "approved", do: "draft-approved", else: ""),
            if(draft.status == "rejected", do: "draft-rejected", else: "")
          ]}>
            <div class="flex items-center justify-between mb-2">
              <span class="font-sans text-xs font-bold uppercase tracking-widest" style="color: var(--gold);">
                Proposta — Pág. {draft.page_number}
                <span :if={draft.section}> · {draft.section}</span>
              </span>
              <span class={[
                "font-sans text-xs font-bold uppercase px-2 py-0.5 rounded-full text-white",
                if(draft.status == "pending", do: "badge-pending", else: ""),
                if(draft.status == "approved", do: "badge-approved", else: ""),
                if(draft.status == "rejected", do: "badge-rejected", else: "")
              ]}>
                {draft_status_label(draft.status)}
              </span>
            </div>

            <p class="font-serif text-base italic mb-3" style="color: var(--ink-light);">
              {draft.rationale}
            </p>

            <div :if={draft.original_text} class="draft-original rounded px-3 py-2 mb-2 font-serif text-base" style="color: var(--ink-faded);">
              <span class="font-sans text-[10px] uppercase tracking-widest block mb-1" style="color: var(--ink-faded);">Texto original</span>
              {String.slice(draft.original_text, 0, 300)}
            </div>

            <div class="draft-proposed rounded px-3 py-2 font-serif text-lg leading-relaxed" style="color: var(--ink);">
              <span class="font-sans text-[10px] uppercase tracking-widest block mb-1" style="color: var(--gold);">Texto proposto</span>
              {draft.proposed_text}
            </div>

            <p :if={draft.status == "pending"} class="font-sans text-sm mt-3 text-center" style="color: var(--ink-faded);">
              Diga "sim" para aprovar ou "não" para recusar
            </p>
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

          <%!-- Loading --%>
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

      <%!-- Stop audio floating button --%>
      <div id="stop-audio-float" class="stop-float hidden">
        <button
          type="button"
          phx-click="stop_speaking"
          class="rounded-full px-5 py-2.5 flex items-center gap-2 cursor-pointer shadow-lg"
          style="background: var(--voice-active); color: white;"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
            <rect x="6" y="6" width="12" height="12" rx="1" />
          </svg>
          <span class="font-sans text-sm font-bold">Parar</span>
        </button>
      </div>

      <%!-- Input --%>
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
