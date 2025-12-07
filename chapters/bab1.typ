= Pendahuluan & Pembagian Kerja

== 1. Deskripsi Aplikasi
Aplikasi *zeKantin* merupakan aplikasi pemesanan makanan dan minuman berbasis mobile yang dikembangkan menggunakan Flutter. Tujuan utama aplikasi ini adalah untuk mempermudah serta mempercepat proses transaksi di kantin kampus, sehingga mahasiswa dan pegawai kantin tidak perlu mengantri panjang pada jam sibuk.

Aplikasi ini menghadirkan beberapa fitur utama:
- Login dan Register dengan validasi input.
- Daftar menu makanan dan minuman.
- Keranjang belanja (cart) dengan kalkulasi otomatis.
- Sistem transaksi lokal (tanpa pembayaran online).
- Profil pengguna.
- Mekanisme diskon berdasarkan digit terakhir NIM pengguna:  
  - Ganjil → Diskon 5%  
  - Genap → Gratis ongkir  

Backend aplikasi menggunakan *Cloud Firestore*, sementara arsitektur internal memisahkan tampilan (UI), logika (logic), dan layanan backend (service) untuk memudahkan pengembangan dan pemeliharaan kode.

== 2. Ruang Lingkup & Tujuan Projek
Proyek ini merupakan tugas akhir semester yang harus diselesaikan oleh seluruh anggota tim sesuai pembagian kerja. Tujuan dari pembuatan aplikasi ini adalah untuk memenuhi penilaian mata kuliah terkait pengembangan aplikasi mobile.

Ruang lingkup proyek meliputi:
- Implementasi fitur inti pemesanan.
- Pengelolaan data makanan dan pengguna.
- Manajemen autentikasi.
- Logika cart dan transaksi.
- Pengujian aplikasi dan penyusunan laporan.

Fitur pembayaran online serta proses publikasi aplikasi ke Play Store tidak termasuk dalam ruang lingkup proyek ini.

==  3. Pembagian Tanggung Jawab Anggota

Berikut adalah pembagian tugas akhir yang telah disepakati oleh tim:

#align(center)[
  #table(
    columns: (2fr, 1.5fr, 3fr),
    align: (left, left, left),
    [*Nama*], [*Peran*], [*Tanggung Jawab*],
    [M. Abdul Ghofur (362458302016)], 
    [Backend & Database], 
    [- Setup Project Firebase & struktur database awal\ - Input data dummy minimal 10 menu makanan\ - Membuat class model data (User.kt, Product.kt)],
    [Muhammad Ainul Huda (362458302075)], 
    [UI/UX Engineer], 
    [- Slicing tampilan Login, Register, Home, dan Cart\ - Styling: warna, font, dan aset\ - Penamaan ID komponen dengan suffix inisial],
    [Danil Amrulloh (3624583121)], 
    [Logic Auth & Profile], 
    [- Validasi Login dan Register\ - Manajemen User Session\ - Implementasi halaman Profile],
    [M. Hilmi Zamzami (362458302071)], 
    [Logic Transaksi], 
    [- Logika Cart: tambah item & hitung total\ - Checkout: penerapan diskon ganjil/genap NIM\ - Finalisasi transaksi: pengurangan stok],
    [M. Hilmi Zamzami (362458302071)], 
    [QA, Testing & Report], 
    [- Integrasi kode (merge & conflict resolver)\ - Pengujian fitur dan memastikan tidak ada force close\ - Pembuatan laporan PDF & video demo],
  )
]
