// =============================================================
// SIPCP – Sistema Integrado de Programação e Controle da Produção
// Um Modelo Cibernético de Administração Industrial
// Fernando Batalha Monteiro (1982)
//
// Typst source — compiled to PDF
// =============================================================

#set document(
  title: "SIPCP – Sistema Integrado de Programação e Controle da Produção",
  author: "Fernando Batalha Monteiro",
  date: datetime(year: 1982, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.8cm, bottom: 2.8cm, inside: 3cm, outside: 2.2cm),
  numbering: "1",
  number-align: center + bottom,
  header: context {
    let page-num = counter(page).get().first()
    if page-num > 2 {
      set text(size: 8.5pt, fill: luma(140), style: "italic")
      if calc.odd(page-num) {
        h(1fr)
        [SIPCP — Fernando Batalha Monteiro]
      } else {
        [Sistema Integrado de Programação e Controle da Produção]
        h(1fr)
      }
      v(-0.3em)
      line(length: 100%, stroke: 0.3pt + luma(200))
    }
  },
  footer: context {
    let page-num = counter(page).get().first()
    set text(size: 9pt, fill: luma(100))
    align(center, str(page-num))
  },
)

#set text(
  font: "Libertinus Serif",
  size: 13pt,
  lang: "pt",
  region: "BR",
)

#set par(
  justify: true,
  leading: 10pt,
  first-line-indent: 2em,
  spacing: 22pt,
)

#set heading(numbering: none)

// --- ORNAMENT ---
#let ornament() = {
  align(center)[
    #v(0.3cm)
    #text(size: 14pt, fill: luma(140))[— #h(0.3em) · #h(0.3em) —]
    #v(0.3cm)
  ]
}

#let thin-rule() = {
  align(center, line(length: 40%, stroke: 0.5pt + luma(160)))
}

// --- HEADING STYLES ---

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(5cm)
  align(center)[
    #text(size: 13pt, weight: "regular", style: "italic", fill: luma(100), tracking: 0.15em)[
      #upper(it.body)
    ]
  ]
  v(0.8cm)
  ornament()
  v(3cm)
}

#show heading.where(level: 2): it => {
  v(3cm)
  align(center)[
    #text(size: 22pt, weight: "bold")[
      #it.body
    ]
  ]
  v(0.5cm)
  align(center)[
    #text(size: 11pt, fill: luma(150))[— #h(0.3em) · #h(0.3em) —]
  ]
  v(1.5cm)
}

#show heading.where(level: 3): it => {
  v(2cm)
  align(center)[
    #text(size: 16pt, weight: "regular", style: "italic")[
      #it.body
    ]
  ]
  v(0.3cm)
  align(center, line(length: 25%, stroke: 0.3pt + luma(180)))
  v(1cm)
}

#show heading.where(level: 4): it => {
  v(1.5cm)
  align(center)[
    #text(size: 14pt, weight: "bold")[
      #it.body
    ]
  ]
  v(0.8cm)
}

// --- FOOTNOTES ---
#show footnote.entry: set text(size: 9.5pt, fill: luma(60))
#set footnote.entry(separator: line(length: 25%, stroke: 0.3pt + luma(180)))

// --- DROP CAP helper (for chapter openings, optional) ---
#let drop-cap(body) = {
  set par(first-line-indent: 0em)
  body
}

// --- COVER PAGE ---
#set page(numbering: none, header: none, footer: none, margin: 0pt)

#image("logo_hires.jpg", width: 100%, height: 100%, fit: "cover")

// --- TABLE OF CONTENTS ---
#pagebreak()
#set page(
  numbering: "i",
  header: none,
  footer: context {
    set text(size: 9pt, fill: luma(100))
    align(center, counter(page).display("i"))
  },
  margin: (top: 2.8cm, bottom: 2.8cm, inside: 3cm, outside: 2.2cm),
)
#counter(page).update(1)

#v(3cm)
#align(center)[
  #text(size: 13pt, weight: "regular", style: "italic", fill: luma(100), tracking: 0.15em)[ÍNDICE]
]
#v(0.5cm)
#align(center)[
  #text(size: 14pt, fill: luma(140))[— #h(0.3em) · #h(0.3em) —]
]
#v(1.5cm)

#set text(size: 11pt)
#outline(
  title: none,
  indent: 2em,
  depth: 3,
)
#set text(size: 13pt)

// --- BEGIN CONTENT ---
#pagebreak()
#set page(
  numbering: "1",
  header: context {
    let page-num = counter(page).get().first()
    if page-num > 2 {
      set text(size: 8pt, fill: luma(150), style: "italic", tracking: 0.05em)
      align(center)[
        #if calc.odd(page-num) [
          SIPCP #h(1em) · #h(1em) Fernando Batalha Monteiro
        ] else [
          Sistema Integrado de Programação e Controle da Produção
        ]
      ]
      v(-0.2em)
      line(length: 60%, stroke: 0.3pt + luma(210))
    }
  },
  footer: context {
    let page-num = counter(page).get().first()
    set text(size: 9pt, fill: luma(130))
    align(center)[— #str(page-num) —]
  },
)
#counter(page).update(1)
