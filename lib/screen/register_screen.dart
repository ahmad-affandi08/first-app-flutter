import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/pengguna.dart';
import '../services/penyimpanan_local.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _kataSandiController = TextEditingController();
  final _konfirmasiKataSandiController = TextEditingController();
  final _nomorTeleponController = TextEditingController();
  final _alamatController = TextEditingController();
  bool _sedangMemuat = false;
  bool _sembunyikanKataSandi = true;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sedangMemuat = true);

    try {
      final email = _emailController.text.trim();
      final emailTerdaftar = await PenyimpananLocal.cekEmailTerdaftar(email);
      if (emailTerdaftar) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email sudah terdaftar')),
          );
        }
        return;
      }

      final penggunaBaru = Pengguna(
        nama: _namaController.text.trim(),
        email: email,
        kataSandi: _kataSandiController.text.trim(),
        nomorTelepon: _nomorTeleponController.text.trim(),
        alamat: _alamatController.text.trim(),
      );

      await PenyimpananLocal.daftarkanPengguna(penggunaBaru);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } finally {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Daftar Akun',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
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
                    _buildPasswordField(
                      controller: _kataSandiController,
                      label: 'Kata Sandi',
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _konfirmasiKataSandiController,
                      label: 'Konfirmasi Kata Sandi',
                      confirmPassword: _kataSandiController,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nomorTeleponController,
                      label: 'Nomor Telepon (Opsional)',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat (Opsional)',
                      icon: Icons.home,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _sedangMemuat ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            _sedangMemuat
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Get.off(() => const LoginScreen());
                      },
                      child: const Text(
                        'Sudah punya akun? Login di sini',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                        ), // Warna hijau
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan $label';
            }
            return null;
          },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    TextEditingController? confirmPassword,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xFF4CAF50),
        ), // Warna hijau
        suffixIcon: IconButton(
          icon: Icon(
            _sembunyikanKataSandi ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _sembunyikanKataSandi = !_sembunyikanKataSandi;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      obscureText: _sembunyikanKataSandi,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Harap masukkan $label';
        }
        if (confirmPassword != null && value != confirmPassword.text) {
          return 'Kata sandi tidak cocok';
        }
        if (value.length < 6) {
          return 'Kata sandi minimal 6 karakter';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _kataSandiController.dispose();
    _konfirmasiKataSandiController.dispose();
    _nomorTeleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}
