import 'package:firstappflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/penyimpanan_local.dart';
import '../model/pengguna.dart';
import 'register_screen.dart';
// import 'home_screen.dart'; // Mengubah import home_screen menjadi main.dart

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _kataSandiController = TextEditingController();
  bool _sedangMemuat = false;
  bool _sembunyikanKataSandi = true;

  @override
  void initState() {
    super.initState();
    _cekLoginSebelumnya();
  }

  Future<void> _cekLoginSebelumnya() async {
    final pengguna = await PenyimpananLocal.dapatkanPenggunaTerkini();
    if (pengguna != null && mounted) {
      _navigasiKeHome(pengguna);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangMemuat = true);

    try {
      final email = _emailController.text.trim();
      final kataSandi = _kataSandiController.text.trim();

      final pengguna = await PenyimpananLocal.verifikasiLogin(email, kataSandi);

      if (pengguna != null) {
        await PenyimpananLocal.simpanPenggunaTerkini(pengguna);
        if (mounted) _navigasiKeHome(pengguna);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email atau kata sandi salah')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  void _navigasiKeHome(Pengguna pengguna) {
    // Mengubah navigasi dari HomeScreen ke MainScreen
    Get.off(() => MainScreen(pengguna: pengguna));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang 👋',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk untuk melanjutkan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap masukkan email';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _kataSandiController,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _sembunyikanKataSandi
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _sembunyikanKataSandi = !_sembunyikanKataSandi;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: _sembunyikanKataSandi,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap masukkan kata sandi';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _sedangMemuat ? null : _handleLogin,
                          child:
                              _sedangMemuat
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const RegisterScreen());
                        },
                        child: const Text('Belum punya akun? Daftar di sini'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _kataSandiController.dispose();
    super.dispose();
  }
}
