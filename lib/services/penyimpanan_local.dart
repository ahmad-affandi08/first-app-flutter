import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pengguna.dart';

class PenyimpananLocal {
  static const _kunciPenggunaTerkini = 'pengguna_terkini';
  static const _kunciDaftarPengguna = 'daftar_pengguna';

  // Simpan pengguna yang sedang login
  static Future<void> simpanPenggunaTerkini(Pengguna pengguna) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunciPenggunaTerkini, jsonEncode(pengguna.toMap()));
  }

  // Dapatkan pengguna yang sedang login
  static Future<Pengguna?> dapatkanPenggunaTerkini() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_kunciPenggunaTerkini);
    if (data != null) {
      return Pengguna.fromMap(jsonDecode(data));
    }
    return null;
  }

  // Hapus pengguna yang sedang login (untuk logout)
  static Future<void> hapusPenggunaTerkini() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kunciPenggunaTerkini);
  }

  // Simpan pengguna baru ke daftar pengguna
  static Future<void> daftarkanPengguna(Pengguna penggunaBaru) async {
    final prefs = await SharedPreferences.getInstance();

    // Dapatkan daftar pengguna yang ada
    final daftarPengguna = await dapatkanSemuaPengguna();

    // Tambahkan pengguna baru
    daftarPengguna.add(penggunaBaru);

    // Simpan kembali
    await prefs.setString(
      _kunciDaftarPengguna,
      jsonEncode(daftarPengguna.map((p) => p.toMap()).toList()),
    );
  }

  // Dapatkan semua pengguna terdaftar
  static Future<List<Pengguna>> dapatkanSemuaPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_kunciDaftarPengguna);

    if (data == null) return [];

    final list = jsonDecode(data) as List;
    return list.map((item) => Pengguna.fromMap(item)).toList();
  }

  // Cek apakah email sudah terdaftar
  static Future<bool> cekEmailTerdaftar(String email) async {
    final daftarPengguna = await dapatkanSemuaPengguna();
    return daftarPengguna.any((pengguna) => pengguna.email == email);
  }

  // Verifikasi login
  static Future<Pengguna?> verifikasiLogin(
    String email,
    String kataSandi,
  ) async {
    final daftarPengguna = await dapatkanSemuaPengguna();
    try {
      return daftarPengguna.firstWhere(
        (pengguna) =>
            pengguna.email == email && pengguna.kataSandi == kataSandi,
      );
    } catch (e) {
      return null;
    }
  }
}
