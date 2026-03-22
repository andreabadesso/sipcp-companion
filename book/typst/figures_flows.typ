// =============================================================
// Flow Diagrams and Complex Models
// SIPCP – Fernando Batalha Monteiro (1982)
// =============================================================

#import "@preview/cetz:0.3.4"

// ─────────────────────────────────────────────────────────────
// Figura 4 — Praxeograma Operatório
// Five boxes connected by numbered solid and dashed arrows
// ─────────────────────────────────────────────────────────────
#let figura-4() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let bw = 3.0  // box width
    let bh = 2.2  // box height

    // Layout:
    //   PRODUCAO (0, 4)   PESQUISA (4.5, 4)   MERCADO (8.5, 1)
    //   ESTOQUE  (0, 0)   VENDAS   (4.5, 0)

    let boxes = (
      ("PRODUÇÃO",  0.0, 4.0),
      ("PESQUISA",  4.5, 4.0),
      ("MERCADO",   8.5, 1.0),
      ("ESTOQUE",   0.0, 0.0),
      ("VENDAS",    4.5, 0.0),
    )

    for (lbl, cx, cy) in boxes {
      rect(
        (cx - bw/2, cy - bh/2),
        (cx + bw/2, cy + bh/2),
        fill: white,
        stroke: 0.8pt + black,
      )
      content((cx, cy), text(size: 9pt, weight: "bold")[#lbl])
    }

    let tip  = (mark: (end: "straight", fill: black, scale: 0.6))
    let dtip = (mark: (start: "straight", end: "straight", fill: black, scale: 0.6))

    // Arrow 1 — PESQUISA → PRODUÇÃO (two parallel solid arrows)
    line((4.5 - bw/2, 4.35), (0.0 + bw/2, 4.35), ..tip, stroke: 0.8pt + black)
    line((4.5 - bw/2, 3.90), (0.0 + bw/2, 3.90), ..tip, stroke: 0.8pt + black)
    content((2.25, 4.65), text(size: 8pt)[1])

    // Arrow 2 — MERCADO → PESQUISA (solid diagonal)
    line((8.5 - bw/2, 1.5), (4.5 + bw/2, 4.2), ..tip, stroke: 0.8pt + black)
    content((7.0, 3.2), text(size: 8pt)[2])

    // Arrow 3 top — dashed loop PESQUISA top → PRODUÇÃO top (over the boxes)
    line((4.5, 4.0 + bh/2), (4.5, 5.5),
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    line((4.5, 5.5), (0.0, 5.5),
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((2.25, 5.75), text(size: 8pt)[3])
    line((0.0, 5.5), (0.0, 4.0 + bh/2), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

    // Arrow 3 diagonal — MERCADO → PESQUISA dashed (second diagonal parallel to arrow 2)
    line((8.5 - bw/2 - 0.3, 1.8), (4.5 + bw/2 + 0.1, 4.45), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((7.5, 3.6), text(size: 8pt)[3])

    // Arrow 3 — PESQUISA → VENDAS dashed (vertical, two arrows)
    line((4.35, 4.0 - bh/2), (4.35, 0.0 + bh/2), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((4.05, 2.0), text(size: 8pt)[3])

    // Arrow 4 — PRODUÇÃO → ESTOQUE dashed
    line((0.0, 4.0 - bh/2), (0.0, 0.0 + bh/2), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((-0.4, 2.0), text(size: 8pt)[4])

    // Arrow 5 — ESTOQUE → VENDAS solid + dashed
    line((0.0 + bw/2, 0.2), (4.5 - bw/2, 0.2), ..tip, stroke: 0.8pt + black)
    line((0.0 + bw/2, -0.2), (4.5 - bw/2, -0.2), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((2.25, 0.5), text(size: 8pt)[5])

    // Arrow 6 — VENDAS → MERCADO solid diagonal
    line((4.5 + bw/2, -0.2), (8.5 - bw/2, 0.8), ..tip, stroke: 0.8pt + black)
    line((4.5 + bw/2,  0.2), (8.5 - bw/2, 1.2), ..tip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    content((6.8, 0.1), text(size: 8pt)[6])

    // Arrow 7 — VENDAS → PESQUISA solid (vertical upward)
    line((4.65, 0.0 + bh/2), (4.65, 4.0 - bh/2), ..tip, stroke: 0.8pt + black)
    content((4.95, 2.0), text(size: 8pt)[7])
  })
}

// ─────────────────────────────────────────────────────────────
// Figura 23 — Modelo Neurofisiológico Cibernético
// Layered neurological analogy with cybernetic piloting levels
// ─────────────────────────────────────────────────────────────
#let figura-23() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Central column bounds
    let lx = 1.5
    let rx = 7.5
    let cx = (lx + rx) / 2.0   // = 4.5

    // Zone y-boundaries (bottom, top):
    //   MEDULA       : 0.2 → 3.2
    //   PONTE/BULBO  : 3.2 → 4.4
    //   DIENCÉFALOS  : 4.4 → 5.6
    //   CÓRTEX       : 5.6 → 6.8
    //   INTUIÇÃO     : 6.8 → 8.5 (open top)

    // ── Rectangles ──
    rect((lx, 0.2), (rx, 3.2), fill: white, stroke: 0.8pt + black)
    rect((lx, 3.2), (rx, 4.4), fill: white, stroke: 0.8pt + black)
    rect((lx, 4.4), (rx, 5.6), fill: white, stroke: 0.8pt + black)
    rect((lx, 5.6), (rx, 6.8), fill: white, stroke: 0.8pt + black)

    // Intuição zone — open top (just side lines + bottom border)
    line((lx, 6.8), (lx, 8.5), stroke: 0.8pt + black)
    line((rx, 6.8), (rx, 8.5), stroke: 0.8pt + black)
    // Curved top bracket (approximate with bezier)
    bezier(
      (lx, 8.5), (rx, 8.5),
      (cx - 1.5, 9.5), (cx + 1.5, 9.5),
      stroke: 0.8pt + black,
    )

    // ── Zone labels ──
    content((cx, 7.6), align(center, text(size: 8.5pt)[
      Espaço Extra-Cortical\
      #text(weight: "bold")[INTUIÇÃO]
    ]))
    content((cx, 6.2), text(size: 10pt, weight: "bold")[CÓRTEX])
    content((cx, 5.1), align(center, text(size: 8.5pt, weight: "bold")[
      DIENCÉFALOS\
      GÂNGLIOS BASAIS
    ]))
    content((cx, 3.8), text(size: 9pt, weight: "bold")[PONTE/BULBO])
    content((cx, 2.6), text(size: 10pt, weight: "bold")[M E D U L A])

    // Circle inside MEDULA
    circle((cx, 1.3), radius: 0.9, fill: white, stroke: 0.8pt + black)

    // ── Internal arrows ──
    let tip  = (mark: (end: "straight", fill: black, scale: 0.5))
    let dtip = (mark: (start: "straight", end: "straight", fill: black, scale: 0.5))

    // Intuição → CÓRTEX (downward single arrow through border)
    line((cx, 7.5), (cx, 6.8), ..tip, stroke: 0.8pt + black)

    // CÓRTEX ↔ DIENCÉFALOS (3 bidirectional vertical arrows)
    for dx in (-0.7, 0.0, 0.7) {
      line((cx + dx, 6.5), (cx + dx, 5.7), ..dtip, stroke: 0.8pt + black)
    }

    // DIENCÉFALOS ↔ PONTE/BULBO (3 bidirectional vertical arrows)
    for dx in (-0.7, 0.0, 0.7) {
      line((cx + dx, 5.3), (cx + dx, 4.5), ..dtip, stroke: 0.8pt + black)
    }

    // PONTE/BULBO horizontal dashed bidirectional (spanning beyond column)
    line((lx - 0.8, 3.8), (rx + 0.8, 3.8), ..dtip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

    // PONTE/BULBO → MEDULA (downward arrow)
    line((cx, 3.2), (cx, 2.3), ..tip, stroke: 0.8pt + black)

    // Horizontal dashed bidirectional through circle
    line((lx + 0.2, 1.3), (rx - 0.2, 1.3), ..dtip,
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

    // ── Right-side level labels ──
    let lbl-x = rx + 0.8
    content((lbl-x, 7.7), anchor: "west", text(size: 8.5pt)[Mutação])
    content((lbl-x, 6.2), anchor: "west", text(size: 8.5pt)[Evolução])
    content((lbl-x, 3.8), anchor: "west", text(size: 8.5pt)[Gestão])
    content((lbl-x, 1.1), anchor: "west", text(size: 8.5pt)[Operação])

    // ── Left bracket: Sistema Parassimpático (dashed, flanking MEDULA zone) ──
    let bl = lx - 1.5
    line((lx, 3.2), (bl, 3.2), stroke: 0.8pt + black)
    line((bl, 3.2), (bl, 0.2),
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    line((bl, 0.2), (lx, 0.2), stroke: 0.8pt + black)
    content((bl - 0.4, 1.7), angle: 90deg,
      text(size: 7.5pt)[Sistema Parassimpático])

    // ── Right bracket: Sistema Simpático ──
    let br = rx + 1.5
    line((rx, 3.2), (br, 3.2), stroke: 0.8pt + black)
    line((br, 3.2), (br, 0.2),
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
    line((br, 0.2), (rx, 0.2), stroke: 0.8pt + black)
    content((br + 0.4, 1.7), angle: -90deg,
      text(size: 7.5pt)[Sistema Simpático])

    // ── Lateral organic arc brackets (left and right, two levels each) ──
    // Left arcs — curving leftward away from the column
    bezier((lx, 8.0), (lx, 5.0),
      (lx - 2.0, 7.5), (lx - 2.0, 5.5),
      stroke: 0.7pt + black)
    bezier((lx, 5.0), (lx, 3.0),
      (lx - 2.0, 4.5), (lx - 2.0, 3.5),
      stroke: 0.7pt + black)
    // Right arcs — curving rightward away from the column
    bezier((rx, 8.0), (rx, 5.0),
      (rx + 2.0, 7.5), (rx + 2.0, 5.5),
      stroke: 0.7pt + black)
    bezier((rx, 5.0), (rx, 3.0),
      (rx + 2.0, 4.5), (rx + 2.0, 3.5),
      stroke: 0.7pt + black)
  })
}

// ─────────────────────────────────────────────────────────────
// Shared helper — circle node with number + code label
// ─────────────────────────────────────────────────────────────
#let _node(x, y, num, code) = {
  import cetz.draw: *
  circle((x, y), radius: 0.75, fill: white, stroke: 0.8pt + black)
  content((x, y + 0.22), text(size: 7.5pt, weight: "bold")[#num])
  content((x, y - 0.22), text(size: 7pt)[#code])
}

// Arrow between two node centers (auto-shortened by node radius = 0.75)
#let _arrow(x1, y1, x2, y2) = {
  import cetz.draw: *
  let dx = x2 - x1
  let dy = y2 - y1
  let len = calc.sqrt(dx * dx + dy * dy)
  let ux = dx / len
  let uy = dy / len
  let r = 0.77
  line(
    (x1 + ux * r, y1 + uy * r),
    (x2 - ux * r, y2 - uy * r),
    mark: (end: "straight", fill: black, scale: 0.55),
    stroke: 0.8pt + black,
  )
}

// ─────────────────────────────────────────────────────────────
// Figura 26 — Grafo das atividades de Planejamento da Produção
// ─────────────────────────────────────────────────────────────
#let figura-26() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Node positions (x, y) — y grows upward, arranged bottom to top
    let nodes = (
      ("1",     "DT",    3.0,  0.0),
      ("1.1",   "EDT",   0.0,  0.0),
      ("1.2",   "ABC",   6.5,  0.0),
      ("1.2.1", "FM",    5.0,  2.0),
      ("1.2.2", "FC",    6.5,  2.0),
      ("2",     "ICC",   3.0,  2.0),
      ("2.1",   "CCP",   0.0,  2.0),
      ("2.2",   "CCA",   9.0,  3.2),
      ("2.2.1", "CCAI",  7.0,  4.5),
      ("2.2.2", "CCAO",  9.0,  4.5),
      ("3",     "IPC",   3.0,  4.5),
      ("3.1",   "CG",    0.0,  4.5),
      ("3.2",   "CF",    5.0,  4.5),
      ("4",     "ACP",   3.0,  6.5),
      ("5",     "EV",    3.0,  8.5),
    )

    for (num, code, x, y) in nodes {
      _node(x, y, num, code)
    }

    let edges = (
      // 1 DT → 1.1 EDT
      (3.0,  0.0,  0.0,  0.0),
      // 1 DT → 1.2.1 FM
      (3.0,  0.0,  5.0,  2.0),
      // 1 DT → 2 ICC
      (3.0,  0.0,  3.0,  2.0),
      // 1.2 ABC → 1.2.1 FM
      (6.5,  0.0,  5.0,  2.0),
      // 1.2 ABC → 1.2.2 FC
      (6.5,  0.0,  6.5,  2.0),
      // 1.2.1 FM → 2 ICC
      (5.0,  2.0,  3.0,  2.0),
      // 1.2.2 FC → 2.2 CCA
      (6.5,  2.0,  9.0,  3.2),
      // 2 ICC → 2.1 CCP
      (3.0,  2.0,  0.0,  2.0),
      // 2 ICC → 2.2 CCA
      (3.0,  2.0,  9.0,  3.2),
      // 2 ICC → 3 IPC
      (3.0,  2.0,  3.0,  4.5),
      // 2.2 CCA → 2.2.1 CCAI
      (9.0,  3.2,  7.0,  4.5),
      // 2.2 CCA → 2.2.2 CCAO
      (9.0,  3.2,  9.0,  4.5),
      // 2.2 CCA → 3 IPC
      (9.0,  3.2,  3.0,  4.5),
      // 2.2.1 CCAI → 3 IPC
      (7.0,  4.5,  3.0,  4.5),
      // 3 IPC → 3.1 CG
      (3.0,  4.5,  0.0,  4.5),
      // 3 IPC → 3.2 CF
      (3.0,  4.5,  5.0,  4.5),
      // 3 IPC → 4 ACP
      (3.0,  4.5,  3.0,  6.5),
      // 3.2 CF → 4 ACP
      (5.0,  4.5,  3.0,  6.5),
      // 4 ACP → 5 EV
      (3.0,  6.5,  3.0,  8.5),
    )

    for (x1, y1, x2, y2) in edges {
      _arrow(x1, y1, x2, y2)
    }
  })
}

// ─────────────────────────────────────────────────────────────
// Figura 27 — Grafo das atividades de Programação e Controle da Produção
// ─────────────────────────────────────────────────────────────
#let figura-27() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Node positions (x, y) — y grows upward
    let nodes = (
      ("1.1",   "PE",    0.0,  0.0),
      ("1",     "P.P",   3.0,  0.0),
      ("1.2",   "PF",    6.0,  0.0),
      ("1.1.1", "PCCAO", 0.5,  2.5),
      ("1.1.2", "PCCAI", 2.5,  2.5),
      ("1.3.1", "PCCP",  5.5,  2.5),
      ("2",     "ARO",   3.0,  4.5),
      ("3",     "C.P",   3.0,  6.5),
      ("3.1",   "PPE",   0.0,  6.5),
      ("3.2",   "PPR",   6.0,  6.5),
      ("4",     "AR",    3.0,  9.0),
    )

    for (num, code, x, y) in nodes {
      _node(x, y, num, code)
    }

    let edges = (
      // 1 P.P → 1.1 PE
      (3.0,  0.0,  0.0,  0.0),
      // 1 P.P → 1.2 PF
      (3.0,  0.0,  6.0,  0.0),
      // 1.1 PE → 1.1.1 PCCAO
      (0.0,  0.0,  0.5,  2.5),
      // 1 P.P → 1.1.2 PCCAI
      (3.0,  0.0,  2.5,  2.5),
      // 1.2 PF → 1.3.1 PCCP
      (6.0,  0.0,  5.5,  2.5),
      // 1.1.1 PCCAO → 2 ARO
      (0.5,  2.5,  3.0,  4.5),
      // 1.1.2 PCCAI → 2 ARO
      (2.5,  2.5,  3.0,  4.5),
      // 1.3.1 PCCP → 2 ARO
      (5.5,  2.5,  3.0,  4.5),
      // 2 ARO → 3 C.P
      (3.0,  4.5,  3.0,  6.5),
      // 3 C.P → 3.1 PPE
      (3.0,  6.5,  0.0,  6.5),
      // 3 C.P → 3.2 PPR
      (3.0,  6.5,  6.0,  6.5),
      // 3 C.P → 4 AR
      (3.0,  6.5,  3.0,  9.0),
      // 3.2 PPR → 4 AR
      (6.0,  6.5,  3.0,  9.0),
    )

    for (x1, y1, x2, y2) in edges {
      _arrow(x1, y1, x2, y2)
    }
  })
}
