// =============================================================
// SIPCP – Figuras: Modelos Cibernéticos (Figs. 11, 18, 20, 21)
// Recreated as Typst/CeTZ diagrams from original 1982 scans
// =============================================================

#import "@preview/cetz:0.3.4"

// ─────────────────────────────────────────────────────────────────────────────
// Figura 11 — Modelo Cibernético (simplificado) de Administração Industrial
//
// Layout (cetz coords, y up):
//   Universo Exterior  (left, top)      rect centred at (1.6, 8.8)
//   Sistema Físico     (left, mid)      rect centred at (1.6, 6.0)
//   Regulação          (left, bottom)   rect centred at (1.6, 2.6)
//   O  (indicator)     (right, mid)     circle at       (6.1, 5.8)
//   Controle           (right, bottom)  rect centred at (7.1, 2.6)
//   Dashed "Informações" path: UE right → across top → down right → Controle top
//   "Sistema de Gestão" bracket under Regulação + Controle
// ─────────────────────────────────────────────────────────────────────────────
#let figura-11() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let bw = 3.0   // box half-width  (total width = 2*bw)
    let bh = 0.9   // box half-height (total height = 2*bh)

    // Block centres
    let ue  = (1.6, 8.8)
    let sf  = (1.6, 6.0)
    let rg  = (1.6, 2.6)
    let ct  = (7.1, 2.6)
    let o-c = (6.1, 5.8)
    let o-r = 0.85

    // ── Boxes ───────────────────────────────────────────────────────────────
    rect((ue.at(0) - bw, ue.at(1) - bh), (ue.at(0) + bw, ue.at(1) + bh),
         fill: white, stroke: black)
    content(ue, [Universo Exterior])

    rect((sf.at(0) - bw, sf.at(1) - bh), (sf.at(0) + bw, sf.at(1) + bh),
         fill: white, stroke: black)
    content(sf, [Sistema Físico])

    rect((rg.at(0) - bw, rg.at(1) - bh), (rg.at(0) + bw, rg.at(1) + bh),
         fill: white, stroke: black)
    content(rg, [Regulação])

    rect((ct.at(0) - bw, ct.at(1) - bh), (ct.at(0) + bw, ct.at(1) + bh),
         fill: white, stroke: black)
    content(ct, [Controle])

    // ── Circle indicator "O" ────────────────────────────────────────────────
    circle(o-c, radius: o-r, fill: white, stroke: black)
    // needle inside circle
    line((o-c.at(0) - 0.3, o-c.at(1) - 0.25),
         (o-c.at(0) + 0.35, o-c.at(1) + 0.28),
         stroke: black)
    content((o-c.at(0) + 0.12, o-c.at(1) - 0.32), text(size: 9pt)[O])

    // ── Left-column arrows ──────────────────────────────────────────────────
    // UE ↔ SF: two offset verticals
    line((ue.at(0) - 0.2, ue.at(1) - bh), (sf.at(0) - 0.2, sf.at(1) + bh),
         mark: (end: ">"), stroke: black)
    line((sf.at(0) + 0.2, sf.at(1) + bh), (ue.at(0) + 0.2, ue.at(1) - bh),
         mark: (end: ">"), stroke: black)

    // SF ↔ RG: two offset verticals
    line((sf.at(0) - 0.2, sf.at(1) - bh), (rg.at(0) - 0.2, rg.at(1) + bh),
         mark: (end: ">"), stroke: black)
    line((rg.at(0) + 0.2, rg.at(1) + bh), (sf.at(0) + 0.2, sf.at(1) - bh),
         mark: (end: ">"), stroke: black)

    // ── SF → O (horizontal right) ───────────────────────────────────────────
    line((sf.at(0) + bw, sf.at(1)), (o-c.at(0) - o-r, o-c.at(1)),
         mark: (end: ">"), stroke: black)

    // ── O → Controle (down) ─────────────────────────────────────────────────
    line((o-c.at(0) + 0.2, o-c.at(1) - o-r),
         (ct.at(0) + 0.2, ct.at(1) + bh),
         mark: (end: ">"), stroke: black)

    // ── O ← Controle (up, offset) ───────────────────────────────────────────
    line((ct.at(0) - 0.2, ct.at(1) + bh),
         (o-c.at(0) - 0.2, o-c.at(1) - o-r),
         mark: (end: ">"), stroke: black)

    // ── Controle → Regulação (horizontal left) ──────────────────────────────
    line((ct.at(0) - bw, ct.at(1)), (rg.at(0) + bw, rg.at(1)),
         mark: (end: ">"), stroke: black)

    // ── Dashed "Informações" path ────────────────────────────────────────────
    // UE right edge → horizontal to right margin → down → Controle top
    let inf-y    = ue.at(1)          // height of horizontal segment
    let inf-x-r  = ct.at(0) + bw + 0.6  // right margin x
    let ct-top-y = ct.at(1) + bh         // top of Controle box

    // horizontal
    line((ue.at(0) + bw, inf-y), (inf-x-r, inf-y),
         stroke: (dash: "dashed"))
    // vertical down
    line((inf-x-r, inf-y), (inf-x-r, ct-top-y),
         stroke: (dash: "dashed"))
    // into Controle top (arrowhead)
    line((inf-x-r, ct-top-y), (ct.at(0) + bw * 0.5, ct-top-y),
         mark: (end: ">"), stroke: (dash: "dashed"))

    // "Informações" label (above horizontal dashed segment)
    content(((ue.at(0) + bw + inf-x-r) / 2, inf-y + 0.35),
      text(size: 9pt, tracking: 2pt)[Informações])

    // ── "Sistema de Gestão" label + bracket ─────────────────────────────────
    let sg-left  = rg.at(0) - bw
    let sg-right = ct.at(0) + bw
    let sg-y     = rg.at(1) - bh - 0.55
    line((sg-left,  rg.at(1) - bh), (sg-left,  sg-y), stroke: black)
    line((sg-right, ct.at(1) - bh), (sg-right, sg-y), stroke: black)
    line((sg-left, sg-y), (sg-right, sg-y), stroke: black)
    content(((sg-left + sg-right) / 2, sg-y - 0.45),
      text(size: 9pt, tracking: 1.5pt)[Sistema de Gestão])
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 18 — O Modelo Evoluído
//
// Layout (y up, cetz coords):
//   Outer Sistema-de-Gestão box: x 1.0–9.0, y 1.0–8.5
//   Inside: Sistema Físico (left), Regulação (right), O circle (centre), Controle (right)
//   Universo exterior: overlapping left, x -1.4–2.0, y 1.5–4.0
//   OE circle: top-centre  (3.5, 10.2)
//   Evolução box: top-right (6.8–9.8, 9.2–11.2)
//   Informações: dashed path on far left
// ─────────────────────────────────────────────────────────────────────────────
#let figura-18() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // ── Outer "Sistema de Gestão" box ────────────────────────────────────────
    let ob-x1 = 1.0; let ob-y1 = 1.0
    let ob-x2 = 9.2; let ob-y2 = 8.5
    rect((ob-x1, ob-y1), (ob-x2, ob-y2), fill: white, stroke: black)

    // ── Universo exterior (overlaps left edge of outer box) ──────────────────
    let ue-x1 = -1.5; let ue-y1 = 1.5
    let ue-x2 =  2.0; let ue-y2 = 4.0
    rect((ue-x1, ue-y1), (ue-x2, ue-y2), fill: white, stroke: black)
    content(((ue-x1+ue-x2)/2, (ue-y1+ue-y2)/2), [Universo\ exterior])

    // ── Sistema Físico (inside outer box, bottom-left) ───────────────────────
    let sf-x1 = 1.2; let sf-y1 = 1.2
    let sf-x2 = 4.4; let sf-y2 = 3.8
    rect((sf-x1, sf-y1), (sf-x2, sf-y2), fill: white, stroke: black)
    content(((sf-x1+sf-x2)/2, (sf-y1+sf-y2)/2), [Sistema\ Físico])

    // ── Regulação (inside outer box, bottom-right) ───────────────────────────
    let rg-x1 = 5.5; let rg-y1 = 1.2
    let rg-x2 = 9.0; let rg-y2 = 3.8
    rect((rg-x1, rg-y1), (rg-x2, rg-y2), fill: white, stroke: black)
    content(((rg-x1+rg-x2)/2, (rg-y1+rg-y2)/2), [Regulação])

    // ── Controle (inside outer box, upper-right) ─────────────────────────────
    let ct-x1 = 5.5; let ct-y1 = 5.0
    let ct-x2 = 9.0; let ct-y2 = 7.5
    rect((ct-x1, ct-y1), (ct-x2, ct-y2), fill: white, stroke: black)
    content(((ct-x1+ct-x2)/2, (ct-y1+ct-y2)/2), [Controle])

    // ── Inner O circle (inside outer box, upper-left area) ───────────────────
    let o-cx = 3.2; let o-cy = 6.1; let o-r = 1.0
    circle((o-cx, o-cy), radius: o-r, fill: white, stroke: black)
    line((o-cx - 0.38, o-cy - 0.3), (o-cx + 0.38, o-cy + 0.28), stroke: black)
    content((o-cx + 0.12, o-cy - 0.38), text(size: 9pt)[O])
    content((o-cx, o-cy - o-r - 0.4), text(size: 8pt)[VE])

    // ── OE circle (top, above outer box) ─────────────────────────────────────
    let oe-cx = 3.5; let oe-cy = 10.2; let oe-r = 1.1
    circle((oe-cx, oe-cy), radius: oe-r, fill: white, stroke: black)
    line((oe-cx - 0.4, oe-cy - 0.3), (oe-cx + 0.4, oe-cy + 0.28), stroke: black)
    content((oe-cx + 0.1, oe-cy - 0.42), text(size: 9pt)[OE])

    // ── Evolução box (top-right) ──────────────────────────────────────────────
    let ev-x1 = 6.8; let ev-y1 = 9.2
    let ev-x2 = 9.8; let ev-y2 = 11.2
    rect((ev-x1, ev-y1), (ev-x2, ev-y2), fill: white, stroke: black)
    content(((ev-x1+ev-x2)/2, (ev-y1+ev-y2)/2), [Evolução])

    // ── Arrows ───────────────────────────────────────────────────────────────

    // Universo exterior ↔ Sistema Físico (bidirectional)
    line((ue-x2, (ue-y1+ue-y2)/2 + 0.18), (sf-x1, (sf-y1+sf-y2)/2 + 0.18),
         mark: (end: ">"), stroke: black)
    line((sf-x1, (sf-y1+sf-y2)/2 - 0.18), (ue-x2, (ue-y1+ue-y2)/2 - 0.18),
         mark: (end: ">"), stroke: black)

    // SF ↔ Regulação (bidirectional)
    line((sf-x2, (sf-y1+sf-y2)/2 + 0.15), (rg-x1, (rg-y1+rg-y2)/2 + 0.15),
         mark: (end: ">"), stroke: black)
    line((rg-x1, (rg-y1+rg-y2)/2 - 0.15), (sf-x2, (sf-y1+sf-y2)/2 - 0.15),
         mark: (end: ">"), stroke: black)

    // SF → O (up through VE)
    line(((sf-x1+sf-x2)/2, sf-y2), (o-cx, o-cy - o-r),
         mark: (end: ">"), stroke: black)

    // O ↔ Controle (bidirectional horizontal)
    line((o-cx + o-r, o-cy + 0.15), (ct-x1, (ct-y1+ct-y2)/2 + 0.15),
         mark: (end: ">"), stroke: black)
    line((ct-x1, (ct-y1+ct-y2)/2 - 0.15), (o-cx + o-r, o-cy - 0.15),
         mark: (end: ">"), stroke: black)

    // Controle → Regulação (down)
    line(((ct-x1+ct-x2)/2, ct-y1), ((rg-x1+rg-x2)/2, rg-y2),
         mark: (end: ">"), stroke: black)

    // OE ↔ Evolução (bidirectional horizontal)
    line((oe-cx + oe-r, oe-cy + 0.18), (ev-x1, (ev-y1+ev-y2)/2 + 0.18),
         mark: (end: ">"), stroke: black)
    line((ev-x1, (ev-y1+ev-y2)/2 - 0.18), (oe-cx + oe-r, oe-cy - 0.18),
         mark: (end: ">"), stroke: black)

    // Evolução → outer box (feeds into Sistema de Gestão from top)
    line(((ev-x1+ev-x2)/2, ev-y1), ((ev-x1+ev-x2)/2, ob-y2),
         mark: (end: ">"), stroke: black)

    // OE → O (vertical, down into outer box, via inner O)
    line((oe-cx, oe-cy - oe-r), (o-cx, o-cy + o-r),
         mark: (end: ">"), stroke: black)

    // ── Informações dashed path (far left, vertical) ─────────────────────────
    let inf-x = -2.1
    // vertical dashed bar from UE level up to OE level
    line((inf-x, ue-y1), (inf-x, oe-cy), stroke: (dash: "dashed"))
    // horizontal into OE
    line((inf-x, oe-cy), (oe-cx - oe-r, oe-cy),
         mark: (end: ">"), stroke: (dash: "dashed"))
    // rotated label
    content((inf-x - 0.55, (ue-y1 + oe-cy) / 2),
      angle: -90deg,
      text(size: 9pt, tracking: 2pt)[Informações])

    // ── "Sistema de Gestão" bracket (right side of outer box) ────────────────
    let sg-bx = ob-x2 + 0.45
    line((ob-x2, ob-y1), (sg-bx, ob-y1), stroke: black)
    line((ob-x2, ob-y2), (sg-bx, ob-y2), stroke: black)
    line((sg-bx, ob-y1), (sg-bx, ob-y2), stroke: black)
    content((sg-bx + 0.65, (ob-y1 + ob-y2) / 2),
      angle: -90deg,
      text(size: 9pt, tracking: 1pt)[Sistema de Gestão])
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 20 — Sensório Cibernético
//
// The original scan is a biological/cybernetic analogy:
//   - Right side: two thick dark plates (placa sensitiva, placa motora)
//     with comb-like teeth between them (retículo anastomótico)
//   - Bottom-left: transdutores de entrada (circles with ⊕ — sensors)
//   - Top-left: transdutores de saída (plain circles — efectors)
//   - SIC arrow: large arc from sensitiva → entrada transducers (afferent)
//   - MOC arrow: large arc from saída transducers → motora (efferent)
// ─────────────────────────────────────────────────────────────────────────────
#let figura-20() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // ── Placa sensitiva (thick dark parallelogram, bottom-right) ─────────────
    // Approximated as a filled quad
    line((7.2, 0.6), (10.2, 0.6), (9.8, 3.2), (6.8, 3.2),
         close: true, fill: rgb("#444"), stroke: black)

    // ── Placa motora (thick dark parallelogram, top-right) ───────────────────
    line((7.2, 5.8), (10.2, 5.8), (9.8, 8.4), (6.8, 8.4),
         close: true, fill: rgb("#444"), stroke: black)

    // ── Comb teeth (white lines on sensitiva — front face) ───────────────────
    for i in range(8) {
      let tx = 7.25 + i * 0.34
      line((tx, 0.65), (tx, 3.15),
           stroke: (paint: white, thickness: 1.2pt))
    }

    // ── Retículo anastomótico (U-shaped curved structure between the plates) ──
    // Outer U arc: from left edge of placa motora → sweeps left → left edge of sensitiva
    bezier((6.8, 6.5), (6.8, 2.5), (3.0, 9.0), (3.0, 0.0), stroke: black)
    // Inner U arc (slightly inset from outer)
    bezier((7.2, 6.5), (7.2, 2.5), (4.0, 9.0), (4.0, 0.5), stroke: black)

    // ── Retículo anastomótico label ──────────────────────────────────────────
    content((4.8, 4.5), align(center, text(size: 8pt)[retículo\ anastomótico]))

    // ── MOC path: from placa motora left edge → curves to transdutores de saída ──
    bezier((6.8, 7.2), (2.8, 7.8), (5.0, 10.5), (1.8, 10.0),
           mark: (end: ">"), stroke: black)

    // ── SIC path: from transdutores de entrada → curves to placa sensitiva ──
    bezier((2.8, 1.5), (6.8, 1.8), (1.8, -1.0), (5.0, -0.5),
           mark: (end: ">"), stroke: black)

    // ── Transdutores de saída (top-left, plain circles 2 rows × 3 cols) ──────
    let ts-x0 = 0.9; let ts-y0 = 6.4
    for row in range(2) {
      for col in range(3) {
        circle((ts-x0 + col * 0.75, ts-y0 + row * 0.75),
               radius: 0.3, fill: white, stroke: black)
      }
    }

    // ── Transdutores de entrada (bottom-left, circles with ⊕) ────────────────
    let te-x0 = 0.9; let te-y0 = 1.4
    for row in range(2) {
      for col in range(3) {
        let cx = te-x0 + col * 0.75
        let cy = te-y0 + row * 0.75
        circle((cx, cy), radius: 0.3, fill: white, stroke: black)
        line((cx - 0.21, cy), (cx + 0.21, cy), stroke: black)
        line((cx, cy - 0.21), (cx, cy + 0.21), stroke: black)
      }
    }

    // ── Labels ───────────────────────────────────────────────────────────────
    content((10.8, 1.8), align(left, text(size: 8pt)[placa\ sensitiva]))
    content((10.8, 7.0), align(left, text(size: 8pt)[placa\ motora]))
    content((5.2, 9.2),  text(size: 8pt)[MOC])
    content((5.2, 0.0),  text(size: 8pt)[SIC])

    // Correntes eferentes label (diagonal, top-left)
    content((2.0, 9.8),
      angle: -35deg,
      align(center, text(size: 7.5pt)[Correntes de im\ pulsos eferentes]))

    // Correntes aferentes label (diagonal, bottom-left)
    content((2.8, -0.5),
      angle: 25deg,
      align(center, text(size: 7.5pt)[Correntes de im\ pulsos aferentes]))

    // Legend — saída (top-left)
    content((-1.2, 7.5), align(left, text(size: 7pt)[
      Transdutores de\
      saída (efetores)\
      SIC = sensorial in-\
      put channel
    ]))

    // Legend — entrada (bottom-left)
    content((-1.2, 2.8), align(left, text(size: 7pt)[
      Transdutores de\
      entrada (sensores)\
      MOC = motor out-\
      put channel
    ]))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 21 — Esquema de ultra-estabilidade de Ashby
