= Implementasi Antarmuka & Auth

Dikerjakan oleh UI Engineer dan Auth Controller[cite: 28, 33].

== Halaman Login & Register

Validasi form diterapkan pada input email dan password untuk meningkatkan keamanan dan memastikan hanya pengguna kampus yang dapat mendaftar atau masuk [cite: 36]. Rincian validasinya sebagai berikut:

- Password:
  - Aturan: minimal 6 karakter.
  - Tujuan: mencegah password terlalu pendek yang mudah ditebak dan memberikan ambang minimal untuk pengalaman pengguna.

- Email:
  - Aturan: harus berbentuk email valid dan memakai domain kampus (mis. `@kampus.ac.id` atau domain kampus yang ditentukan oleh tim).
  - Tujuan: membatasi akses ke pemilik email institusi sehingga hanya anggota kampus yang bisa mendaftar.

Contoh validator singkat (Dart) yang digunakan di layar login/register:

```dart
String? validateEmailCampus(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email tidak boleh kosong';
  final email = v.trim();
  final basic = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}\$');
  if (!basic.hasMatch(email)) return 'Format email tidak valid';
  final allowed = ['@kampus.ac.id']; // sesuaikan dengan domain kampus
  final ok = allowed.any((d) => email.toLowerCase().endsWith(d));
  return ok ? null : 'Gunakan email domain kampus';
}

String? validatePassword(String? v) {
  if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
  return v.trim().length >= 6 ? null : 'Password minimal 6 karakter';
}
```

Catatan tambahan:

- Berikan pesan error inline di bawah field agar pengguna dapat segera memperbaiki input.
- Lakukan trim pada input untuk menghindari spasi tak sengaja.
- Gunakan perbandingan case-insensitive untuk pengecekan domain.
- Selalu ulang validasi di sisi server / rules Firestore; validasi sisi-klien hanya untuk pengalaman pengguna.

== Halaman Login

Halaman login adalah halaman pertama yang ditampilkan kepada pengguna ketika aplikasi dibuka. Halaman ini memungkinkan pengguna untuk masuk ke akun mereka dengan memasukkan email dan password. Berikut adalah potongan kode untuk halaman login (`lib/screens/login_screen.dart`):

```dart
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:smart_kantin/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _tfEmailControllerhuda = TextEditingController();
  final _tfPasswordControllerhuda = TextEditingController();
  bool _isLoadingButtonhuda = false;

  @override
  void dispose() {
    _tfEmailControllerhuda.dispose();
    _tfPasswordControllerhuda.dispose();
    super.dispose();
  }

  Future<void> _handleLoginButtonhuda() async {
    final email = _tfEmailControllerhuda.text.trim();
    final password = _tfPasswordControllerhuda.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    setState(() {
      _isLoadingButtonhuda = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      final uid = await AuthService.instance.login(email: email, password: password);

      if (uid == null) {
        throw Exception('Gagal login, periksa kredensial Anda');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil!')),
      );

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        final err = e.toString();
        if (err.contains('CONFIGURATION_NOT_FOUND') || err.contains('RecaptchaAction')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Konfigurasi Firebase Web belum diatur: jalankan flutterfire configure atau jalankan di emulator / device Android/iOS',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal login: $err')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingButtonhuda = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 150,
                      backgroundImage: AssetImage('assets/images/logo zeKantin.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Masuk Akun',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selamat datang di zeKantin',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              CustomTextField(
                label: 'Email',
                hint: 'Masukkan email Anda',
                controller: _tfEmailControllerhuda,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Masukkan password Anda',
                controller: _tfPasswordControllerhuda,
                obscureText: true,
              ),
              CustomButton(
                label: 'Masuk',
                isLoading: _isLoadingButtonhuda,
                onPressed: _handleLoginButtonhuda,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Color(0xFF2E79DB), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

== Penjelasan:
 Halaman login menggunakan `StatefulWidget` untuk mengelola state seperti controller teks dan loading button. Fungsi `_handleLoginButtonhuda` menangani proses login dengan validasi email dan password, kemudian memanggil `AuthService.instance.login`. Jika berhasil, navigasi ke halaman home menggunakan `Navigator.pushReplacementNamed`. Jika gagal, menampilkan snackbar dengan pesan error. UI terdiri dari logo, judul, field email dan password, tombol login, dan link ke halaman register.

== Navigasi dan Routing Antar Halaman

Routing didefinisikan di `lib/main.dart` dalam `MaterialApp`. Berikut potongan kode yang saya buat untuk routing:

```dart
routes: {
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/cart': (context) => const CartScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/admin/products': (context) => const AdminProductsScreen(),
  '/admin/product_form': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductsModel) {
      return ProductFormScreen(product: args);
    }
    return const ProductFormScreen();
  },
},
```

== Penjelasan: 
Routing menggunakan named routes. Setiap route dipetakan ke widget screen tertentu. Untuk `/admin/product_form`, ada penanganan argumen untuk mengedit produk yang ada.

Navigasi antar halaman dilakukan dengan `Navigator.pushNamed` untuk menambah stack, `pushReplacementNamed` untuk mengganti halaman saat ini, atau `pop` untuk kembali. Contoh dari login screen: `Navigator.pushNamed(context, '/register')` untuk ke register, dan `Navigator.pushReplacementNamed(context, '/home')` setelah login berhasil.

Dalam aplikasi ini, navigasi utama adalah dari login ke home, lalu dari home ke cart, profile, dll. Admin dapat mengakses halaman produk dan form produk.
[cite: 34].