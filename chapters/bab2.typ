#align(center)[= Bab 2: Bukti Keaslian Kode]

Dokumen ini membuktikan bahwa kode dikembangkan secara manual dengan penanda unik dan logika bisnis khusus.

== 2.1 Watermark Code

Setiap fungsi kritis diberi suffix `_zami` sebagai bukti ownership developer. Contoh:

```dart
double val_subtotal_zami = 0.0;
double val_discount_zami = 0.0;
void _recalculate_zami() { ... }
Future<void> _loadUserNimAndRecalc_zami() async { ... }
static Future<void> checkoutAndReduceStock_zami(List<CartItem> items) async { ... }
```

Suffix ini tidak mungkin dihasilkan generator otomatis karena bersifat personal.

== 2.2 Logic Trap: Diskon NIM

Logika unik berdasarkan digit terakhir NIM:

- *Ganjil:* Diskon 5%, ongkir Rp 5.000
- *Genap:* Tidak ada diskon, ongkir gratis

```dart
void _recalculate_zami() {
  final digits = _nim_zami!.replaceAll(RegExp(r'\D'), '');
  final last = int.tryParse(digits[digits.length - 1]) ?? 0;
  
  if (last % 2 == 1) {
    val_discount_zami = val_subtotal_zami * 0.05;
    val_shipping_zami = 5000.0;
  } else {
    val_discount_zami = 0.0;
    val_shipping_zami = 0.0;
  }
  val_total_zami = val_subtotal_zami - val_discount_zami + val_shipping_zami;
}
```

== 2.3 Firestore Transaction

Implementasi two-phase pattern untuk atomic operations:

```dart
static Future<void> checkoutAndReduceStock_zami(List<CartItem> items) async {
  await firestore.runTransaction((transaction) async {
    // Phase 1: Baca dan validasi semua stok
    for (final item in items) {
      final snapshot = await transaction.get(ref);
      if (snapshot['stock'] < item.quantity) {
        throw Exception('Stok tidak cukup');
      }
    }
    
    // Phase 2: Tulis update stok
    for (int i = 0; i < items.length; i++) {
      transaction.update(productRefs[i], {'stock': newStock});
    }
  });
}
```

== 2.4 Provider Pattern

State management menggunakan `ChangeNotifier` untuk reactive UI:

```dart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  
  void addToCart(ProductsModel product, {double quantity = 1}) {
    final existing = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => null,
    );
    
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }
}
```

= Bukti Penggunaan Suffix "huda" pada Variabel dan Fungsi
Berikut adalah bukti penggunaan suffix inisial "huda" pada variabel dan fungsi yang telah dibuat dalam aplikasi Flutter Smart Kantin. Data ini diperoleh dari pencarian regex `\w*huda\b` di direktori `lib/`.

== Variabel dan Fungsi di `lib/screens/register_screen.dart`

- Variabel:
  - `_tfNimControllerhuda` (TextEditingController)
  - `_tfFullNameControllerhuda` (TextEditingController)
  - `_tfEmailControllerhuda` (TextEditingController)
  - `_tfPasswordControllerhuda` (TextEditingController)
  - `_tfConfirmPasswordControllerhuda` (TextEditingController)
  - `_isLoadingButtonhuda` (bool)

- Fungsi:
  - `_handleRegisterButtonhuda()` (Future<void>)

- Variabel lain:
  - `ehuda` (exception variable dalam catch block)

== Variabel dan Fungsi di `lib/screens/login_screen.dart`

- Variabel:
  - `_tfEmailControllerhuda` (TextEditingController)
  - `_tfPasswordControllerhuda` (TextEditingController)
  - `_isLoadingButtonhuda` (bool)

- Fungsi:
  - `_handleLoginButtonhuda()` (Future<void>)

== Variabel dan Fungsi di `lib/screens/home_screen.dart`

- Variabel:
  - `_collectionProductshuda` (CollectionReference)
  - `_listCartItemshuda` (List<CartItem>)
  - `_strSelectedCategoryhuda` (String)

- Fungsi:
  - `_handleAddToCartButtonhuda(ProductsModel product)` (void)
  - `_buildCategoryChiphuda(String value, String label)` (Widget)

== Variabel dan Fungsi di `lib/screens/cart_screen.dart`

- Variabel:
  - `_listCartItemshuda` (List<CartItem>)

