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




