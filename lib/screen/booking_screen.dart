import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/pengguna.dart';

class BookingScreen extends StatefulWidget {
  final Pengguna pengguna;

  const BookingScreen({super.key, required this.pengguna});

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _tanggalPilihan = DateTime.now();
  TimeOfDay _waktuMulai = TimeOfDay.now();
  int _durasiJam = 1;
  String _jenisMeja = 'reguler';
  String _nomorMeja = '1';

  final List<String> _nomorMejaReguler = List.generate(
    20,
    (index) => '${index + 1}',
  );
  final List<String> _nomorMejaVIP = ['1', '2'];

  double get _hargaPerJam => _jenisMeja == 'reguler' ? 30000 : 50000;
  double get _totalHarga => _hargaPerJam * _durasiJam;

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPilihan,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _tanggalPilihan) {
      setState(() {
        _tanggalPilihan = picked;
      });
    }
  }

  Future<void> _pilihWaktu() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _waktuMulai,
    );
    if (picked != null && picked != _waktuMulai) {
      setState(() {
        _waktuMulai = picked;
      });
    }
  }

  void _prosesBooking() {
    if (_formKey.currentState!.validate()) {
      // Di sini akan ada kode untuk menyimpan booking ke database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking berhasil untuk ${DateFormat('dd MMMM yyyy').format(_tanggalPilihan)} pukul ${_waktuMulai.format(context)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Meja Biliar'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                context,
                title: 'Jenis Meja',
                child: Row(
                  children: [
                    _buildTableOption(
                      context,
                      icon: Icons.sports_esports,
                      label: 'Reguler',
                      price: 'Rp30.000/jam',
                      selected: _jenisMeja == 'reguler',
                      onTap: () {
                        setState(() {
                          _jenisMeja = 'reguler';
                          _nomorMeja = _nomorMejaReguler[0];
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildTableOption(
                      context,
                      icon: Icons.star,
                      label: 'VIP',
                      price: 'Rp50.000/jam',
                      selected: _jenisMeja == 'vip',
                      onTap: () {
                        setState(() {
                          _jenisMeja = 'vip';
                          _nomorMeja = _nomorMejaVIP[0];
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                context,
                title: 'Detail Booking',
                child: Column(
                  children: [
                    _buildListTile(
                      title: 'Tanggal',
                      subtitle: DateFormat(
                        'dd MMMM yyyy',
                      ).format(_tanggalPilihan),
                      icon: Icons.calendar_today,
                      onTap: _pilihTanggal,
                    ),
                    const Divider(),
                    _buildListTile(
                      title: 'Waktu Mulai',
                      subtitle: _waktuMulai.format(context),
                      icon: Icons.access_time,
                      onTap: _pilihWaktu,
                    ),
                    const Divider(),
                    _buildListTile(
                      title: 'Nomor Meja',
                      subtitleWidget: DropdownButton<String>(
                        value: _nomorMeja,
                        isExpanded: true,
                        underline: Container(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _nomorMeja = value;
                            });
                          }
                        },
                        items:
                            (_jenisMeja == 'reguler'
                                    ? _nomorMejaReguler
                                    : _nomorMejaVIP)
                                .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text('Meja $value'),
                                  );
                                })
                                .toList(),
                      ),
                      icon: Icons.table_bar,
                    ),
                    const Divider(),
                    _buildListTile(
                      title: 'Durasi',
                      subtitleWidget: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed:
                                _durasiJam > 1
                                    ? () => setState(() => _durasiJam--)
                                    : null,
                          ),
                          Text('$_durasiJam jam'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed:
                                _durasiJam < 5
                                    ? () => setState(() => _durasiJam++)
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTotalHargaCard(context),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _prosesBooking,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Booking Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTableOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String price,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected ? Theme.of(context).primaryColor : Colors.grey;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(price, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitleWidget ?? Text(subtitle ?? ''),
      trailing: icon != null ? Icon(icon) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTotalHargaCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Harga:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rp${NumberFormat('#,###').format(_totalHarga)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
