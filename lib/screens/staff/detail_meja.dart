import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
import '../payment/payment.dart';
import 'order.dart';

class DetailMeja extends StatefulWidget {
  final Map<String, dynamic> tableData;

  const DetailMeja({super.key, required this.tableData});

  @override
  State<DetailMeja> createState() => _DetailMejaState();
}

class _DetailMejaState extends State<DetailMeja> {
  late String status;
  
  @override
  void initState() {
    super.initState();
    status = widget.tableData['status'] ?? "kosong";
  }

  // Fungsi untuk Membatalkan Status Meja (Kosongkan Paksa)
  void _cancelTable() async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Pembatalan"),
        content: const Text("Yakin ingin membatalkan/mengosongkan meja ini? Data order aktif mungkin akan hilang."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("TIDAK")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("YA, BATALKAN", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      final res = await ApiService().cancelTable(widget.tableData['nomor_meja']);
      if (!mounted) return;
      if (res['status'] == 'success') {
        Navigator.pop(context); // Kembali ke peta meja
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Meja berhasil dikosongkan.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String noMeja = widget.tableData['nomor_meja'] ?? "-";
    String kapasitas = widget.tableData['kapasitas']?.toString() ?? "0";
    // Info tambahan (misal nama reservasi) diambil dari kolom keterangan
    String infoAktivitas = widget.tableData['keterangan'] ?? "Tidak ada catatan aktif.";

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: Text("Detail Meja $noMeja"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kartu Ringkasan Meja
            _buildSummaryCard(noMeja, status, kapasitas),
            
            const SizedBox(height: 25),
            
            // 2. Judul Informasi
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                SizedBox(width: 10),
                Text("Informasi Status",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const Divider(color: AppColors.primary, thickness: 1),
            const SizedBox(height: 10),
            
            // 3. Konten Informasi
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status == 'kosong' ? "Meja ini tersedia untuk pelanggan baru." : infoAktivitas,
                        style: const TextStyle(fontSize: 16, color: AppColors.primary, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 4. Tombol Aksi Berdasarkan Status
            if (status == 'kosong')
              // Jika Kosong -> Tombol Order
              _buildActionButton(
                label: "MULAI ORDER",
                icon: Icons.add_shopping_cart,
                color: AppColors.primary,
                onPressed: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => OrderScreen(tableNumber: noMeja)),
                  );
                },
              ),

            if (status == 'terisi') ...[
              // Jika Terisi -> Tombol Bayar & Cancel
              _buildActionButton(
                label: "PROSES PEMBAYARAN",
                icon: Icons.payments_outlined,
                color: Colors.green, // Hijau agar beda
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        tableNumber: noMeja,
                        totalTagihan: 0, // Nanti diupdate real di halaman payment
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildOutlineButton(
                label: "BATALKAN / KOSONGKAN",
                color: Colors.red,
                onPressed: _cancelTable,
              ),
            ],

            if (status == 'dipesan') ...[
               // Jika Reservasi -> Tombol Cancel Reservasi
               _buildActionButton(
                label: "CHECK-IN (ORDER)", // Ubah status jadi terisi dengan order
                icon: Icons.edit_note,
                color: AppColors.primary,
                onPressed: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => OrderScreen(tableNumber: noMeja)),
                  );
                },
              ),
               const SizedBox(height: 10),
               _buildOutlineButton(
                label: "BATALKAN RESERVASI",
                color: Colors.red,
                onPressed: _cancelTable,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String no, String status, String cap) {
    Color statusColor = status == 'terisi' ? AppColors.primary : 
                        (status == 'dipesan' ? AppColors.reserved : Colors.green);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MEJA", style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2)),
              Text(no, style: const TextStyle(color: AppColors.accent, fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor == AppColors.primary ? Colors.white : statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor == AppColors.primary ? AppColors.primary : Colors.white, 
                    fontSize: 10, fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.group, color: AppColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Text("$cap Kursi", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({required String label, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          foregroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}