- Fungsi:
  - `_updateQuantityItemhuda(int index, double qty)` (void)
  - `_getTotalItemshuda` (getter int)
  - `_getTotalPricehuda` (getter int)
  - `_handlePaymentButtonhuda()` (void)

== Variabel di `lib/screens/admin_products_screen.dart`

- Variabel:
  - Judul AppBar: `'Kelola Produk - huda'` (String)

== Kesimpulan

Suffix "huda" secara konsisten digunakan pada nama variabel dan fungsi di seluruh aplikasi, terutama untuk elemen UI seperti controller teks, state loading, dan handler event. Ini menunjukkan konvensi penamaan yang unik untuk mengidentifikasi komponen yang dibuat secara khusus.

== Penjelasan Fungsi `_handleRegisterButtonhuda`

Fungsi `_handleRegisterButtonhuda` adalah sebuah metode asinkron (async) yang bertugas menangani proses pendaftaran akun pengguna baru dalam aplikasi Flutter Smart Kantin. Fungsi ini dipanggil ketika tombol "Daftar" (Register) ditekan di layar pendaftaran (`RegisterScreen`).

=== Struktur dan Alur Kerja Fungsi:
1. *Pengaturan State Loading*:
   - Mengubah `_isLoadingButtonhuda` menjadi `true` untuk menampilkan indikator loading pada tombol, mencegah interaksi berulang selama proses berlangsung.

2. *Validasi Input Dasar*:
   - Mengambil nilai dari controller teks: NIM, nama lengkap, email, password, dan konfirmasi password.
   - Memeriksa apakah semua field wajib diisi (tidak kosong).
   - Memverifikasi bahwa password dan konfirmasi password cocok.

3. *Panggilan Layanan Registrasi*:
   - Menggunakan `AuthService.instance.register()` untuk mendaftarkan pengguna baru dengan data yang diberikan (nama lengkap, email, password, NIM).
   - Jika registrasi berhasil, mendapatkan UID (User ID) dari Firebase.

4. *Penanganan Kesuksesan*:
   - Menampilkan snackbar dengan pesan "Pendaftaran berhasil!".
   - Menutup layar pendaftaran dan kembali ke layar sebelumnya (biasanya layar login).

5. *Penanganan Error*:
   - Menangkap exception (disimpan dalam variabel `ehuda`).
   - Jika error berasal dari `FirebaseAuthException`, menggunakan pesan error dari Firebase.
   - Jika error lainnya, mengonversi ke string.
   - Menampilkan snackbar dengan pesan error yang sesuai.

6. *Pembersihan State*:
   - Mengatur `_isLoadingButtonhuda` kembali ke `false` di blok `finally`, memastikan indikator loading selalu dihapus, bahkan jika terjadi error.

=== Kegunaan Fungsi:
- *Menyederhanakan Proses Registrasi*: Menggabungkan validasi, panggilan API, dan penanganan UI dalam satu tempat, membuat kode lebih terorganisir dan mudah dipelihara.
- *Pengalaman Pengguna yang Baik*: Menampilkan loading indicator dan feedback (snackbar) untuk memberi tahu pengguna tentang status proses.
- *Keamanan dan Validasi*: Memastikan data input valid sebelum dikirim ke server, mencegah registrasi dengan data tidak lengkap atau tidak konsisten.
- *Error Handling*: Menangani berbagai jenis error (Firebase-specific atau umum) dengan pesan yang informatif, membantu debugging dan memberikan feedback kepada pengguna.
- *Integrasi dengan Firebase*: Menggunakan layanan autentikasi Firebase untuk membuat akun baru, memungkinkan aplikasi terintegrasi dengan backend yang aman.

Fungsi ini merupakan bagian penting dari flow autentikasi aplikasi, memastikan bahwa pengguna dapat mendaftar dengan lancar dan aman.
[cite: 9].

== Logic Trap (Diskon NIM)
Implementasi logika bisnis unik "Ganjil 5%, Genap Gratis Ongkir"[cite: 10].

```dart
// Contoh snippet kode (Logic Trap)
void hitungDiskon_dani(String nim) {
  int lastDigit = int.parse(nim.characters.last);
  if (lastDigit % 2 != 0) {
    // Logika Ganjil
    print("Diskon 5%");
  } else {
    // Logika Genap
    print("Gratis Ongkir");
  }
}
```



