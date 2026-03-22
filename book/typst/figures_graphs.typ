// =============================================================
// SIPCP – Figuras: Gráficos, Diagramas de Transição e Árvores
// Recreated as Typst/CeTZ diagrams
// =============================================================

#import "@preview/cetz:0.3.4"

// ---------------------------------------------------------------
// Figura 6 — Dois gráficos hiperbólicos lado a lado
//   Esquerdo: ENTROPIA (Y) × ENERGIA (X) — curva decrescente
//   Direito:  ORDEM (Y) × DESORDEM (X)   — curva decrescente
// ---------------------------------------------------------------
#let figura-6() = {
  set text(size: 9pt)
  grid(
    columns: (1fr, 1fr),
    gutter: 2em,

    // --- Gráfico esquerdo: Entropia × Energia ---
    align(center, cetz.canvas({
      import cetz.draw: *

      let w = 5.5
      let h = 4.5
      let pad-l = 0.6
      let pad-b = 0.5

      // Eixos
      line((pad-l, pad-b), (pad-l, h), mark: (end: "stealth", fill: black), stroke: 0.8pt)
      line((pad-l, pad-b), (w, pad-b), mark: (end: "stealth", fill: black), stroke: 0.8pt)

      // Rótulo eixo Y — vertical rotacionado
      content(
        (pad-l - 0.5, h / 2 + pad-b / 2),
        angle: 90deg,
        anchor: "center",
        text(size: 8pt)[ENTROPIA],
      )

      // Rótulo eixo X
      content(
        (w / 2 + pad-l / 2, pad-b - 0.35),
        anchor: "center",
        text(size: 8pt)[ENERGIA],
      )

      // Curva hiperbólica: y = k/x, mapeada para o espaço do canvas
      // Domínio x: 0.15..1 → canvas x: pad-l + 0.2 .. w - 0.3
      // Range  y: 0.1..1   → canvas y: pad-b + 0.1 .. h - 0.4
      let x-min = 0.18
      let x-max = 1.0
      let x-start = pad-l + 0.25
      let x-end   = w - 0.35
      let y-start = pad-b + 0.15
      let y-end   = h - 0.45

      let pts = range(0, 30).map(i => {
        let t = i / 29.0
        let x-norm = x-min + t * (x-max - x-min)
        let y-norm = x-min / x-norm   // hyperbola: y = x-min/x
        let cx = x-start + t * (x-end - x-start)
        let cy = y-start + (1 - t) * (y-end - y-start) * (x-min / x-norm - x-min / x-max) / (1 - x-min / x-max)
        (cx, cy)
      })

      // Recalculate properly: map hyperbola y=1/x onto canvas range
      let pts2 = range(0, 40).map(i => {
        let t = i / 39.0
        // x goes from near-0 to 1 in normalized coords
        let xn = 0.12 + t * (1.0 - 0.12)
        let yn = 0.12 / xn  // y = 0.12/x  (so at xn=0.12, yn=1; at xn=1, yn=0.12)
        // map xn [0.12,1] → cx [x-start, x-end]
        let cx = x-start + (xn - 0.12) / (1.0 - 0.12) * (x-end - x-start)
        // map yn [0.12,1] → cy [y-start, y-end]
        let cy = y-start + (yn - 0.12) / (1.0 - 0.12) * (y-end - y-start)
        (cx, cy)
      })

      hobby(..pts2, stroke: 1.2pt + black)
    })),

    // --- Gráfico direito: Ordem × Desordem ---
    align(center, cetz.canvas({
      import cetz.draw: *

      let w = 5.5
      let h = 4.5
      let pad-l = 0.6
      let pad-b = 0.5

      // Eixos
      line((pad-l, pad-b), (pad-l, h), mark: (end: "stealth", fill: black), stroke: 0.8pt)
      line((pad-l, pad-b), (w, pad-b), mark: (end: "stealth", fill: black), stroke: 0.8pt)

      // Rótulo eixo Y
      content(
        (pad-l - 0.5, h / 2 + pad-b / 2),
        angle: 90deg,
        anchor: "center",
        text(size: 8pt)[ORDEM],
      )

      // Rótulo eixo X
      content(
        (w / 2 + pad-l / 2, pad-b - 0.35),
        anchor: "center",
        text(size: 8pt)[DESORDEM],
      )

      // Mesma curva hiperbólica
      let x-start = pad-l + 0.25
      let x-end   = w - 0.35
      let y-start = pad-b + 0.15
      let y-end   = h - 0.45

      let pts2 = range(0, 40).map(i => {
        let t = i / 39.0
        let xn = 0.12 + t * (1.0 - 0.12)
        let yn = 0.12 / xn
        let cx = x-start + (xn - 0.12) / (1.0 - 0.12) * (x-end - x-start)
        let cy = y-start + (yn - 0.12) / (1.0 - 0.12) * (y-end - y-start)
        (cx, cy)
      })

      hobby(..pts2, stroke: 1.2pt + black)
    })),
  )
}


