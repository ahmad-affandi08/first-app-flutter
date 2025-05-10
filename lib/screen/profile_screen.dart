import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengguna.dart';
import '../services/penyimpanan_local.dart';
import '../theme/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Pengguna pengguna;

  const ProfileScreen({super.key, required this.pengguna});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Pengguna _pengguna;
  bool sedangMemuat = false;

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

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Profil Saya'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body:
              sedangMemuat
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).cardColor,
                              child: Text(
                                _pengguna.nama.isNotEmpty
                                    ? _pengguna.nama[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _pengguna.nama,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _pengguna.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInfoCard(
                          Icons.phone,
                          'Nomor Telepon',
                          _pengguna.nomorTelepon.isNotEmpty
                              ? _pengguna.nomorTelepon
                              : '-',
                        ),
                        _buildInfoCard(
                          Icons.home,
                          'Alamat',
                          _pengguna.alamat.isNotEmpty ? _pengguna.alamat : '-',
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
