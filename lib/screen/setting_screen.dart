import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../model/pengguna.dart';
import '../theme/theme_provider.dart';
import '../services/penyimpanan_local.dart';
import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  final Pengguna pengguna;

  const SettingScreen({super.key, required this.pengguna});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool _notifikasi = true;
  String _bahasa = 'Indonesia';
  bool _sedangMemuat = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Tampilan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Mode Gelap'),
                    subtitle: const Text('Aktifkan tampilan gelap'),
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).primaryColor,
                    ),
                    value: isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Notifikasi'),
                    subtitle: const Text('Terima pemberitahuan dari Fan8Ball'),
                    secondary: Icon(
                      Icons.notifications,
                      color: Theme.of(context).primaryColor,
                    ),
                    value: _notifikasi,
                    onChanged: (bool value) {
                      setState(() {
                        _notifikasi = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Bahasa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Pilih Bahasa'),
                    subtitle: Text(_bahasa),
                    leading: Icon(
                      Icons.language,
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showBahasaDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Versi Aplikasi'),
                    subtitle: const Text('1.0.0'),
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ListTile(
                    title: const Text('Syarat dan Ketentuan'),
                    leading: Icon(
                      Icons.description_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigasi ke halaman syarat dan ketentuan
                    },
                  ),
                  ListTile(
                    title: const Text('Kebijakan Privasi'),
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigasi ke halaman kebijakan privasi
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _sedangMemuat ? null : _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout),
            label:
                _sedangMemuat
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text('Keluar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showBahasaDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pilih Bahasa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Indonesia'),
                  leading: Radio<String>(
                    value: 'Indonesia',
                    groupValue: _bahasa,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _bahasa = value;
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('English'),
                  leading: Radio<String>(
                    value: 'English',
                    groupValue: _bahasa,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _bahasa = value;
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() => _sedangMemuat = true);

    try {
      await PenyimpananLocal.hapusPenggunaTerkini();
      if (mounted) {
        Get.offAll(() => const LoginScreen());
      }
    } finally {
      if (mounted) {
        setState(() => _sedangMemuat = false);
      }
    }
  }
}