// ---------------------------------------------------------------
// Figura 7 — Caixa com condição inicial C₁
//   Eₙ = 8, Eₚ = 2
// ---------------------------------------------------------------
#let figura-7() = {
  align(center, box(
    stroke: 0.8pt + black,
    inset: (x: 1.2em, y: 0.8em),
    [
      $E_n = 8 quad C_1$ \
      $E_p = 2$
    ],
  ))
}


// ---------------------------------------------------------------
// Figura 8 — Quatro caixas com setas de transição
//   C₂ → C₃ → C₄ → C₅
// ---------------------------------------------------------------
#let figura-8() = {
  set text(size: 9.5pt)
  let caixa(conteudo) = box(
    stroke: 0.8pt + black,
    inset: (x: 0.9em, y: 0.7em),
    conteudo,
  )
  let seta = h(0.5em) + $arrow.r$ + h(0.5em)

  align(center, {
    caixa[$E_n = 6 quad C_2$ \ $E_p = 4$]
    seta
    caixa[$E_n = 4 quad C_3$ \ $E_p = 6$]
    seta
    caixa[$E_n = 2 quad C_4$ \ $E_p = 8$]
    seta
    caixa[$E_n = 0 quad C_5$ \ $E_p = 10$]
  })
}


// ---------------------------------------------------------------
// Figura 10 — Praxeograma operatório (árvore de decisão)
//   PRAXEOGRAMA OPERATÓRIO DO SISTEMA
// ---------------------------------------------------------------
#let figura-10() = {
  set text(size: 8.5pt)
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Helper: draw a labeled box centered at (cx, cy)
    let box-w = 2.2
    let box-h = 0.75

    let draw-box(cx, cy, label) = {
      rect(
        (cx - box-w / 2, cy - box-h / 2),
        (cx + box-w / 2, cy + box-h / 2),
        stroke: 0.7pt + black,
        fill: white,
      )
      content((cx, cy), anchor: "center", label)
    }

    // Helper: arrow from bottom of box at (x1,y1) to top of box at (x2,y2)
    let arrow-down(x1, y1, x2, y2) = {
      line(
        (x1, y1 - box-h / 2),
        (x2, y2 + box-h / 2),
        mark: (end: "stealth", fill: black, size: 0.18),
        stroke: 0.7pt,
      )
    }

    // Helper: edge label placed along a line
    let edge-label(lx, ly, label) = {
      content((lx, ly), anchor: "center", text(size: 7.5pt, label))
    }

    // Layout (top = high y)
    // Row 0 (top): Pré-operação   cx=5.5, cy=11
    // Row 1: vermelha (cx=2), preta (cx=8)   cy=9
    // Row 2: paus (cx=6.5), espada (cx=10)   cy=7
    // Row 3: <7 (cx=5), >7 (cx=8.5)          cy=5
    // Row 4: <3 (cx=3.5), >3 (cx=6.5)        cy=3
    // Row 5: <5 (cx=5), >5 (cx=8)            cy=1
    // Row 6: =4                               cy=-1

    let r0x = 5.5;  let r0y = 11.0
    let r1lx = 2.0; let r1rx = 8.5; let r1y = 9.0
    let r2lx = 6.5; let r2rx = 10.0; let r2y = 7.0
    let r3lx = 5.0; let r3rx = 8.5; let r3y = 5.0
    let r4lx = 3.5; let r4rx = 6.5; let r4y = 3.0
    let r5lx = 5.0; let r5rx = 8.0; let r5y = 1.0
    let r6x = 5.0;  let r6y = -1.0

    // Nodes
    draw-box(r0x, r0y, [Pré\ operação])
    draw-box(r1lx, r1y, [vermelha])
    draw-box(r1rx, r1y, [preta])
    draw-box(r2lx, r2y, [paus])
    draw-box(r2rx, r2y, [espada])
    draw-box(r3lx, r3y, [$< 7$])
    draw-box(r3rx, r3y, [$> 7$])
    draw-box(r4lx, r4y, [$< 3$])
    draw-box(r4rx, r4y, [$> 3$])
    draw-box(r5lx, r5y, [$< 5$])
    draw-box(r5rx, r5y, [$> 5$])
    draw-box(r6x, r6y, [$= 4$])

    // "DECISÃO NA CERTEZA" label next to =4 box
    content((r6x + box-w / 2 + 0.3, r6y), anchor: "west", text(size: 8pt)[DECISÃO NA CERTEZA])

    // Edges: Pré-operação → vermelha (não) / preta (sim)
    // Line from bottom of root, then branch left/right
    let root-bot = (r0x, r0y - box-h / 2)
    let root-mid-y = (r0y - box-h / 2 + r1y + box-h / 2) / 2

    // Horizontal bar from left-branch top to right-branch top
    line(root-bot, (r0x, root-mid-y), stroke: 0.7pt)
    line((r0x, root-mid-y), (r1lx, root-mid-y), stroke: 0.7pt)
    line((r0x, root-mid-y), (r1rx, root-mid-y), stroke: 0.7pt)
    line((r1lx, root-mid-y), (r1lx, r1y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    line((r1rx, root-mid-y), (r1rx, r1y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    edge-label(r1lx - 0.5, root-mid-y + 0.15, [não])
    edge-label(r1rx + 0.45, root-mid-y + 0.15, [sim])

    // preta → paus (sim) / espada (não)
    let preta-bot = (r1rx, r1y - box-h / 2)
    let preta-mid-y = (r1y - box-h / 2 + r2y + box-h / 2) / 2
    line(preta-bot, (r1rx, preta-mid-y), stroke: 0.7pt)
    line((r1rx, preta-mid-y), (r2lx, preta-mid-y), stroke: 0.7pt)
    line((r1rx, preta-mid-y), (r2rx, preta-mid-y), stroke: 0.7pt)
    line((r2lx, preta-mid-y), (r2lx, r2y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    line((r2rx, preta-mid-y), (r2rx, r2y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    edge-label(r2lx - 0.5, preta-mid-y + 0.15, [sim])
    edge-label(r2rx + 0.45, preta-mid-y + 0.15, [não])

    // paus → <7 (sim) / >7 (não)
    let paus-bot = (r2lx, r2y - box-h / 2)
    let paus-mid-y = (r2y - box-h / 2 + r3y + box-h / 2) / 2
    line(paus-bot, (r2lx, paus-mid-y), stroke: 0.7pt)
    line((r2lx, paus-mid-y), (r3lx, paus-mid-y), stroke: 0.7pt)
    line((r2lx, paus-mid-y), (r3rx, paus-mid-y), stroke: 0.7pt)
    line((r3lx, paus-mid-y), (r3lx, r3y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    line((r3rx, paus-mid-y), (r3rx, r3y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    edge-label(r3lx - 0.5, paus-mid-y + 0.15, [sim])
    edge-label(r3rx + 0.45, paus-mid-y + 0.15, [não])

    // <7 → <3 (não) / >3 (sim)
    let l7-bot = (r3lx, r3y - box-h / 2)
    let l7-mid-y = (r3y - box-h / 2 + r4y + box-h / 2) / 2
    line(l7-bot, (r3lx, l7-mid-y), stroke: 0.7pt)
    line((r3lx, l7-mid-y), (r4lx, l7-mid-y), stroke: 0.7pt)
    line((r3lx, l7-mid-y), (r4rx, l7-mid-y), stroke: 0.7pt)
    line((r4lx, l7-mid-y), (r4lx, r4y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    line((r4rx, l7-mid-y), (r4rx, r4y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    edge-label(r4lx - 0.5, l7-mid-y + 0.15, [não])
    edge-label(r4rx + 0.45, l7-mid-y + 0.15, [sim])

    // >3 → <5 (sim) / >5 (não)
    let g3-bot = (r4rx, r4y - box-h / 2)
    let g3-mid-y = (r4y - box-h / 2 + r5y + box-h / 2) / 2
    line(g3-bot, (r4rx, g3-mid-y), stroke: 0.7pt)
    line((r4rx, g3-mid-y), (r5lx, g3-mid-y), stroke: 0.7pt)
    line((r4rx, g3-mid-y), (r5rx, g3-mid-y), stroke: 0.7pt)
    line((r5lx, g3-mid-y), (r5lx, r5y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    line((r5rx, g3-mid-y), (r5rx, r5y + box-h / 2), mark: (end: "stealth", fill: black, size: 0.18), stroke: 0.7pt)
    edge-label(r5lx - 0.5, g3-mid-y + 0.15, [sim])
    edge-label(r5rx + 0.45, g3-mid-y + 0.15, [não])

    // <5 → =4
    arrow-down(r5lx, r5y, r6x, r6y)
  })
}


// ---------------------------------------------------------------
// Figura 16 — Curva do Conhecimento Humano
//   Y: GENERALIZAÇÃO, X: ESPECIALIZAÇÃO — hipérbole decrescente
// ---------------------------------------------------------------
#let figura-16() = {
  set text(size: 9pt)
  align(center, cetz.canvas({
    import cetz.draw: *

    let w = 7.0
    let h = 6.0
    let pad-l = 0.8
    let pad-b = 0.6

    // Eixos
    line((pad-l, pad-b), (pad-l, h), mark: (end: "stealth", fill: black), stroke: 0.8pt)
    line((pad-l, pad-b), (w, pad-b), mark: (end: "stealth", fill: black), stroke: 0.8pt)

    // Rótulo eixo Y
    content(
      (pad-l - 0.55, h / 2 + pad-b / 2),
      angle: 90deg,
      anchor: "center",
      text(size: 8.5pt)[GENERALIZAÇÃO],
    )

    // Rótulo eixo X
    content(
      (w / 2 + pad-l / 2, pad-b - 0.4),
      anchor: "center",
      text(size: 8.5pt)[ESPECIALIZAÇÃO],
    )

    // Asymptotes (dashed)
    line((pad-l, pad-b + 0.55), (w - 0.1, pad-b + 0.55), stroke: (paint: luma(160), dash: "dashed", thickness: 0.5pt))
    line((pad-l + 0.7, pad-b), (pad-l + 0.7, h - 0.1), stroke: (paint: luma(160), dash: "dashed", thickness: 0.5pt))

    // Hipérbole com assíntotas: curva y = k/(x - x0) + y0
    // Asymptote x at: pad-l + 0.7, asymptote y at: pad-b + 0.55
    let ax = pad-l + 0.7   // vertical asymptote (canvas x)
    let ay = pad-b + 0.55  // horizontal asymptote (canvas y)
    let k = 2.2            // scale factor

    // Start curve far enough from the vertical asymptote to stay within canvas
    // At cx = ax + d, cy = ay + k/d. We want cy <= h - 0.3, so d >= k/(h - 0.3 - ay)
    let d-start = k / (h - 0.3 - ay) + 0.01
    let x-curve-start = ax + d-start
    let x-curve-end   = w - 0.25

    let pts = range(0, 50).map(i => {
      let t = i / 49.0
      let cx = x-curve-start + t * (x-curve-end - x-curve-start)
      let cy = ay + k / (cx - ax)
      (cx, cy)
    })

    hobby(..pts, stroke: 1.3pt + black)

    // Label "CURVA DO CONHECIMENTO HUMANO" inside the graph
    content(
      (ax + 2.2, ay + 2.2),
      anchor: "west",
      align(left, text(size: 8pt)[CURVA DO CONHE-\ CIMENTO HUMANO]),
    )
  }))
}


// ---------------------------------------------------------------
// Figura 29 — Gráfico de sinergia e oscilação do sistema
//   Linha de sinergia (sólida, diagonal ascendente)
//   Linha de oscilação (tracejada, zigzague ao redor da sinergia)
//   X-axis labels: CCP, CCAI, CCAO₁…CCAO₈
// ---------------------------------------------------------------
#let figura-29() = {
  set text(size: 8pt)
  align(center, cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // The graph is oriented diagonally — the "synergy line" goes
    // from bottom-left to top-right. Points along the synergy line:
    // x-labels at equal spacing, y increases linearly.
    // Oscillation line zigzags ± around the synergy line.

    // Stage positions along the synergy line (linear, going up-right)
    // We'll use a rotated canvas approach: draw horizontal baseline,
    // put labels below, draw synergy as straight line with slope,
    // and oscillation as dashed zigzag.

    let stages = ("CCP", "CCAI", $"CCAO"_1$, $"CCAO"_2$, $"CCAO"_3$, $"CCAO"_4$, $"CCAO"_5$, $"CCAO"_6$, $"CCAO"_7$, $"CCAO"_8$)
    let n = stages.len()  // 10 stages

    // Canvas layout: x from 0.5 to 10.5 (step ~1.1), y from 0 to 6
    let x-start = 0.8
    let x-step  = 1.1
    let y-start = 0.5
    let y-end   = 5.5
    let y-step  = (y-end - y-start) / float(n - 1)

    // Synergy line points (straight diagonal)
    let syn-pts = range(0, n).map(i => {
      let cx = x-start + float(i) * x-step
      let cy = y-start + float(i) * y-step
      (cx, cy)
    })

    // Draw synergy line (solid, thick)
    for i in range(0, n - 1) {
      line(syn-pts.at(i), syn-pts.at(i + 1), stroke: 1.5pt + black)
    }

    // Circles at each synergy point
    for i in range(0, n) {
      circle(syn-pts.at(i), radius: 0.1, fill: white, stroke: 0.8pt + black)
    }

    // Oscillation line: dashed, zigzags ±0.5 around synergy line
    // Pattern: CCP below, CCAI on line, CCAO1 above, CCAO2 on, CCAO3 below, etc.
    // From image: oscillation starts below synergy at CCP, crosses at CCAI,
    // goes above at CCAO1, crosses at CCAO2, below at CCAO3, crosses CCAO4(above),
    // crosses CCAO5, above at CCAO6, at CCAO7(on line), above at CCAO8
    let offsets = (-0.55, 0.0, 0.55, 0.0, -0.45, 0.35, 0.0, 0.5, 0.0, 0.65)
    let perp-dx = -y-step / calc.sqrt(x-step * x-step + y-step * y-step)
    let perp-dy =  x-step / calc.sqrt(x-step * x-step + y-step * y-step)

    let osc-pts = range(0, n).map(i => {
      let (sx, sy) = syn-pts.at(i)
      let off = offsets.at(i)
      (sx + off * perp-dx, sy + off * perp-dy)
    })

    // Draw oscillation as dashed line
    for i in range(0, n - 1) {
      line(
        osc-pts.at(i),
        osc-pts.at(i + 1),
        stroke: (paint: black, dash: "dashed", thickness: 0.8pt),
      )
    }

    // Circles on oscillation points
    for i in range(0, n) {
      circle(osc-pts.at(i), radius: 0.09, fill: white, stroke: 0.7pt + black)
    }

    // Stage labels — placed perpendicular-below the synergy line
    // Perpendicular direction pointing "right-down" (below the line going up-right)
    // perp unit vector pointing below-right: (y-step, -x-step) / |...| normalized
    let mag = calc.sqrt(x-step * x-step + y-step * y-step)
    let plx =  y-step / mag   // perpendicular x component (points below-right)
    let ply = -x-step / mag   // perpendicular y component

    let loff = 0.42   // label offset distance from synergy line

    for i in range(0, n) {
      let (sx, sy) = syn-pts.at(i)
      // Alternate labels slightly to avoid overlap on crowded middle section
      let extra = if i == 4 or i == 6 { 0.15 } else { 0.0 }
      content(
        (sx + (loff + extra) * plx, sy + (loff + extra) * ply),
        anchor: "center",
        text(size: 7pt, stages.at(i)),
      )
    }

    // Percentage labels: 100% above CCAO7 synergy pt, 160% above CCAO8 osc pt
    // "above" = perpendicular direction opposite to below
    let (s7x, s7y) = syn-pts.at(8)   // CCAO7 on synergy
    let (o8x, o8y) = osc-pts.at(9)   // CCAO8 on oscillation (above synergy)
    content((s7x - loff * plx + 0.0, s7y - loff * ply + 0.0), anchor: "center", text(size: 7.5pt)[100%])
    content((o8x - loff * plx * 0.5, o8y - loff * ply * 0.5 + 0.25), anchor: "center", text(size: 7.5pt)[160%])

    // Legend (below the figure)
    let leg-y = y-start - 0.85
    let leg-x = x-start + 0.5
    // Solid line legend
    line((leg-x, leg-y), (leg-x + 1.2, leg-y), stroke: 1.5pt + black)
    content((leg-x + 1.4, leg-y), anchor: "west", text(size: 7.5pt)[Linha de sinergia real (performance real)])
    // Dashed line legend
    let leg-y2 = leg-y - 0.45
    line((leg-x, leg-y2), (leg-x + 1.2, leg-y2), stroke: (paint: black, dash: "dashed", thickness: 0.8pt))
    content((leg-x + 1.4, leg-y2), anchor: "west", text(size: 7.5pt)[Linha de sinergia virtual (performance estimada)])
  }))
}
