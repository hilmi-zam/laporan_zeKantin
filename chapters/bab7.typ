= Bab 7: Pengujian & Penutup

Dikerjakan oleh QA Lead[cite: 44, 45].

== 7.1 Bukti Fitur: ListView.builder & Empty State

#image("../images/kosong.jpg", width: 40%)

_File:_ `lib/screens/cart_screen.dart`

Implementasi safe ListView dengan empty state handling:

```dart
cartProvider.isEmpty
  ? Center(child: Text('Keranjang Kosong'))
  : ListView.builder(
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) { ... }
    )
```

== 7.2 Bukti Fitur: Menambahkan ke Keranjang

#image("../images/menambahkan keranjang.jpg", width: 40%)

_File:_ `lib/screens/home_screen.dart`

Add to cart dengan toast notification dan provider update.

== 7.3 Bukti Fitur: Proses Pembayaran

#image("../images/proses pembayaran.jpg", width: 40%)

_File:_ `lib/screens/cart_screen.dart`

Button loading state saat payment processing dengan indicator "Memproses...".

== 7.4 Demo & Repository

_Repository:_ https://github.com/Ghofur102/smart_kantin.git

_Video Demo:_ [Masukkan link YouTube/Google Drive]