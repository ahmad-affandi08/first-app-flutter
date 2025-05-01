import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengguna.dart';
import '../services/penyimpanan_local.dart';
import 'login_screen.dart';
import '../theme/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Pengguna pengguna;

  const ProfileScreen({super.key, required this.pengguna});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Pengguna _pengguna;
  bool _sedangMemuat = false;

  @override
  void initState() {
    super.initState();
    _pengguna = widget.pengguna;
    _muatDataPengguna();
  }

  Future<void> _muatDataPengguna() async {
    final penggunaTerkini = await PenyimpananLocal.dapatkanPenggunaTerkini();
    if (penggunaTerkini != null && mounted) {
      setState(() {
        _pengguna = penggunaTerkini;
      });
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _sedangMemuat = true);
    await PenyimpananLocal.hapusPenggunaTerkini();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Saya'),
            actions: [
              IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  themeProvider.toggleTheme(!isDarkMode);
                },
              ),
            ],
          ),
          body:
              _sedangMemuat
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            child: Text(
                              _pengguna.nama.isNotEmpty
                                  ? _pengguna.nama[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _pengguna.nama,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _pengguna.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInfoItem(
                          Icons.phone,
                          'Nomor Telepon',
                          _pengguna.nomorTelepon.isNotEmpty
                              ? _pengguna.nomorTelepon
                              : '-',
                        ),
                        _buildInfoItem(
                          Icons.home,
                          'Alamat',
                          _pengguna.alamat.isNotEmpty ? _pengguna.alamat : '-',
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: _sedangMemuat ? null : _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
