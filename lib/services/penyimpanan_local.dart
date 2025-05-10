import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../model/pengguna.dart';

class PenyimpananLocal {
  static final _storage = GetStorage();
  static const _kunciPengguna = 'daftar_pengguna';
  static const _kunciPenggunaTerkini = 'pengguna_terkini';

  // Mendaftarkan pengguna baru
  static Future<void> daftarkanPengguna(Pengguna pengguna) async {
    final daftarPengguna = await _dapatkanDaftarPengguna();
    daftarPengguna.add(pengguna.toMap());
    await _storage.write(_kunciPengguna, jsonEncode(daftarPengguna));
  }

  // Memeriksa apakah email sudah terdaftar
  static Future<bool> cekEmailTerdaftar(String email) async {
    final daftarPengguna = await _dapatkanDaftarPengguna();
    return daftarPengguna.any((p) => p['email'] == email);
  }

  // Verifikasi login
  static Future<Pengguna?> verifikasiLogin(
    String email,
    String kataSandi,
  ) async {
    final daftarPengguna = await _dapatkanDaftarPengguna();
    final penggunaMap = daftarPengguna.firstWhere(
      (p) => p['email'] == email && p['kataSandi'] == kataSandi,
      orElse: () => {},
    );

    if (penggunaMap.isEmpty) return null;
    return Pengguna.fromMap(penggunaMap);
  }

  // Menyimpan pengguna yang sedang login
  static Future<void> simpanPenggunaTerkini(Pengguna pengguna) async {
    await _storage.write(_kunciPenggunaTerkini, jsonEncode(pengguna.toMap()));
  }

  // Mendapatkan informasi pengguna yang sedang login
  static Future<Pengguna?> dapatkanPenggunaTerkini() async {
    final penggunaTerkiniJson = _storage.read(_kunciPenggunaTerkini);
    if (penggunaTerkiniJson == null) return null;

    try {
      final penggunaMap = jsonDecode(penggunaTerkiniJson);
      return Pengguna.fromMap(penggunaMap);
    } catch (e) {
      return null;
    }
  }

  // Menghapus informasi pengguna yang sedang login (logout)
  static Future<void> hapusPenggunaTerkini() async {
    await _storage.remove(_kunciPenggunaTerkini);
  }

  // Mendapatkan daftar pengguna dari penyimpanan lokal
  static Future<List<Map<String, dynamic>>> _dapatkanDaftarPengguna() async {
    final daftarJson = _storage.read(_kunciPengguna);
    if (daftarJson == null) return [];

    try {
      final List<dynamic> daftar = jsonDecode(daftarJson);
      return daftar.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Memperbarui informasi pengguna
  static Future<void> perbaruiPengguna(Pengguna pengguna) async {
    final daftarPengguna = await _dapatkanDaftarPengguna();
    final index = daftarPengguna.indexWhere(
      (p) => p['email'] == pengguna.email,
    );

    if (index != -1) {
      daftarPengguna[index] = pengguna.toMap();
      await _storage.write(_kunciPengguna, jsonEncode(daftarPengguna));

      // Jika pengguna yang diperbarui adalah pengguna yang sedang login,
      // perbarui juga informasi pengguna terkini
      final penggunaTerkini = await dapatkanPenggunaTerkini();
      if (penggunaTerkini != null && penggunaTerkini.email == pengguna.email) {
        await simpanPenggunaTerkini(pengguna);
      }
    }
  }
}
