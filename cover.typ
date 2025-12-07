// cover.typ — layout cover akademik rapi (Indonesia)

#set page(numbering: none)

#let cover_page(
  title: "",
  subtitle: "",
  members: (),
  institution: "",
  faculty: "",
  study_program: "",
  mata_kuliah: "",
  semester: "",
  team_number: "",
  year: "",
  logo_path: "",
) = {

  // Atur blok tengah untuk cover
  align(center)[
    #v(1.2cm)

    // Judul utama
    #text(size: 20pt, weight: "bold")[#title]
    #v(0.25cm)

    // Keterangan tugas / mata kuliah
    #text(size: 12pt)[Diajukan untuk memenuhi tugas mata kuliah:]
    #text(size: 12pt, weight: "bold")[#mata_kuliah]
    #v(1.0cm)
    #v(1.0cm)
    // Logo kampus
    #image(logo_path, width: 4cm)
    #v(1.0cm)
    #v(1.0cm)
    #v(1.0cm)

    // Penyusun (kelompok)
    #text(size: 12pt)[Disusun oleh:] 
    #text(size: 12pt, weight: "bold")[Kelompok #team_number]
    #v(0.4cm)

    // Daftar anggota: Nama | NIM | Peran
    #table(
      columns: (1fr, auto, 1fr),
      stroke: none,
      align: (left, left, left),
      ..members.map(m => (
        text()[#m.name],
        [#m.nim],
        text(style: "italic")[#m.role]
      )).flatten()
    )

    #v(1.6cm)

    // Identitas kampus (urutan sesuai instruksi)
    #text(size: 12pt)[#faculty]
    #v(0.15cm)
    #text(size: 12pt)[#study_program]
    #v(0.15cm)
    #text(size: 12pt, weight: "bold")[#institution]

    
    // Footer lokasi dan tahun
    #text(size: 12pt, weight: "bold")[Banyuwangi, #year]
    #v(0.5cm)
  ]
}
