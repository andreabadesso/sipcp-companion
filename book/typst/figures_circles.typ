// =============================================================
// Figuras de Círculos Concêntricos — Níveis de Pilotagem
// SIPCP — Fernando Batalha Monteiro (1982)
//
// Requires: #import "@preview/cetz:0.3.4"
// =============================================================

#import "@preview/cetz:0.3.4"

// -------------------------------------------------------------
// Figura 12 — 1º Nível de Pilotagem: OPERAÇÃO
// Two concentric circles.
//   Inner circle (r=1.2): "SISTEMA FÍSICO"
//   Outer circle (r=2.8): ring labeled "OPERAÇÃO"
//   Caption below: "1º NÍVEL"
// -------------------------------------------------------------
#let figura-12() = {
  align(center)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let r-sf  = 1.2  // Sistema Físico
      let r-op  = 2.8  // Operação

      // Outer circle
      circle((0, 0), radius: r-op, stroke: 0.6pt + black, fill: none)
      // Inner circle
      circle((0, 0), radius: r-sf, stroke: 0.6pt + black, fill: none)

      // Label in inner circle
      content((0, 0), [
        #set text(size: 9pt)
        SISTEMA \ FÍSICO
      ])

      // Label in outer ring (top area)
      content((0, r-sf + (r-op - r-sf) * 0.65), [
        #set text(size: 9pt)
        OPERAÇÃO
      ])

      // Caption below entire diagram
      content((0, -(r-op + 0.55)), [
        #set text(size: 9pt)
        1º NÍVEL
      ])
    })
  ]
}

// -------------------------------------------------------------
// Figura 13 — 2º Nível de Pilotagem: GESTÃO envolve OPERAÇÃO
// Three concentric circles.
//   Inner (r=1.0): "S  F"
//   Middle (r=2.2): ring = OPERAÇÃO / 1º NÍVEL
//   Outer  (r=3.6): ring = GESTÃO   / 2º NÍVEL
// -------------------------------------------------------------
#let figura-13() = {
  align(center)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let r-sf  = 1.0
      let r-op  = 2.2
      let r-ge  = 3.6

      circle((0, 0), radius: r-ge, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-op, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-sf, stroke: 0.6pt + black, fill: none)

      // Inner label
      content((0, 0), [
        #set text(size: 9pt)
        S #h(0.4em) F
      ])

      // OPERAÇÃO ring — label at top of ring
      let mid-op = r-sf + (r-op - r-sf) * 0.6
      content((0, mid-op), [
        #set text(size: 9pt)
        OPERAÇÃO
      ])
      // 1º NÍVEL — label at bottom of OPERAÇÃO ring
      content((0, -(r-sf + (r-op - r-sf) * 0.55)), [
        #set text(size: 8pt)
        1º NÍVEL
      ])

      // GESTÃO ring — label at top of ring
      let mid-ge = r-op + (r-ge - r-op) * 0.6
      content((0, mid-ge), [
        #set text(size: 9pt)
        GESTÃO
      ])
      // 2º NÍVEL — label at bottom of GESTÃO ring
      content((0, -(r-op + (r-ge - r-op) * 0.55)), [
        #set text(size: 8pt)
        2º NÍVEL
      ])
    })
  ]
}

