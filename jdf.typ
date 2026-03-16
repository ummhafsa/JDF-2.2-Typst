// jdf.typ
// Joyner Document Format - Typst Implementation

#let jdf(
  title: "",
  author: "",
  email: "",
  paper-size: "us-letter", // Equivalent to default 'letterpaper'
  abstract: none,
  body,
) = {
  // --- METADATA ---
  set document(title: title, author: author)

  // --- PAGE LAYOUT ---
  // Calculates margins based on the requested paper size
  let page-margin = if paper-size == "a4" {
    (top: 26.25mm, bottom: 42.472mm, left: 34.361mm, right: 34.361mm)
  } else {
    // Defaults to letterpaper
    (top: 1in, bottom: 1.5in, left: 1.5in, right: 1.5in)
  }

  set page(
    paper: paper-size,
    margin: page-margin,
    numbering: "1",
  )

  // --- FONT STUFF ---
  // mathpazo (Palatino) with old-style figures and microtype tracking applied
  // 10 microtype tracking = 0.01em
  set text(
    font: ("Palatino", "Palatino Linotype", "Book Antiqua", "TeX Gyre Pagella"),
    size: 11pt,
    number-type: "old-style",
    tracking: 0.01em,
  )

  // Source Code Pro for raw/monospace text (scaled to ~0.8819)
  show raw: set text(font: "Source Code Pro", size: 9.7pt)

  // Euler Math for equations
  show math.equation: set text(font: "Euler Math", fallback: true)

  // Paragraph spacing and leading
  // 8.5pt spacing. parskip = 8.5pt.
  set par(
    justify: true,
    leading: 8.5pt,
    spacing: 19.5pt,
  )

  // --- COLORS & LINKS ---
  let link-blue = cmyk(100%, 50%, 0%, 0%)
  show link: set text(fill: link-blue)

  // --- TITLE BLOCK ---
  align(center)[
    #block(spacing: 0pt)[
      // liningnums\lsstylehelp{0}
      #text(size: 17pt, number-type: "lining", tracking: 0em)[#title]
    ]
    #v(17pt)
    #author \
    #email
  ]
  v(0pt)

  // --- ABSTRACT ---
  if abstract != none {
    pad(x: 0.5in)[
      #set text(size: 11pt)
      #set par(leading: 8.5pt)
      #text(weight: "bold", style: "italic")[Abstract#h(0.083em)---#h(0.083em)]#abstract
    ]
    v(0pt)
  }

  // --- HEADINGS ---
  set heading(numbering: "1.1")

  // Heading 1 (\section)
  // \lsstylehelp{60} -> tracking: 0.06em, liningnums, Uppercase
  show heading.where(level: 1): it => block(above: 19.5pt, below: 19.5pt)[
    #set text(size: 11pt, weight: "bold", tracking: 0.06em, number-type: "lining")
    #upper[
      #if it.numbering != none {
        counter(heading).display()
        h(0.333em)
      }
      #it.body
    ]
  ]

  // Heading 2 (\subsection)
  show heading.where(level: 2): it => block(above: 19.5pt, below: 19.5pt)[
    #set text(size: 11pt, weight: "bold")
    #if it.numbering != none {
      counter(heading).display()
      h(0.4em)
    }
    #it.body
  ]

  // Heading 3 (\subsubsection)
  show heading.where(level: 3): it => block(above: 19.5pt, below: 19.5pt)[
    #set text(size: 11pt, weight: "bold", style: "italic")
    #if it.numbering != none {
      counter(heading).display()
      h(0.4em)
    }
    #it.body
  ]

  // --- CAPTIONS ---
  show figure.caption: it => pad(x: 1in)[
    #set align(left)
    // small font (8.5pt), letterspaced 20 (0.02em)
    #set text(size: 8.5pt, tracking: 0.02em)
    #set par(leading: 8.5pt)
    #text(weight: "bold", style: "italic")[#it.supplement #it.counter.display(it.numbering)]#h(0.083em)---#h(0.083em)#it.body
  ]

  // --- LISTS ---
  // leftmargin=*, noitemsep, nolistsep
  set list(
    indent: 0pt,
    body-indent: 0.5em,
    marker: text(size: 6pt, baseline: 0.333em)[•],
    spacing: 0.8em // Tight / noitemsep
  )
  set enum(
    indent: 0pt,
    body-indent: 0.5em,
    spacing: 0.8em // Tight / noitemsep
  )

  // --- FOOTNOTES ---
  // footnotesep=8.5pt, letterspaced 20
  show footnote.entry: it => {
    set text(size: 8.5pt, tracking: 0.02em)
    set par(leading: 5.5pt)
    set block(above: 8.5pt)
    it
  }

  // Set default table strokes to vaguely match booktabs
  set table(stroke: 0.5pt + black)

  // 1. Set font size for tables only within this block
  show figure.where(kind: table): set text(size: 8pt) 

  // 2. Set caption to the top
  show figure.where(kind: table): set figure.caption(position: top)

  // Block quotes
  show quote.where(block: true): it => pad(x: 0.20in, it)

  // --- BIBLIOGRAPHY ---
  // Force bibliography to start on a new page and add a custom heading
  show bibliography: it => {
    pagebreak(weak: true)
    heading(level: 1, numbering: "1.")[References]
    // Set paragraph spacing specifically for the bibliography entries
    set par(spacing: 1em)
    it
  }

  // Insert the body text here
  body
}

// --- INLINE HEADINGS (Level 4) ---
// Since Typst makes all `heading` items blocks by default, we recreate
// \subsubsubsection and \paragraph commands as an inline helper function.
#let subsubsubsection(title) = {
  text(weight: "bold", style: "italic")[#title]
  h(0.083em)---h(0.083em)
}
let paragraph-heading = subsubsubsection
