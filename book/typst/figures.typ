// figures.typ — Reusable diagram functions for SIPCP book figures
//
// All six organograms/flow diagrams from the original 1982 scan.
// Pure org-charts use place() + line(). Flow diagrams use cetz for arrows.

#import "@preview/cetz:0.3.4": canvas, draw

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper — labelled rectangle (org-chart node)
// ─────────────────────────────────────────────────────────────────────────────

#let org-box(label, width: 28mm, height: 14mm) = rect(
  width: width,
  height: height,
  stroke: 0.7pt + black,
  fill: white,
  align(center + horizon, text(size: 8pt, label)),
)

// ─────────────────────────────────────────────────────────────────────────────
// Figura 2 — Organograma da pequena empresa
// GERÊNCIA-GERAL on top; PRODUÇÃO and VENDAS below
// ─────────────────────────────────────────────────────────────────────────────

#let figura-2() = {
  let bw = 28mm
  let bh = 12mm
  let W  = 82mm
  let H  = 50mm

  // Box positions (top-left corners)
  let gg-x = 27mm;  let gg-y = 2mm
  let pr-x = 4mm;   let pr-y = 34mm
  let ve-x = 50mm;  let ve-y = 34mm

  // Junction rail y (between GG bottom and child tops)
  let rail-y   = 24mm
  let gg-cx    = gg-x + bw / 2   // 41mm
  let pr-cx    = pr-x + bw / 2   // 18mm
  let ve-cx    = ve-x + bw / 2   // 64mm

  box(width: W, height: H, {
    place(top + left, dx: gg-x, dy: gg-y, org-box("GERÊNCIA-GERAL", width: bw, height: bh))
    place(top + left, dx: pr-x, dy: pr-y, org-box("PRODUÇÃO",       width: bw, height: bh))
    place(top + left, dx: ve-x, dy: ve-y, org-box("VENDAS",         width: bw, height: bh))

    // Vertical from GG bottom to rail
    place(top + left, dx: gg-cx, dy: gg-y + bh,
      line(start: (0pt, 0pt), end: (0pt, rail-y - (gg-y + bh)), stroke: 0.7pt))

    // Horizontal rail
    place(top + left, dx: pr-cx, dy: rail-y,
      line(start: (0pt, 0pt), end: (ve-cx - pr-cx, 0pt), stroke: 0.7pt))

    // Vertical down to PRODUÇÃO
    place(top + left, dx: pr-cx, dy: rail-y,
      line(start: (0pt, 0pt), end: (0pt, pr-y - rail-y), stroke: 0.7pt))

    // Vertical down to VENDAS
    place(top + left, dx: ve-cx, dy: rail-y,
      line(start: (0pt, 0pt), end: (0pt, ve-y - rail-y), stroke: 0.7pt))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 3 — Organograma da Empresa com órgão de Pesquisa
// GESTÃO (right) connected left to PRODUÇÃO / ESTOQUE / VENDAS
// and below-right to PESQUISA
// ─────────────────────────────────────────────────────────────────────────────

#let figura-3() = {
  let bw  = 26mm
  let bh  = 18mm
  let W   = 90mm
  let H   = 92mm

  // GESTÃO — right column, vertically centred on the left column
  let g-x  = 58mm;  let g-y  = 22mm
  // Left column
  let l-x  = 4mm
  let p-y  = 4mm     // PRODUÇÃO
  let e-y  = 34mm    // ESTOQUE
  let v-y  = 62mm    // VENDAS
  // PESQUISA — bottom-centre
  let pe-x = 36mm;  let pe-y = 64mm

  // Spine x (vertical bus connecting left column to GESTÃO)
  let spine-x = l-x + bw + 6mm   // 36mm
  let g-mid-y = g-y + bh / 2     // mid of GESTÃO

  box(width: W, height: H, {
    place(top + left, dx: g-x,  dy: g-y,  org-box("GESTÃO",   width: bw, height: bh))
    place(top + left, dx: l-x,  dy: p-y,  org-box("PRODUÇÃO", width: bw, height: bh))
    place(top + left, dx: l-x,  dy: e-y,  org-box("ESTOQUE",  width: bw, height: bh))
    place(top + left, dx: l-x,  dy: v-y,  org-box("VENDAS",   width: bw, height: bh))
    place(top + left, dx: pe-x, dy: pe-y, org-box("PESQUISA", width: bw, height: bh))

    // Horizontal connector: each left-box right edge → spine
    for row-y in (p-y, e-y, v-y) {
      let my = row-y + bh / 2
      place(top + left, dx: l-x + bw, dy: my,
        line(start: (0pt, 0pt), end: (spine-x - (l-x + bw), 0pt), stroke: 0.7pt))
    }

    // Vertical spine from PRODUÇÃO mid to VENDAS mid
    place(top + left, dx: spine-x, dy: p-y + bh / 2,
      line(start: (0pt, 0pt), end: (0pt, (v-y + bh / 2) - (p-y + bh / 2)), stroke: 0.7pt))

    // Horizontal from spine to GESTÃO left edge
    place(top + left, dx: spine-x, dy: g-mid-y,
      line(start: (0pt, 0pt), end: (g-x - spine-x, 0pt), stroke: 0.7pt))

    // PESQUISA: down from GESTÃO bottom-centre then across to PESQUISA top-centre
    let g-bcx = g-x + bw / 2       // GESTÃO bottom-centre x
    let g-bot = g-y + bh
    let pe-tcx = pe-x + bw / 2
    // Vertical drop to PESQUISA top
    place(top + left, dx: g-bcx, dy: g-bot,
      line(start: (0pt, 0pt), end: (0pt, pe-y - g-bot), stroke: 0.7pt))
    // Horizontal jog to PESQUISA
    place(top + left, dx: pe-tcx, dy: pe-y,
      line(start: (0pt, 0pt), end: (g-bcx - pe-tcx, 0pt), stroke: 0.7pt))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 5 — Praxeograma Operatório do Novo Sistema
// 2×2 grid: PRODUÇÃO (top-left), GESTÃO (top-right),
//           ESTOQUE  (bot-left), VENDAS  (bot-right)
// Paired arrows (solid + dashed) on all four sides of the square flow
// ─────────────────────────────────────────────────────────────────────────────

#let figura-5() = {
  // Use cetz for proper arrowheads
  // Grid in cetz units (1 unit ≈ 1cm for readability)
  canvas(length: 1cm, {
    import draw: *

    let bw  = 3.4   // box width  (cm)
    let bh  = 3.2   // box height (cm)
    let gap = 1.6   // gap between columns / rows

    // Box top-left corners (cetz y increases upward, so we flip)
    // Use screen coords: top = 0, bottom grows down — cetz is Cartesian
    // Let's place boxes with their CENTRES:
    let cx-l = bw / 2                  // left col centre-x
    let cx-r = bw + gap + bw / 2       // right col centre-x
    let cy-t = -(bh / 2)               // top row centre-y  (negative = down)
    let cy-b = -(bh + gap + bh / 2)    // bot row centre-y

    // Box corners (top-left for rect)
    let tl-prod  = (0,           0)
    let tl-gest  = (bw + gap,    0)
    let tl-esto  = (0,           -(bh + gap))
    let tl-vend  = (bw + gap,    -(bh + gap))

    // Draw boxes
    for (tl, lbl) in (
      (tl-prod, "PRODUÇÃO"),
      (tl-gest, "GESTÃO"),
      (tl-esto, "ESTOQUE"),
      (tl-vend, "VENDAS"),
    ) {
      rect(tl, (tl.at(0) + bw, tl.at(1) - bh),
           stroke: 0.7pt + black, fill: white)
      content((tl.at(0) + bw/2, tl.at(1) - bh/2),
              text(size: 8pt, lbl))
    }

    let off = 0.18  // offset between paired arrows (cm)

    // GESTÃO → PRODUÇÃO (rightward box to leftward box: arrows go left)
    // top edge mid y of each box: cy-t = -(bh/2)
    // GESTÃO left-edge x = bw + gap;  PRODUÇÃO right-edge x = bw
    let ay = cy-t   // centre y of top row
    // Upper arrow (solid): GESTÃO left → PRODUÇÃO right
    line((bw + gap, ay + off), (bw, ay + off), mark: (end: ">"), stroke: 0.7pt)
    // Lower arrow (dashed): same direction
    line((bw + gap, ay - off), (bw, ay - off),
         mark: (end: ">"),
         stroke: (paint: black, thickness: 0.7pt, dash: "dashed"))

    // PRODUÇÃO → ESTOQUE (top-left → bot-left: arrows go down)
    let ax = cx-l
    let top-bot-y = -(bh)
    let bot-top-y = -(bh + gap)
    line((ax - off, top-bot-y), (ax - off, bot-top-y), mark: (end: ">"), stroke: 0.7pt)
    line((ax + off, top-bot-y), (ax + off, bot-top-y),
         mark: (end: ">"),
         stroke: (paint: black, thickness: 0.7pt, dash: "dashed"))

    // ESTOQUE → VENDAS (bot-left right-edge → bot-right left-edge: arrows go right)
    let by = cy-b
    line((bw, by + off), (bw + gap, by + off),
         mark: (end: ">"),
         stroke: (paint: black, thickness: 0.7pt, dash: "dashed"))
    line((bw, by - off), (bw + gap, by - off), mark: (end: ">"), stroke: 0.7pt)

    // VENDAS → GESTÃO (bot-right top-edge → top-right bot-edge: arrows go up)
    let bx = cx-r
    line((bx - off, -(bh + gap)), (bx - off, -bh), mark: (end: ">"), stroke: 0.7pt)
    line((bx + off, -(bh + gap)), (bx + off, -bh),
         mark: (end: ">"),
         stroke: (paint: black, thickness: 0.7pt, dash: "dashed"))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 14 — Organograma da Empresa com órgão de assessoria (CONTROLLER)
// PRESIDENTE (centre-right); PRODUÇÃO/VENDAS/FINANÇAS/PESSOAL on left spine;
// CONTROLLER as staff node dangling below PRESIDENTE
// ─────────────────────────────────────────────────────────────────────────────

#let figura-14() = {
  let bw  = 26mm
  let bh  = 14mm
  let W   = 82mm
  let H   = 96mm

  // PRESIDENTE
  let pr-x = 50mm;  let pr-y = 14mm

  // Four line departments (left column)
  let l-x = 4mm
  let dep-ys = (2mm, 20mm, 38mm, 56mm)
  let dep-labels = ("PRODUÇÃO", "VENDAS", "FINANÇAS", "PESSOAL")

  // CONTROLLER (staff node below PRESIDENTE)
  let ct-x = 50mm;  let ct-y = 66mm

  // Spine x (vertical bus on right of left boxes)
  let spine-x = l-x + bw + 6mm   // 36mm
  let pr-mid-y = pr-y + bh / 2

  box(width: W, height: H, {
    place(top + left, dx: pr-x, dy: pr-y, org-box("PRESIDENTE", width: bw, height: bh))
    place(top + left, dx: ct-x, dy: ct-y, org-box("CONTROLLER", width: bw, height: bh))

    for (i, dy) in dep-ys.enumerate() {
      place(top + left, dx: l-x, dy: dy, org-box(dep-labels.at(i), width: bw, height: bh))
      let my = dy + bh / 2
      // Right edge of dept → spine
      place(top + left, dx: l-x + bw, dy: my,
        line(start: (0pt, 0pt), end: (spine-x - (l-x + bw), 0pt), stroke: 0.7pt))
    }

    // Vertical spine from top dept to bottom dept
    let top-y = dep-ys.at(0) + bh / 2
    let bot-y = dep-ys.at(3) + bh / 2
    place(top + left, dx: spine-x, dy: top-y,
      line(start: (0pt, 0pt), end: (0pt, bot-y - top-y), stroke: 0.7pt))

    // Horizontal: spine → PRESIDENTE left edge
    place(top + left, dx: spine-x, dy: pr-mid-y,
      line(start: (0pt, 0pt), end: (pr-x - spine-x, 0pt), stroke: 0.7pt))

    // CONTROLLER: down from PRESIDENTE bottom-centre
    let pr-bcx = pr-x + bw / 2
    let pr-bot = pr-y + bh
    let ct-tcx = ct-x + bw / 2
    place(top + left, dx: pr-bcx, dy: pr-bot,
      line(start: (0pt, 0pt), end: (ct-tcx - pr-bcx, 0pt), stroke: 0.7pt))
    place(top + left, dx: ct-tcx, dy: pr-bot,
      line(start: (0pt, 0pt), end: (0pt, ct-y - pr-bot), stroke: 0.7pt))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 15 — Modelo Departamental de Gestão
// Flow diagram with boxes and circles, solid + dashed arrows
// ─────────────────────────────────────────────────────────────────────────────

#let figura-15() = {
  // cetz canvas — all coords in cm
  canvas(length: 1cm, {
    import draw: *

    // Helper to draw a labelled box (centre coords)
    let fbox(cx, cy, w, h, lbl) = {
      rect((cx - w/2, cy - h/2), (cx + w/2, cy + h/2),
           stroke: 0.7pt + black, fill: white)
      content((cx, cy), text(size: 7pt, align(center, lbl)))
    }

    // Helper to draw a labelled circle (centre coords)
    let fcircle(cx, cy, r, lbl: "") = {
      circle((cx, cy), radius: r, stroke: 0.7pt + black, fill: white)
      if lbl != "" {
        content((cx, cy), text(size: 6pt, align(center, lbl)))
      }
    }

    // Arrow helpers
    let arr(a, b) = line(a, b, mark: (end: ">"), stroke: 0.7pt)
    let darr(a, b) = line(a, b, mark: (end: ">"),
                          stroke: (paint: black, thickness: 0.7pt, dash: "dashed"))

    // Layout (y increases upward in cetz)
    // Sistema Físico: top centre
    let sf = (4.5, 6.5)
    // Regulador: top left
    let reg = (1.2, 6.5)
    // Departamento X: middle right
    let dep = (7.5, 4.5)
    // Controle: bottom left
    let ctrl = (1.2, 1.8)
    // Circles
    let c1 = (4.2, 1.8)   // VE departamentais (left circle)
    let c2 = (7.5, 1.8)   // VES (right circle)

    let bw = 2.4; let bh = 1.4
    let dw = 2.6; let dh = 1.4

    // Draw boxes
    fbox(sf.at(0),   sf.at(1),   bw, bh, "Sistema\nFísico")
    fbox(reg.at(0),  reg.at(1),  bw, bh, "Regulador\n(operação)")
    fbox(dep.at(0),  dep.at(1),  dw, dh, "Departamento X")
    fbox(ctrl.at(0), ctrl.at(1), bw, bh, "Controle\n(gestão)")

    // Draw circles
    fcircle(c1.at(0), c1.at(1), 0.55)
    fcircle(c2.at(0), c2.at(1), 0.55)

    // ── Arrows ──
    // Sistema Físico → Regulador (horizontal left)
    arr((sf.at(0) - bw/2,  sf.at(1)),
        (reg.at(0) + bw/2, reg.at(1)))

    // Regulador → circle c1 (downward, dashed — Variáveis de Ação)
    darr((reg.at(0), reg.at(1) - bh/2),
         (c1.at(0),  c1.at(1) + 0.55))

    // c1 → Controle (leftward)
    arr((c1.at(0) - 0.55,  c1.at(1)),
        (ctrl.at(0) + bw/2, ctrl.at(1)))

    // Controle → Regulador (upward)
    arr((ctrl.at(0), ctrl.at(1) + bh/2),
        (reg.at(0),  reg.at(1) - bh/2))

    // Sistema Físico → Departamento X (diagonal down-right)
    arr((sf.at(0) + bw/2,    sf.at(1)),
        (dep.at(0) - dw/2,   dep.at(1) + dh/2))

    // Departamento X → c1 (diagonal down-left, Variáveis Essenciais)
    arr((dep.at(0) - dw/2, dep.at(1)),
        (c1.at(0) + 0.55,  c1.at(1)))

    // Departamento X ← HS entries (from right — dashed)
    darr((dep.at(0) + dw/2 + 1.5, dep.at(1) + 0.3),
         (dep.at(0) + dw/2,       dep.at(1) + 0.3))

    // Departamento X → c2 (downward)
    arr((dep.at(0), dep.at(1) - dh/2),
        (c2.at(0),  c2.at(1) + 0.55))

    // c2 → GESTÃO feedback (upward, dashed)
    darr((dep.at(0) + 0.3, c2.at(1) + 0.55),
         (dep.at(0) + 0.3, dep.at(1) - dh/2))

    // Dashed vertical separator
    line((6.1, 0.4), (6.1, 7.8),
         stroke: (paint: black, thickness: 0.5pt, dash: "dashed"))

    // ── Labels ──
    content((2.7,  5.4), text(size: 6pt, "Variáveis de Ação"))
    content((5.4,  4.9), text(size: 6pt, "Variáveis Essenciais"))
    content((9.4,  5.4), text(size: 6pt, align(left, "Entradas\nvindas de HS")))
    content((7.5,  3.6), text(size: 6pt, "V E S"))
    content((0.5,  4.2), text(size: 6pt, align(left, "Sistema de\nGestão Depart.")))
    content((4.2,  0.9), text(size: 6pt, align(center, "VE departa-\nmentais")))
    content((7.5,  0.9), text(size: 6pt, align(center, "Controller\nVES")))

    // Legend: HS = hierarquia superior
    content((8.0, 7.5), text(size: 6pt, align(left, "HS = hierarquia\nsuperior")))
  })
}

// ─────────────────────────────────────────────────────────────────────────────
// Figura 25 — Organograma (simplificado) da ALPHA
// PRESIDENTE → Infor + Vice-Pres + Control
// Vice-Pres → Prod + Finan + Pes + Com + Adm
// Each L2 node has two D Sv/CCAO sub-boxes (or CCP/CCAI for Prod)
// ─────────────────────────────────────────────────────────────────────────────

#let figura-25() = {
  let W = 170mm
  let H = 110mm

  // Box widths / heights per level
  let bw0 = 26mm; let bh0 = 16mm   // PRESIDENTE
  let bw1 = 20mm; let bh1 = 11mm   // L1: Infor, Vice-Pres, Control
  let bw2 = 16mm; let bh2 = 9mm    // L2: Prod, Finan, Pes, Com, Adm
  let bw3 = 14mm; let bh3 = 8mm    // L3: small sub-boxes (two per L2 node)

  // x positions
  let x0 = 2mm
  let x1 = x0 + bw0 + 6mm         // 34mm
  let x2 = x1 + bw1 + 6mm         // 60mm
  let x3 = x2 + bw2 + 4mm         // 80mm

  // L1 y positions
  let l1-ys = (6mm, 44mm, 80mm)
  let l1-labels = ("Infor", "Vice-Pres", "Control")

  // PRESIDENTE y: centred between top and bottom L1
  let pres-y = l1-ys.at(0) + (l1-ys.at(2) + bh1 - l1-ys.at(0)) / 2 - bh0 / 2

  // L2 y positions (centred under Vice-Pres = l1-ys.at(1))
  // 5 children, uniform spacing
  let l2-count = 5
  let l2-spacing = 18mm
  let l2-total-h = (l2-count - 1) * l2-spacing + bh2
  let l2-start-y = l1-ys.at(1) + bh1 / 2 - l2-total-h / 2
  let l2-ys = range(l2-count).map(i => l2-start-y + i * l2-spacing)
  let l2-labels = ("Prod", "Finan", "Pes", "Com", "Adm")

  // L3 sub-box definitions (two per L2: [top-label, bottom-label])
  // Prod gets CCP/CCAI; others get CCAO/CCAO
  let l3-labels = (
    ("D Sv\nCCP", "CCAI"),
    ("D Sv\nCCAO", "CCAO"),
    ("D Sv\nCCAO", "CCAO"),
    ("CCAO", "CCAO"),
    ("CCAO", "CCAO"),
  )

  // Spines
  let spine1-x = x1 - 3mm    // vertical spine for L0→L1
  let spine2-x = x2 - 3mm    // vertical spine for L1→L2

  box(width: W, height: H, {
    // ── PRESIDENTE ──
    place(top + left, dx: x0, dy: pres-y, org-box("PRESIDENTE", width: bw0, height: bh0))

    // Horizontal from PRESIDENTE right → spine1
    let pres-mid-y = pres-y + bh0 / 2
    place(top + left, dx: x0 + bw0, dy: pres-mid-y,
      line(start: (0pt, 0pt), end: (spine1-x - (x0 + bw0), 0pt), stroke: 0.6pt))

    // Vertical spine1 from first L1 to last L1 midpoints
    let s1-top = l1-ys.at(0) + bh1 / 2
    let s1-bot = l1-ys.at(2) + bh1 / 2
    place(top + left, dx: spine1-x, dy: s1-top,
      line(start: (0pt, 0pt), end: (0pt, s1-bot - s1-top), stroke: 0.6pt))

    // ── L1 nodes ──
    for (i, dy) in l1-ys.enumerate() {
      place(top + left, dx: x1, dy: dy,
        rect(width: bw1, height: bh1, stroke: 0.6pt + black, fill: white,
          align(center + horizon, text(size: 7.5pt, l1-labels.at(i)))))
      let my = dy + bh1 / 2
      place(top + left, dx: spine1-x, dy: my,
        line(start: (0pt, 0pt), end: (x1 - spine1-x, 0pt), stroke: 0.6pt))
    }

    // ── L2 spine (from Vice-Pres = l1-ys.at(1)) ──
    let vp-right = x1 + bw1
    let vp-mid-y = l1-ys.at(1) + bh1 / 2
    place(top + left, dx: vp-right, dy: vp-mid-y,
      line(start: (0pt, 0pt), end: (spine2-x - vp-right, 0pt), stroke: 0.6pt))

    // Vertical spine2 from first L2 to last L2 midpoints
    let s2-top = l2-ys.at(0) + bh2 / 2
    let s2-bot = l2-ys.at(4) + bh2 / 2
    place(top + left, dx: spine2-x, dy: s2-top,
      line(start: (0pt, 0pt), end: (0pt, s2-bot - s2-top), stroke: 0.6pt))

    // ── L2 nodes + L3 sub-boxes ──
    for (i, dy) in l2-ys.enumerate() {
      // L2 box
      place(top + left, dx: x2, dy: dy,
        rect(width: bw2, height: bh2, stroke: 0.6pt + black, fill: white,
          align(center + horizon, text(size: 7pt, l2-labels.at(i)))))

      // Horizontal: spine2 → L2 left edge
      let my = dy + bh2 / 2
      place(top + left, dx: spine2-x, dy: my,
        line(start: (0pt, 0pt), end: (x2 - spine2-x, 0pt), stroke: 0.6pt))

      // Horizontal: L2 right edge → L3 area
      place(top + left, dx: x2 + bw2, dy: my,
        line(start: (0pt, 0pt), end: (x3 - (x2 + bw2), 0pt), stroke: 0.6pt))

      // L3: two sub-boxes stacked vertically, side by side
      // Row 1 (top sub-box pair) and Row 2 (bottom sub-box pair)
      // Each L2 gets one column of 2 stacked boxes at x3
      let (lbl-a, lbl-b) = l3-labels.at(i)
      let row1-y = dy
      let row2-y = dy + bh3 + 1mm
      place(top + left, dx: x3, dy: row1-y,
        rect(width: bw3, height: bh3, stroke: 0.5pt + black, fill: white,
          align(center + horizon, text(size: 5.5pt, lbl-a))))
      place(top + left, dx: x3, dy: row2-y,
        rect(width: bw3, height: bh3, stroke: 0.5pt + black, fill: white,
          align(center + horizon, text(size: 5.5pt, lbl-b))))
    }

    // ── Legend ──
    place(bottom + left, dx: 0mm, dy: -2mm,
      text(size: 5.5pt,
        "CCP = Centro de custo de produção" +
        "    CCAI = centro de custos auxiliares indiretos" +
        "    CCAO = centro de custos auxiliares operacionais"))
  })
}