// -------------------------------------------------------------
// Figura 19 — 3º Nível de Pilotagem: EVOLUÇÃO
// Four concentric circles.
//   Inner (r=0.9): "S F"
//   Ring I  (r=1.9): OPERAÇÃO / Op / I
//   Ring II (r=3.0): GESTÃO   / Ge / II
//   Ring III(r=4.2): EVOLUÇÃO / Ev / III
// Labels follow the original layout:
//   name at top of ring, abbreviation just below the inner edge,
//   roman numeral at bottom of ring.
// -------------------------------------------------------------
#let figura-19() = {
  align(center)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let r-sf  = 0.9
      let r-op  = 1.9
      let r-ge  = 3.0
      let r-ev  = 4.2

      circle((0, 0), radius: r-ev, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-ge, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-op, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-sf, stroke: 0.6pt + black, fill: none)

      // Inner label
      content((0, 0), [
        #set text(size: 9pt)
        S #h(0.3em) F
      ])

      // Ring I: OPERAÇÃO
      content((0,  r-sf + (r-op - r-sf) * 0.75), [#set text(size: 8.5pt); OPERAÇÃO])
      content((0,  r-sf + (r-op - r-sf) * 0.25), [#set text(size: 8pt);   Op])
      content((0, -(r-sf + (r-op - r-sf) * 0.6)), [#set text(size: 8pt);  I])

      // Ring II: GESTÃO
      content((0,  r-op + (r-ge - r-op) * 0.75), [#set text(size: 8.5pt); GESTÃO])
      content((0,  r-op + (r-ge - r-op) * 0.25), [#set text(size: 8pt);   Ge])
      content((0, -(r-op + (r-ge - r-op) * 0.6)), [#set text(size: 8pt);  II])

      // Ring III: EVOLUÇÃO
      content((0,  r-ge + (r-ev - r-ge) * 0.75), [#set text(size: 8.5pt); EVOLUÇÃO])
      content((0,  r-ge + (r-ev - r-ge) * 0.25), [#set text(size: 8pt);   Ev])
      content((0, -(r-ge + (r-ev - r-ge) * 0.6)), [#set text(size: 8pt);  III])
    })
  ]
}

// -------------------------------------------------------------
// Figura 22 — 4º Nível de Pilotagem: MUTAÇÃO
// Five concentric circles.
//   Inner (r=1.0): "Sistema Físico"
//   Ring I  (r=2.0): OPERAÇÃO  / I
//   Ring II (r=3.0): GESTÃO    / II
//   Ring III(r=4.0): EVOLUÇÃO  / III
//   Ring IV (r=5.2): MUTAÇÃO   / IV
// Original shows labels stacked on the vertical axis below center.
// -------------------------------------------------------------
#let figura-22() = {
  align(center)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let r-sf  = 1.0
      let r-op  = 2.0
      let r-ge  = 3.0
      let r-ev  = 4.1
      let r-mu  = 5.3

      circle((0, 0), radius: r-mu, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-ev, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-ge, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-op, stroke: 0.6pt + black, fill: none)
      circle((0, 0), radius: r-sf, stroke: 0.6pt + black, fill: none)

      // Inner label
      content((0, 0), [
        #set text(size: 9pt)
        Sistema \ Físico
      ])

      // Labels stacked on vertical axis (below centre), matching the original scan
      // Each ring: roman numeral at top of lower half, name just below it
      let gap = 0.38

      // Ring I — OPERAÇÃO
      let y-op = -(r-sf + (r-op - r-sf) * 0.35)
      content((0, y-op),          [#set text(size: 8pt); I])
      content((0, y-op - gap),    [#set text(size: 8.5pt); OPERAÇÃO])

      // Ring II — GESTÃO
      let y-ge = -(r-op + (r-ge - r-op) * 0.35)
      content((0, y-ge),          [#set text(size: 8pt); II])
      content((0, y-ge - gap),    [#set text(size: 8.5pt); GESTÃO])

      // Ring III — EVOLUÇÃO
      let y-ev = -(r-ge + (r-ev - r-ge) * 0.35)
      content((0, y-ev),          [#set text(size: 8pt); III])
      content((0, y-ev - gap),    [#set text(size: 8.5pt); EVOLUÇÃO])

      // Ring IV — MUTAÇÃO
      let y-mu = -(r-ev + (r-mu - r-ev) * 0.35)
      content((0, y-mu),          [#set text(size: 8pt); IV])
      content((0, y-mu - gap),    [#set text(size: 8.5pt); MUTAÇÃO])
    })
  ]
}
