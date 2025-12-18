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
  String _selectedMethod = "CASH"; // Default metode
  final TextEditingController _cashController = TextEditingController();
  double _kembalian = 0;
  bool _isProcessing = false;

  // Fungsi menghitung kembalian secara real-time
  void _calculateChange(String value) {
    double input = double.tryParse(value) ?? 0;
    setState(() {
      _kembalian = input - widget.totalTagihan;
    });
  }

  // Fungsi finalisasi pembayaran ke database
  void _finishPayment() async {
    if (_selectedMethod == "CASH") {
      double bayar = double.tryParse(_cashController.text) ?? 0;
      if (bayar < widget.totalTagihan) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Uang yang dibayarkan kurang!"))
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    // Memanggil API untuk simpan order dan ubah status meja jadi 'kosong'
    final res = await ApiService().saveOrder(
      widget.tableNumber, 
      widget.totalTagihan, 
      _selectedMethod.toLowerCase(),
      [] // Item order dikirim di sini jika ingin detail per menu
    );

    if (res['status'] == 'success') {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${res['message']}"))
      );
    }
    setState(() => _isProcessing = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("PEMBAYARAN LUNAS", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
            Text("Meja ${widget.tableNumber} sekarang tersedia.", 
              style: const TextStyle(color: AppColors.primary)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (_) => const MejaScreen()), 
                  (route) => false
                );
              },
              child: const Text("KEMBALI KE BERANDA", style: TextStyle(color: AppColors.accent)),
            )
          ],
        ),
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
            // Ringkasan Tagihan
            _buildInfoTile("Nomor Meja", widget.tableNumber),
            _buildInfoTile("Total Tagihan", "Rp ${widget.totalTagihan.toStringAsFixed(0)}"),
            const SizedBox(height: 30),

            const Text("PILIH METODE PEMBAYARAN", 
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 15),

            Row(
              children: [
                _methodBtn("CASH", Icons.money),
                const SizedBox(width: 15),
                _methodBtn("BARCODE", Icons.qr_code_scanner),
              ],
            ),

            const SizedBox(height: 30),

            // Tampilan Berdasarkan Metode
            if (_selectedMethod == "CASH") _buildCashSection() else _buildBarcodeSection(),

            const SizedBox(height: 40),

            // Tombol Selesaikan
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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
              Text(label, style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isSelected ? AppColors.accent : AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("NOMINAL UANG DITERIMA", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 10),
        TextField(
          controller: _cashController,
          keyboardType: TextInputType.number,
          onChanged: _calculateChange,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixText: "Rp ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("KEMBALIAN", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text("Rp ${_kembalian < 0 ? 0 : _kembalian.toStringAsFixed(0)}", 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeSection() {
    return Center(
      child: Column(
        children: [
          const Text("SCAN QRIS UNTUK BAYAR", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
            ),
            child: Image.network(
              "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=RESTORA-PAYMENT", // Dummy QR
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}