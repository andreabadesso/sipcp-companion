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

    // Log available audio devices
    if (navigator.mediaDevices) {
      navigator.mediaDevices.enumerateDevices().then(devices => {
        const mics = devices.filter(d => d.kind === "audioinput")
        console.log("[SIPCP] Available microphones:", mics.length)
        mics.forEach((m, i) => console.log(`[SIPCP]   ${i}: ${m.label || "unnamed"} (${m.deviceId.slice(0,8)}...)`))
      })

      // Request mic access using the Chrome-selected default device
      navigator.mediaDevices.enumerateDevices().then(devices => {
        // Find the device Chrome settings selected (AirPods or whatever is default)
        const airpods = devices.find(d => d.kind === "audioinput" && d.label.includes("AirPods"))
        const defaultMic = devices.find(d => d.kind === "audioinput" && d.deviceId === "default")
        const preferred = airpods || defaultMic

        const constraints = preferred
          ? { audio: { deviceId: { exact: preferred.deviceId } } }
          : { audio: true }

        console.log("[SIPCP] Requesting mic:", preferred?.label || "system default")

        return navigator.mediaDevices.getUserMedia(constraints)
      })
        .then(stream => {
          const track = stream.getAudioTracks()[0]
          console.log("[SIPCP] Active mic:", track.label, "| settings:", JSON.stringify(track.getSettings()))
          // Keep stream open so Chrome doesn't switch back
          this._micStream = stream
        })
        .catch(err => console.error("[SIPCP] Mic access error:", err.message))
    }

    // Setup Speech Recognition (STT)
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (SpeechRecognition) {
      this.recognition = new SpeechRecognition()
      this.recognition.lang = "pt-BR"
      this.recognition.continuous = true
      this.recognition.interimResults = true

      this.recognition.onresult = (event) => {
        for (let i = event.resultIndex; i < event.results.length; i++) {
          const result = event.results[i]
          const text = result[0].transcript.trim()
          const confidence = result[0].confidence
          console.log(`[SIPCP] Result: "${text}" (final: ${result.isFinal}, confidence: ${confidence})`)
          if (result.isFinal && text) {
            console.log("[SIPCP] Voice captured (final):", text)
            this.pushEvent("voice_text", { text })
          }
        }
      }

      this.recognition.onaudiostart = () => console.log("[SIPCP] Audio capture started — mic is active")
      this.recognition.onaudioend = () => console.log("[SIPCP] Audio capture ended")
      this.recognition.onspeechstart = () => console.log("[SIPCP] Speech detected!")
      this.recognition.onspeechend = () => console.log("[SIPCP] Speech ended")
      this.recognition.onnomatch = () => console.log("[SIPCP] No match found")

      this.recognition.onerror = (event) => {
        console.log("[SIPCP] Speech error:", event.error)
        if (event.error === "not-allowed" || event.error === "service-not-available") {
          this._isListening = false
          this.pushEvent("toggle_listen", {})
          alert("Permissão do microfone negada. Por favor permita o acesso ao microfone nas configurações do navegador.")
        }
      }

      this.recognition.onend = () => {
        console.log("[SIPCP] Recognition ended, listening:", this._isListening)
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

    // Listen for LiveView events
    this.handleEvent("start_listening", () => this.startListening())
    this.handleEvent("stop_listening", () => this.stopListening())

    // TTS via ElevenLabs streaming endpoint
    this.handleEvent("speak_url", ({ url }) => this.speakUrl(url))
  },

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

    // Stop any playing audio so mic doesn't pick it up
    this.stopAudio()

    console.log("[SIPCP] Starting to listen...")
    this._isListening = true
    try {
      this.recognition.start()
    } catch(e) {
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

  speakUrl(url) {
    // Stop any in-progress audio
    this.stopAudio()

    // Stop listening while TTS plays (avoid mic picking up speaker)
    const wasListening = this._isListening
    if (wasListening) this.stopListening()

    const audio = new Audio(url)
    audio.preload = "auto"
    this._audioEl = audio

    audio.onended = () => {
      console.log("[SIPCP] TTS playback finished")
      this._audioEl = null
    }

    audio.onerror = (e) => {
      console.error("[SIPCP] TTS audio error:", e)
      this._audioEl = null
    }

    audio.play().catch(e => {
      console.warn("[SIPCP] Autoplay blocked:", e.message)
    })
  },

  stopAudio() {
    if (this._audioEl) {
      this._audioEl.pause()
      this._audioEl.src = ""
      this._audioEl = null
    }
  },

  destroyed() {
    this._isListening = false
    if (this.recognition) {
      try { this.recognition.stop() } catch(e) {}
    }
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
