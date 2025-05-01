class Pengguna {
  String nama;
  String email;
  String kataSandi;
  String nomorTelepon;
  String alamat;

  Pengguna({
    required this.nama,
    required this.email,
    required this.kataSandi,
    this.nomorTelepon = '',
    this.alamat = '',
  });

  // Konversi ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'kataSandi': kataSandi,
      'nomorTelepon': nomorTelepon,
      'alamat': alamat,
    };
  }

  // Membuat objek Pengguna dari Map
  factory Pengguna.fromMap(Map<String, dynamic> map) {
    return Pengguna(
      nama: map['nama'],
      email: map['email'],
      kataSandi: map['kataSandi'],
      nomorTelepon: map['nomorTelepon'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }
}
