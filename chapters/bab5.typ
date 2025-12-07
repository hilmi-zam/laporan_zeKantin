#set text(font: "Calibri", size: 11pt)
#set page(margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))
#set heading(numbering: "1.")

= State Management & Logic

Dikerjakan oleh Transaction Logic Specialist (\_zami).

== State Keranjang

State management menggunakan *Provider Pattern* untuk fitur _Add to Cart_, _Remove from Cart_, dan _Update Quantity_.

=== CartProvider Implementation

```dart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  int get itemCount => _cartItems.length;
  int get totalQuantity => 
    _cartItems.fold(0, (sum, item) => sum + item.quantity.toInt());

  void addToCart(ProductsModel product, {double quantity = 1}) {
    final index = _cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    if (index == -1) {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    } else {
      _cartItems[index].quantity += quantity;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, double newQuantity) {
    final index = _cartItems.indexWhere(
      (item) => item.product.productId == productId,
    );
    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
}
```

=== Penggunaan di Home Screen

```dart
void _handleAddToCartButtonhuda(ProductsModel product) {
  final cartProvider = context.read<CartProvider>();
  cartProvider.addToCart(product, quantity: 1);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${product.name} ditambahkan ke keranjang')),
  );
}
```

Badge notifikasi di HomeScreen menggunakan `Consumer<CartProvider>` untuk real-time update:

```dart
Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    if (cartProvider.isEmpty) return const SizedBox.shrink();
    return Positioned(
      right: 8,
      top: 8,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          cartProvider.itemCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  },
)
```

== Perhitungan Checkout

Total harga dihitung berdasarkan logika diskon NIM. Stok di Firebase berkurang otomatis melalui Firestore Transaction Write dengan dua fase: Read & Validate → Write.

=== Logic Diskon NIM (\_zami)

Aturan bisnis berdasarkan digit terakhir NIM:
- *NIM digit terakhir GANJIL*: Diskon 5% pada subtotal, ongkir Rp 5.000
- *NIM digit terakhir GENAP*: Tidak ada diskon, ongkir gratis (Rp 0)

```dart
void _loadUserNimAndRecalc_zami() async {
  final uid = await AuthService.instance.getLoggedInUserId();
  if (uid != null) {
    _nim_zami = uid;  // NIM disimpan dalam userId
  }
  _recalculate_zami();
}

void _recalculate_zami() {
  final cartProvider = context.read<CartProvider>();
  val_subtotal_zami = cartProvider.cartItems.fold(
    0.0, 
    (double sum, item) => sum + (item.product.price * item.quantity)
  );

  val_shipping_zami = 5000.0;
  val_discount_zami = 0.0;

  if (_nim_zami != null && _nim_zami!.isNotEmpty) {
    final digits = _nim_zami!.replaceAll(RegExp(r'\D'), '');
    if (digits.isNotEmpty) {
      final last = int.tryParse(digits[digits.length - 1]) ?? 0;
      if (last % 2 == 1) {
        // GANJIL: Diskon 5%
        val_discount_zami = val_subtotal_zami * 0.05;
        val_shipping_zami = 5000.0;
      } else {
        // GENAP: Gratis ongkir
        val_discount_zami = 0.0;
        val_shipping_zami = 0.0;
      }
    }
  }

  val_total_zami = val_subtotal_zami - val_discount_zami + val_shipping_zami;
  if (mounted) setState(() {});
}
```

=== Manajemen Quantity di Cart Screen

```dart
void _updateQuantityItemhuda_zami(int index, double qty) {
  final cartProvider = context.read<CartProvider>();
  final cartItems = cartProvider.cartItems;

  if (index < cartItems.length) {
    final productId = cartItems[index].product.productId;

    if (qty <= 0) {
      cartProvider.removeFromCart(productId);
    } else {
      cartProvider.updateQuantity(productId, qty);
    }
    _recalculate_zami();
  }
}
```

== Firestore Transaction: Checkout & Stok Reduction

Stok berkurang otomatis dengan dua fase: Read & Validate → Write.

```dart
static Future<void> checkoutAndReduceStock_zami(List<CartItem> items) async {
  final CollectionReference products = _firestore.collection('products');

  await _firestore.runTransaction((transaction) async {
    // Phase 1: Baca semua dokumen dan validasi stok
    final List<Map<String, dynamic>> updates = [];

    for (final item in items) {
      final docRef = products.doc(item.product.productId);
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception('Produk tidak ditemukan: ${item.product.name}');
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final int stock = (data['stock'] ?? 0) as int;
      final int requested = item.quantity.toInt();

      if (stock < requested) {
        throw Exception('Stok tidak cukup untuk ${item.product.name}');
      }

      final int newStock = stock - requested;
      updates.add({'docRef': docRef, 'newStock': newStock});
    }

    // Phase 2: Lakukan semua update stok
    for (final u in updates) {
      final docRef = u['docRef'] as DocumentReference;
      final newStock = u['newStock'] as int;
      transaction.update(docRef, {'stock': newStock});
    }
  });
}
```

== Transaksi Penyimpanan

Setelah checkout berhasil, data transaksi disimpan ke Firestore:

```dart
static Future<String> createTransactions_zami({
  required String userId,
  required int totalFinal,
  required List<CartItem> items,
  required Status status,
}) async {
  try {
    await checkoutAndReduceStock_zami(items);

    final transactionData = {
      'userId': userId,
      'totalFinal': totalFinal,
      'status': status.toString().split('.').last,
      'items': items
          .map((item) => {
                'productId': item.product.productId,
                'name': item.product.name,
                'price': item.product.price,
                'quantity': item.quantity,
                'stock': item.product.stock,
              })
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef =
        await _firestore.collection('transactions').add(transactionData);

    return docRef.id;
  } catch (e) {
    throw Exception('Gagal membuat transaksi: ${e.toString()}');
  }
}
```

== Reset Keranjang Setelah Pembayaran

Setelah pembayaran berhasil, keranjang direset di CartProvider dan state lokal:

```dart
void _resetCart_zami() {
  final cartProvider = context.read<CartProvider>();
  cartProvider.clearCart();

  setState(() {
    val_subtotal_zami = 0.0;
    val_discount_zami = 0.0;
    val_shipping_zami = 5000.0;
    val_total_zami = 0.0;
    _nim_zami = null;
    totalItem = 0;
  });
}
```

---