//
// Layout (y up):
//   Top half:
//     OE circle (3.5, 9.5) — comparator
//     4× (⊗ → ○) rows at right of OE
//     EVOLUÇÃO box (far right)
//     "Informações" dashed path from top into OE and into EVOLUÇÃO
//   Bottom half (inside "Sistema de Gestão" bracket):
//     O circle (3.5, 5.5) — comparator, label VE below
//     CT block  (right of O)
//     SF block  (bottom-left)
//     RG block  (bottom-right)
//   Left bracket: UNIVERSO EXTERIOR
//   Right bracket: Sistema de gestão (around O, CT, SF, RG)
//   OE connects down to O
//   EVOLUÇÃO feeds "OE" down to CT
// ─────────────────────────────────────────────────────────────────────────────
#let figura-21() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // ── EVOLUÇÃO block (top-right) ────────────────────────────────────────────
    let ev-x1 = 8.5; let ev-y1 = 8.2
    let ev-x2 = 11.5; let ev-y2 = 10.5
    rect((ev-x1, ev-y1), (ev-x2, ev-y2), fill: white, stroke: black)
    content(((ev-x1+ev-x2)/2, (ev-y1+ev-y2)/2),
      text(tracking: 1pt)[EVOLUÇÃO])

    // ── 4× (⊗ → ○) rows between OE and EVOLUÇÃO ─────────────────────────────
    let px-xor = 5.8    // ⊗ centre x
    let px-o   = 7.3    // ○ centre x
    let py-top = 10.0   // top row y
    let py-d   = 0.55   // row spacing
    for i in range(4) {
      let py = py-top - i * py-d
      // ⊗ — circle with ×
      circle((px-xor, py), radius: 0.22, fill: white, stroke: black)
      line((px-xor - 0.15, py - 0.15), (px-xor + 0.15, py + 0.15), stroke: black)
      line((px-xor + 0.15, py - 0.15), (px-xor - 0.15, py + 0.15), stroke: black)
      // → arrow
      line((px-xor + 0.22, py), (px-o - 0.22, py),
           mark: (end: ">"), stroke: black)
      // ○ — plain circle
      circle((px-o, py), radius: 0.22, fill: white, stroke: black)
      // → arrow into EVOLUÇÃO
      line((px-o + 0.22, py), (ev-x1, py),
           mark: (end: ">"), stroke: black)
    }

    // ── OE circle (top-centre) ────────────────────────────────────────────────
    let oe-cx = 3.5; let oe-cy = 9.3; let oe-r = 1.0
    circle((oe-cx, oe-cy), radius: oe-r, fill: white, stroke: black)
    line((oe-cx - 0.38, oe-cy - 0.28), (oe-cx + 0.38, oe-cy + 0.25), stroke: black)
    content((oe-cx + 0.1, oe-cy - 0.38), text(size: 9pt)[OE])

    // OE → ⊗ column (horizontal right)
    line((oe-cx + oe-r, oe-cy), (px-xor - 0.22, oe-cy),
         mark: (end: ">"), stroke: black)

    // ── O circle (centre) ─────────────────────────────────────────────────────
    let o-cx = 3.5; let o-cy = 5.5; let o-r = 1.0
    circle((o-cx, o-cy), radius: o-r, fill: white, stroke: black)
    line((o-cx - 0.38, o-cy - 0.28), (o-cx + 0.38, o-cy + 0.25), stroke: black)
    content((o-cx + 0.1, o-cy - 0.38), text(size: 9pt)[O])
    content((o-cx, o-cy - o-r - 0.42), text(size: 9pt)[VE])

    // ── CT block (mid-right) ──────────────────────────────────────────────────
    let ct-x1 = 5.8; let ct-y1 = 4.5
    let ct-x2 = 8.8; let ct-y2 = 6.5
    rect((ct-x1, ct-y1), (ct-x2, ct-y2), fill: white, stroke: black)
    content(((ct-x1+ct-x2)/2, (ct-y1+ct-y2)/2), text(size: 10pt)[CT.])

    // ── SF block (bottom-left) ────────────────────────────────────────────────
    let sf-x1 = 1.5; let sf-y1 = 1.8
    let sf-x2 = 4.5; let sf-y2 = 3.8
    rect((sf-x1, sf-y1), (sf-x2, sf-y2), fill: white, stroke: black)
    content(((sf-x1+sf-x2)/2, (sf-y1+sf-y2)/2), text(size: 10pt)[SF])

    // ── RG block (bottom-right) ───────────────────────────────────────────────
    let rg-x1 = 5.8; let rg-y1 = 1.8
    let rg-x2 = 8.8; let rg-y2 = 3.8
    rect((rg-x1, rg-y1), (rg-x2, rg-y2), fill: white, stroke: black)
    content(((rg-x1+rg-x2)/2, (rg-y1+rg-y2)/2), text(size: 10pt)[RG])

    // ── Arrows ────────────────────────────────────────────────────────────────

    // OE → O (vertical down)
    line((oe-cx, oe-cy - oe-r), (o-cx, o-cy + o-r),
         mark: (end: ">"), stroke: black)

    // O → CT (right)
    line((o-cx + o-r, o-cy + 0.15), (ct-x1, (ct-y1+ct-y2)/2 + 0.15),
         mark: (end: ">"), stroke: black)
    // CT → O (left, offset down)
    line((ct-x1, (ct-y1+ct-y2)/2 - 0.15), (o-cx + o-r, o-cy - 0.15),
         mark: (end: ">"), stroke: black)

    // SF → RG (right)
    line((sf-x2, (sf-y1+sf-y2)/2 + 0.15), (rg-x1, (rg-y1+rg-y2)/2 + 0.15),
         mark: (end: ">"), stroke: black)
    // RG → SF (left, offset)
    line((rg-x1, (rg-y1+rg-y2)/2 - 0.15), (sf-x2, (sf-y1+sf-y2)/2 - 0.15),
         mark: (end: ">"), stroke: black)

    // SF → O (up, via VE)
    line(((sf-x1+sf-x2)/2, sf-y2), (o-cx - 0.2, o-cy - o-r),
         mark: (end: ">"), stroke: black)

    // CT → RG (down)
    line(((ct-x1+ct-x2)/2, ct-y1), ((rg-x1+rg-x2)/2, rg-y2),
         mark: (end: ">"), stroke: black)

    // EVOLUÇÃO → CT  (down, labelled "OE")
    let ev-mid-x = (ev-x1 + ev-x2) / 2
    line((ev-mid-x, ev-y1), (ev-mid-x, ct-y2),
         mark: (end: ">"), stroke: black)
    content((ev-mid-x + 0.45, (ev-y1 + ct-y2) / 2),
      text(size: 8pt)[OE])

    // ── Informações dashed path ───────────────────────────────────────────────
    // Vertical dashed line from top, branching to OE and to EVOLUÇÃO
    let inf-y-top = 11.6
    // branch to OE
    line((oe-cx, inf-y-top), (oe-cx, oe-cy + oe-r),
         mark: (end: ">"), stroke: (dash: "dashed"))
    // horizontal to EVOLUÇÃO branch
    line((oe-cx, inf-y-top), (ev-mid-x, inf-y-top),
         stroke: (dash: "dashed"))
    line((ev-mid-x, inf-y-top), (ev-mid-x, ev-y2),
         mark: (end: ">"), stroke: (dash: "dashed"))
    // Informações label (rotated, beside vertical segment)
    content((oe-cx + 0.55, (inf-y-top + oe-cy + oe-r) / 2),
      angle: -90deg,
      text(size: 9pt, tracking: 2pt)[Informações])

    // ── UNIVERSO EXTERIOR bracket (left side) ─────────────────────────────────
    let ue-bx  = 0.3
    let ue-y1b = 1.2
    let ue-y2b = 10.8
    line((ue-bx, ue-y1b), (ue-bx, ue-y2b), stroke: black)
    line((ue-bx, ue-y1b), (sf-x1, ue-y1b), stroke: black)
    line((ue-bx, ue-y2b), (sf-x1, ue-y2b), stroke: black)
    content((ue-bx - 0.65, (ue-y1b + ue-y2b) / 2),
      angle: -90deg,
      text(size: 9pt, tracking: 1pt)[UNIVERSO EXTERIOR])

    // ── Sistema de gestão bracket (right side — around O, CT, SF, RG) ─────────
    let sg-bx  = ct-x2 + 0.45
    let sg-y1b = rg-y1 - 0.2
    let sg-y2b = ct-y2 + 0.2
    line((sg-bx, sg-y1b), (sg-bx, sg-y2b), stroke: black)
    line((sg-bx, sg-y1b), (rg-x2, sg-y1b), stroke: black)
    line((sg-bx, sg-y2b), (ct-x2, sg-y2b), stroke: black)
    content((sg-bx + 0.65, (sg-y1b + sg-y2b) / 2),
      angle: -90deg,
      text(size: 9pt)[Sistema de gestão])
  })
}
