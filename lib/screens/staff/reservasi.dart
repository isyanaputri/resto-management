import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';

class ReservasiScreen extends StatefulWidget {
  const ReservasiScreen({super.key});

  @override
  State<ReservasiScreen> createState() => _ReservasiScreenState();
}

class _ReservasiScreenState extends State<ReservasiScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedTable;
  int _peopleCount = 1;
  bool _isLoading = false;

  // Daftar nomor meja (Idealnya ambil dari API getTables yang statusnya 'kosong')
  final List<String> _availableTables = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10'];

  // Fungsi memunculkan pemilih tanggal
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: AppColors.accent),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Fungsi memunculkan pemilih waktu
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Kirim data ke database 
  void _submitReservasi() async {
    if (_nameCtrl.text.isEmpty || _selectedDate == null || _selectedTime == null || _selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data reservasi!")),
      );
      return;//cite: 62]
    }

    setState(() => _isLoading = true);

    // Format tanggal & waktu untuk MySQL (YYYY-MM-DD HH:MM:SS)
    String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day} ${_selectedTime!.hour}:${_selectedTime!.minute}:00";

    final result = await ApiService().sendReservation(
      _nameCtrl.text,
      formattedDate,
      _selectedTable!,
    );//cite: 89, 90]

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {//cite: 63]
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil Reservasi! Meja ditandai dipesan."), backgroundColor: Colors.green),
      );
      Navigator.pop(context);//cite: 63]
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${result['message']}"), backgroundColor: Colors.red),
      );//cite: 64]
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,//cite: 1]
      appBar: AppBar(title: const Text("RESERVASI MEJA")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Informasi Pelanggan"),
            _buildTextField("Nama Pelanggan", _nameCtrl, Icons.person),
            _buildTextField("Nomor Telepon/WA", _phoneCtrl, Icons.phone, inputType: TextInputType.phone),
            
            const SizedBox(height: 20),
            _buildSectionTitle("Waktu & Kapasitas"),
            Row(
              children: [
                Expanded(child: _buildPickerTile("Tanggal", _selectedDate == null ? "Pilih" : "${_selectedDate!.day}/${_selectedDate!.month}", Icons.calendar_today, _pickDate)),
                const SizedBox(width: 15),
                Expanded(child: _buildPickerTile("Jam", _selectedTime == null ? "Pilih" : _selectedTime!.format(context), Icons.access_time, _pickTime)),
              ],
            ),
            
            const SizedBox(height: 15),
            _buildPeopleCounter(),
            
            const SizedBox(height: 20),
            _buildSectionTitle("Pilih Meja"),
            _buildTableDropdown(),
            
            const SizedBox(height: 20),
            _buildSectionTitle("Catatan Tambahan (Opsional)"),
            _buildTextField("Contoh: Rayakan Ultah, Meja Pojok", _noteCtrl, Icons.note_add, maxLines: 2),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReservasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.accent)
                  : const Text("SIMPAN RESERVASI", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          hintText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildPickerTile(String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Jumlah Orang", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(onPressed: () => setState(() => _peopleCount > 1 ? _peopleCount-- : null), icon: const Icon(Icons.remove_circle_outline)),
              Text("$_peopleCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => _peopleCount++), icon: const Icon(Icons.add_circle_outline)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTableDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTable,
          hint: const Text("Pilih Nomor Meja"),
          isExpanded: true,
          items: _availableTables.map((t) => DropdownMenuItem(value: t, child: Text("Meja $t"))).toList(),
          onChanged: (val) => setState(() => _selectedTable = val),
        ),
      ),
    );
  }
}