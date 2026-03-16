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
  margin: (top: 3cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
  numbering: "1",
  number-align: center + bottom,
  header: context {
    if counter(page).get().first() > 4 {
      set text(size: 9pt, fill: luma(120))
      emph[SIPCP — Fernando Batalha Monteiro]
      h(1fr)
      emph[1982]
    }
  },
)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "pt",
  region: "BR",
)

#set par(
  justify: true,
  leading: 0.8em,
  first-line-indent: 1.5em,
)

#set heading(numbering: none)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  set text(size: 20pt, weight: "bold")
  v(2cm)
  align(center, upper(it.body))
  v(1cm)
}

#show heading.where(level: 2): it => {
  set text(size: 16pt, weight: "bold")
  v(1.5em)
  it
  v(0.5em)
  line(length: 100%, stroke: 0.5pt + luma(180))
  v(0.5em)
}

#show heading.where(level: 3): it => {
  set text(size: 13pt, weight: "bold")
  v(1.2em)
  it
  v(0.4em)
}

#show heading.where(level: 4): it => {
  set text(size: 11pt, weight: "bold", style: "italic")
  v(1em)
  it
  v(0.3em)
}

// --- COVER PAGE ---
#set page(numbering: none, header: none)

#v(4cm)

#align(center)[
  #text(size: 14pt, tracking: 0.3em, weight: "regular")[FERNANDO BATALHA MONTEIRO]
]

#v(3cm)

#align(center)[
  #text(size: 28pt, weight: "bold", tracking: 0.1em)[S I P C P]
]

#v(0.5cm)

#align(center)[
  #text(size: 14pt)[Sistema Integrado de Programação \ e Controle da Produção]
]

#v(1cm)

#line(length: 40%, stroke: 0.5pt + luma(100))

#v(0.5cm)

#align(center)[
  #text(size: 12pt, style: "italic")[Um Modelo Cibernético de \ Administração Industrial]
]

#v(1fr)

#align(center)[
  #text(size: 10pt)[Editora Metro Cúbico Ltda. — Manaus, AM \ 1982]
]

#v(1cm)

// --- RESET PAGE NUMBERING ---
#pagebreak()
#set page(numbering: "i", header: none)
#counter(page).update(1)

// --- TABLE OF CONTENTS ---
#align(center, text(size: 18pt, weight: "bold")[ÍNDICE])
#v(1cm)
#outline(
  title: none,
  indent: 1.5em,
  depth: 3,
)

// --- BEGIN CONTENT ---
#pagebreak()
#set page(
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: luma(120))
      emph[SIPCP — Fernando Batalha Monteiro]
      h(1fr)
      emph[1982]
    }
  },
)
#counter(page).update(1)
