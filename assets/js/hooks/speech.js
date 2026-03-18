/**
 * Speech hooks for SIPCP Companion.
 * STT: Browser Web Speech API (pt-BR)
 * TTS: ElevenLabs via server-side streaming endpoint
 */

export const SpeechHook = {
  mounted() {
    this.recognition = null
    this._isListening = false
    this._audioEl = null
    this._pausedForTTS = false

    this._setupRecognition()

    // LiveView events
    this.handleEvent("speak_url", ({ url }) => this.speakUrl(url))
    this.handleEvent("stop_audio", () => this.stopAudio())
    this.handleEvent("draft_ready", () => {})

    // Pre-create audio element on first gesture (iOS autoplay unlock)
    this._preloadedAudio = null
    const prime = () => {
      if (this._preloadedAudio) return
      const a = new Audio()
      a.src = "data:audio/mp3;base64,SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU4Ljc2LjEwMAAAAAAAAAAAAAAA//tQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWGluZwAAAA8AAAACAAABhgC7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7//////////////////////////////////////////////////////////////////8AAAAATGF2YzU4LjEzAAAAAAAAAAAAAAAAJAAAAAAAAAABhkVHjKgAAAAAAAAAAAAAAAAA//tQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWGluZwAAAA8AAAACAAABhgC7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7//////////////////////////////////////////////////////////////////8AAAAATGF2YzU4LjEzAAAAAAAAAAAAAAAAJAAAAAAAAAABhkVHjKgAAAAAAAAAAAAAAAAA"
      a.volume = 1.0
      a.play().then(() => {
        a.pause()
        a.currentTime = 0
        this._preloadedAudio = a
        this.debugMsg("Áudio pronto")
      }).catch(() => {})
    }
    document.addEventListener("touchstart", prime, { once: true })
    document.addEventListener("click", prime, { once: true })
  },

  _setupRecognition() {
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SR) return

    // Kill old instance
    if (this.recognition) {
      try { this.recognition.abort() } catch(e) {}
    }

    this.recognition = new SR()
    this.recognition.lang = "pt-BR"
    this.recognition.continuous = false  // Safari works better with single-shot
    this.recognition.interimResults = false

    this.recognition.onresult = (event) => {
      const result = event.results[event.results.length - 1]
      if (result.isFinal) {
        const text = result[0].transcript.trim()
        if (text) {
          this.debugMsg("Ouvido: " + text.slice(0, 40))
          this.pushEvent("voice_text", { text })
        }
      }
    }

    this.recognition.onerror = (event) => {
      this.debugMsg("Mic erro: " + event.error)
      if (event.error === "not-allowed" || event.error === "service-not-available") {
        this._isListening = false
        this.pushEvent("toggle_listen", {})
      }
    }

    this.recognition.onend = () => {
      // With continuous:false, restart after each result
      if (this._isListening && !this._pausedForTTS) {
        setTimeout(() => {
          if (this._isListening && !this._pausedForTTS) {
            try { this.recognition.start() } catch(e) {}
          }
        }, 200)
      }
    }
  },

  updated() {
    const btn = document.getElementById("voice-btn")
    if (!btn) return
    const want = btn.dataset.listening === "true"
    if (want && !this._isListening) this.startListening()
    else if (!want && this._isListening) this.stopListening()
  },

  startListening() {
    if (this._isListening) return
    if (this._audioEl) return

    // Recreate recognition each time (Safari kills it after stop)
    this._setupRecognition()
    if (!this.recognition) return

    this._isListening = true
    this._pausedForTTS = false
    try {
      this.recognition.start()
      this.debugMsg("Mic ligado")
    } catch(e) {
      this.debugMsg("Erro mic: " + e.message)
      this._isListening = false
    }
  },

  stopListening() {
    this._isListening = false
    this._pausedForTTS = false
    if (this.recognition) try { this.recognition.stop() } catch(e) {}
    this.debugMsg("")
  },

  speakUrl(url) {
    this.stopAudio()

    // Pause mic during playback (internal only — server state unchanged)
    if (this._isListening) {
      this._pausedForTTS = true
      if (this.recognition) try { this.recognition.stop() } catch(e) {}
    }

    const audio = this._preloadedAudio || new Audio()
    audio.src = url
    audio.volume = 1.0
    this._audioEl = audio
    this.showStopButton()

    audio.onended = () => {
      this._audioEl = null
      this.hideStopButton()
      this.debugMsg("Áudio terminou")
      // Resume mic after playback
      if (this._pausedForTTS && this._isListening) {
        this._pausedForTTS = false
        setTimeout(() => {
          try { this.recognition.start() } catch(e) {}
          this.debugMsg("Mic religado")
        }, 300)
      }
    }

    audio.onerror = () => {
      this._audioEl = null
      this.hideStopButton()
      this.debugMsg("Erro no áudio")
      if (this._pausedForTTS && this._isListening) {
        this._pausedForTTS = false
        try { this.recognition.start() } catch(e) {}
      }
    }

    audio.play()
      .then(() => this.debugMsg("Tocando..."))
      .catch(e => this.debugMsg("Bloqueado: " + e.message))
  },

  stopAudio() {
    if (this._audioEl) {
      this._audioEl.pause()
      this._audioEl.currentTime = 0
      this._audioEl = null
    }
    this.hideStopButton()
  },

  debugMsg(msg) {
    let el = document.getElementById("debug-audio")
    if (!el) {
      el = document.createElement("div")
      el.id = "debug-audio"
      el.style.cssText = "position:fixed;bottom:55px;left:0;right:0;text-align:center;font-size:11px;color:#888;z-index:999;padding:2px;"
      document.body.appendChild(el)
    }
    el.textContent = msg
  },

  showStopButton() {
    const el = document.getElementById("stop-audio-float")
    if (el) { el.classList.remove("hidden"); el.classList.add("visible") }
  },

  hideStopButton() {
    const el = document.getElementById("stop-audio-float")
    if (el) { el.classList.remove("visible"); el.classList.add("hidden") }
  },

  destroyed() {
    this.stopListening()
    this.stopAudio()
  }
}

export const ScrollHook = {
  mounted() {
    this.handleEvent("scroll_down", () => {
      requestAnimationFrame(() => {
        this.el.scrollTo({ top: this.el.scrollHeight, behavior: "smooth" })
      })
    })
  }
}
