import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
import '../staff/meja.dart';

class PaymentScreen extends StatefulWidget {
  final String tableNumber;
  final double totalTagihan;

  const PaymentScreen({
    super.key, 
    required this.tableNumber, 
    required this.totalTagihan
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = "CASH"; // Default
  final TextEditingController _cashController = TextEditingController();
  double _kembalian = 0;
  bool _isProcessing = false;

  // Hitung kembalian (Khusus Cash)
  void _calculateChange(String value) {
    double input = double.tryParse(value.replaceAll(".", "")) ?? 0;
    setState(() {
      _kembalian = input - widget.totalTagihan;
    });
  }

  // Proses Simpan ke Database
  void _finishPayment() async {
    double bayar = 0;

    // 1. Validasi khusus Cash
    if (_selectedMethod == "CASH") {
      bayar = double.tryParse(_cashController.text.replaceAll(".", "")) ?? 0;
      if (bayar < widget.totalTagihan) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Uang pembayaran kurang!"), backgroundColor: Colors.red)
        );
        return;
      }
    } else {
      // Untuk Non-Tunai, dianggap bayar pas sesuai tagihan
      bayar = widget.totalTagihan;
    }

    setState(() => _isProcessing = true);

    // 2. Kirim ke API
    final res = await ApiService().saveOrder(
      widget.tableNumber, 
      widget.totalTagihan, 
      _selectedMethod.toLowerCase(), // Kirim 'cash', 'qris', 'debit', atau 'credit'
      [] 
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // 3. Cek Hasil
    if (res['status'] == 'success') {
      _showStrukPembayaran(bayar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${res['message']}"), backgroundColor: Colors.red)
      );
    }
  }

  // --- TAMPILAN STRUK ---
  void _showStrukPembayaran(double uangBayar) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 10),
                const Text("PEMBAYARAN BERHASIL", style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                _strukRow("Tanggal", formattedDate),
                _strukRow("Meja", "No. ${widget.tableNumber}"),
                const Divider(),
                _strukRow("TOTAL", "Rp ${widget.totalTagihan.toStringAsFixed(0)}", isBold: true),
                _strukRow("Metode", _selectedMethod),
                if (_selectedMethod == "CASH") ...[
                  _strukRow("Tunai", "Rp ${uangBayar.toStringAsFixed(0)}"),
                  _strukRow("Kembali", "Rp ${_kembalian.toStringAsFixed(0)}"),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (_) => const MejaScreen()), 
                        (route) => false
                      );
                    },
                    child: const Text("TUTUP", style: TextStyle(color: AppColors.accent)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _strukRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(title: const Text("KASIR / PEMBAYARAN")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header
            _buildInfoTile("Nomor Meja", widget.tableNumber),
            _buildInfoTile("Total Tagihan", "Rp ${widget.totalTagihan.toStringAsFixed(0)}"),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            // PILIHAN METODE (GRID 2x2)
            const Text("PILIH METODE PEMBAYARAN", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 10),
            
            Column(
              children: [
                Row(
                  children: [
                    _methodBtn("CASH", Icons.money),
                    const SizedBox(width: 15),
                    _methodBtn("QRIS", Icons.qr_code),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _methodBtn("DEBIT", Icons.credit_card),
                    const SizedBox(width: 15),
                    _methodBtn("CREDIT", Icons.credit_score),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // TAMPILAN BERDASARKAN PILIHAN
            if (_selectedMethod == "CASH") 
              _buildCashSection() 
            else if (_selectedMethod == "QRIS") 
              _buildQrisSection()
            else 
              _buildEdcSection(), // Untuk Debit & Credit

            const SizedBox(height: 40),
            
            // Tombol Proses
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _finishPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: _isProcessing 
                  ? const CircularProgressIndicator(color: AppColors.accent)
                  : const Text("SELESAIKAN PEMBAYARAN", 
                      style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _methodBtn(String label, IconData icon) {
    bool isSelected = _selectedMethod == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedMethod = label),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.accent : AppColors.primary),
              const SizedBox(height: 5),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.accent : AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: CASH (Input Uang)
  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("UANG DITERIMA", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 10),
        TextField(
          controller: _cashController,
          keyboardType: TextInputType.number,
          onChanged: _calculateChange,
          decoration: InputDecoration(
            filled: true, fillColor: Colors.white,
            prefixText: "Rp ",
            hintText: "Masukan Nominal",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("KEMBALIAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              Text("Rp ${_kembalian < 0 ? 0 : _kembalian.toStringAsFixed(0)}", 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
      ],
    );
  }

  // Section 2: QRIS (Tampilkan Barcode Generated)
  Widget _buildQrisSection() {
    String qrData = "RESTORA:M${widget.tableNumber}:${widget.totalTagihan.toInt()}";
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const Text("SCAN QRIS", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(
              "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$qrData",
              height: 200, width: 200,
              errorBuilder: (_,__,___) => const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 10),
            Text("Rp ${widget.totalTagihan.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Section 3: EDC (Debit / Credit)
  Widget _buildEdcSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(
          children: [
            Icon(Icons.point_of_sale, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 15),
            Text("Gunakan Mesin EDC ($_selectedMethod)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            const Text("Gesek kartu pada mesin EDC bank yang tersedia.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text("Tagihan: Rp ${widget.totalTagihan.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}