class Pengguna {
  final String nama;
  final String email;
  final String kataSandi;
  final String nomorTelepon;
  final String alamat;

  Pengguna({
    required this.nama,
    required this.email,
    required this.kataSandi,
    this.nomorTelepon = '',
    this.alamat = '',
  });

  // Konversi dari Map (untuk membaca dari penyimpanan lokal)
  factory Pengguna.fromMap(Map<String, dynamic> map) {
    return Pengguna(
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      kataSandi: map['kataSandi'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }

  // Konversi ke Map (untuk menyimpan ke penyimpanan lokal)
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'kataSandi': kataSandi,
      'nomorTelepon': nomorTelepon,
      'alamat': alamat,
    };
  }

  // Membuat salinan objek Pengguna dengan nilai yang diperbarui
  Pengguna copyWith({
    String? nama,
    String? email,
    String? kataSandi,
    String? nomorTelepon,
    String? alamat,
  }) {
    return Pengguna(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      kataSandi: kataSandi ?? this.kataSandi,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      alamat: alamat ?? this.alamat,
    );
  }
}
