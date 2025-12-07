// main.typ
#import "conf.typ": project
#import "cover.typ": cover_page

// Data anggota — tambahkan nomor untuk cover
#let members_data = (
  (number: 1, name: "M. Abdul Ghofur", nim: "362458302016", role: "Backend Architect"),
  (number: 2, name: "Muhammad Ainul Huda", nim: "362458302075", role: "UI Engineer"),
  (number: 3, name: "Danil Amrulloh", nim: "362458302131", role: "Auth & Navigation"),
  (number: 4, name: "M. Hilmi Zamzami", nim: "372458302071", role: "Transaction Logic"),
  (number: 5, name: "M. Hilmi Zamzami", nim: "372458302071", role: "QA Lead & Integ."),
)

// Bungkus dokumen proyek
#show: doc => project(
  title: "Laporan Final Project Smart E-Kantin : zeKantin",
  semester: "Ganjil 2024/2025",
  team_number: "01",
  members: members_data,
  doc
)

// ----------------------------
// Generate Cover
// ----------------------------
#cover_page(
  title: "Laporan Final Project Smart E-Kantin : zeKantin",
  subtitle: "",
  members: members_data,
  logo_path: "images/poliwangi.png",
  institution: "Politeknik Negeri Banyuwangi",
  faculty: "Jurusan Bisnis dan Informatika",
  study_program: "Teknologi Rekayasa Perangkat Lunak",
  mata_kuliah: "Perangkat Bergerak",
  semester: "Ganjil 2024/2025",
  team_number: "01",
  year: "2025"
)

// ----------------------------
// Include chapter files
// ----------------------------
#include "chapters/bab1.typ"
#include "chapters/bab2.typ"
#include "chapters/bab3.typ"
#include "chapters/bab4.typ"
#include "chapters/bab5.typ"
#include "chapters/bab6.typ"
#include "chapters/bab7.typ"
