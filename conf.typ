// conf.typ
#let project(
  title: "",
  semester: "",
  team_number: "",
  members: (),
  body
) = {

  // Metadata dokumen
  set document(
    author: members.map(m => m.name),
    title: title
  )

  // Format kertas & margin
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    numbering: none,        // cover tidak pakai nomor
  )

  // Font utama dokumen
  set text(
    font: "Times New Roman",
    size: 12pt,
    lang: "id"
  )

  // Heading BAB
  set heading(numbering: "1.1")

  // Format heading BAB 1, BAB 2, dst.
  show heading.where(level: 1): it => {
    // Bab baru: jangan paksa pagebreak sehingga judul dan isi
    // level-2 yang langsung mengikuti tetap berada pada halaman yang sama.
    set page(numbering: "1") // aktifkan numbering setelah cover
    align(center)[
      #text(size: 14pt, weight: "bold")[
        BAB #counter(heading).display() \ #it.body
      ]
    ]
    v(1em)
  }

  // Format sub-bab (2.1, 2.2, dst.)
  show heading.where(level: 2): it => {
    v(1em)
    text(size: 12pt, weight: "bold")[#it.body]
    v(0.5em)
  }

  // Tampilkan isi dokumen
  body
}
