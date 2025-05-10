import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/pengguna.dart';
import '../services/penyimpanan_local.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Pengguna pengguna;

  const HomeScreen({super.key, required this.pengguna});

  void _logout() async {
    await PenyimpananLocal.hapusPenggunaTerkini();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Fan8Ball",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: textColor),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Halo, ${pengguna.nama} 👋",
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Selamat datang di Fan8Ball!",
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Divider(
              thickness: 0.8,
              color: isDark ? Colors.grey[800] : Colors.grey[300],
            ),
            const SizedBox(height: 24),

            // Card Meja Reguler
            _buildModernMejaCard(
              context,
              title: "Meja Reguler",
              description: "20 meja tersedia\nRp30.000 / jam",
              icon: Icons.sports_esports,
              onTap: () {
                Get.toNamed(
                  "/booking",
                  arguments: {"jenis": "reguler", "pengguna": pengguna},
                );
              },
            ),
            const SizedBox(height: 20),

            // Card Meja VIP
            _buildModernMejaCard(
              context,
              title: "Meja VIP",
              description: "2 meja eksklusif\nRp50.000 / jam",
              icon: Icons.star_rounded,
              onTap: () {
                Get.toNamed(
                  "/booking",
                  arguments: {"jenis": "vip", "pengguna": pengguna},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernMejaCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final accentColor = Colors.cyanAccent;

    return Material(
      color: cardColor,
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: accentColor, size: 30),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: textColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
