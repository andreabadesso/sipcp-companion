/**
 * Web Speech API hooks for SIPCP Companion.
 * Uses browser-native STT/TTS — zero server-side audio processing.
 * Optimized for elderly users: slow speech rate, clear voice, pt-BR.
 */

export const SpeechHook = {
  mounted() {
    this.recognition = null
    this.synthesis = window.speechSynthesis
    this._isListening = false

    // Pre-load voices (Chrome loads them async)
    if (this.synthesis) {
      this.synthesis.getVoices()
      window.speechSynthesis.onvoiceschanged = () => this.synthesis.getVoices()
    }

    // Setup Speech Recognition (STT)
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (SpeechRecognition) {
      this.recognition = new SpeechRecognition()
      this.recognition.lang = "pt-BR"
      this.recognition.continuous = true
      this.recognition.interimResults = true

      this.recognition.onresult = (event) => {
        const last = event.results[event.results.length - 1]
        if (last.isFinal) {
          const text = last[0].transcript.trim()
          if (text) {
            console.log("[SIPCP] Voice captured:", text)
            this.pushEvent("voice_text", { text })
          }
        }
      }

      this.recognition.onerror = (event) => {
        console.log("[SIPCP] Speech error:", event.error)
        // Only stop listening on real errors, not transient ones
        if (event.error === "not-allowed" || event.error === "service-not-available") {
          this._isListening = false
          this.pushEvent("toggle_listen", {})
          alert("Permissão do microfone negada. Por favor permita o acesso ao microfone nas configurações do navegador.")
        }
      }

      this.recognition.onend = () => {
        console.log("[SIPCP] Recognition ended, listening:", this._isListening)
        // Auto-restart if we should still be listening
        if (this._isListening) {
          setTimeout(() => {
            if (this._isListening && this.recognition) {
              try {
                this.recognition.start()
                console.log("[SIPCP] Recognition restarted")
              } catch(e) {
                console.log("[SIPCP] Restart failed:", e.message)
              }
            }
          }, 100)
        }
      }
    } else {
      console.warn("[SIPCP] Speech Recognition not supported in this browser")
    }

    // Listen for LiveView events to control voice
    this.handleEvent("start_listening", () => this.startListening())
    this.handleEvent("stop_listening", () => this.stopListening())

    // TTS: speak assistant responses
    this.handleEvent("speak", ({ text }) => this.speak(text))
  },

  // Called after LiveView DOM patches — re-check state
  updated() {
    const btn = document.getElementById("voice-btn")
    if (btn) {
      const shouldListen = btn.dataset.listening === "true"
      if (shouldListen && !this._isListening) {
        this.startListening()
      } else if (!shouldListen && this._isListening) {
        this.stopListening()
      }
    }
  },

  startListening() {
    if (!this.recognition) {
      alert("Seu navegador não suporta reconhecimento de voz. Use o Google Chrome.")
      return
    }
    if (this._isListening) return

    console.log("[SIPCP] Starting to listen...")
    this._isListening = true
    try {
      this.recognition.start()
    } catch(e) {
      // Already started, that's fine
      console.log("[SIPCP] Start error (probably already running):", e.message)
    }
  },

  stopListening() {
    console.log("[SIPCP] Stopping listening...")
    this._isListening = false
    if (this.recognition) {
      try { this.recognition.stop() } catch(e) {}
    }
  },

  speak(text) {
    if (!this.synthesis) return

    this.synthesis.cancel()

    const cleanText = text
      .replace(/[#*_`~\[\]()]/g, "")
      .replace(/\n+/g, ". ")
      .slice(0, 2000)

    const utterance = new SpeechSynthesisUtterance(cleanText)
    utterance.lang = "pt-BR"
    utterance.rate = 0.85
    utterance.pitch = 1.0
    utterance.volume = 1.0

    const voices = this.synthesis.getVoices()
    const ptVoice = voices.find(v => v.lang === "pt-BR") ||
                    voices.find(v => v.lang.startsWith("pt-BR")) ||
                    voices.find(v => v.lang.startsWith("pt"))
    if (ptVoice) utterance.voice = ptVoice

    this.synthesis.speak(utterance)
  },

  destroyed() {
    this._isListening = false
    if (this.recognition) {
      try { this.recognition.stop() } catch(e) {}
    }
    if (this.synthesis) {
      this.synthesis.cancel()
    }
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
