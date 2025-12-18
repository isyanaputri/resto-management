import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../payment/payment.dart';

class DetailMeja extends StatelessWidget {
  final Map<String, dynamic> tableData;

  const DetailMeja({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari map yang dikirim oleh MejaScreen
    String noMeja = tableData['nomor_meja'] ?? "-";
    String status = tableData['status'] ?? "kosong";
    String kapasitas = tableData['kapasitas']?.toString() ?? "0";
    
    // Field 'keterangan' di database digunakan untuk menyimpan info pengunjung & pesanan
    String infoAktivitas = tableData['keterangan'] ?? "Belum ada catatan pesanan aktif untuk meja ini.";

    return Scaffold(
      backgroundColor: AppColors.accent, // Background Cream
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
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 10),
                const Text(
                  "Status & Pesanan Aktif",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.primary
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.primary, thickness: 1),
            
            const SizedBox(height: 10),
            
            // 3. Kotak Informasi Detail (Isi Pesanan, Total Pengunjung, dll)
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
                        infoAktivitas,
                        style: const TextStyle(
                          fontSize: 16, 
                          color: AppColors.primary, 
                          height: 1.5
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 4. Tombol Aksi Dinamis
            if (status == 'terisi')
              _buildActionButton(
                label: "PROSES PEMBAYARAN / KASIR",
                icon: Icons.payments_outlined,
                color: AppColors.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        tableNumber: noMeja,
                        totalTagihan: 0, // Nilai ini akan ditarik dari total order di db
                      ),
                    ),
                  );
                },
              ),
              
            const SizedBox(height: 10),
            
            // Tombol untuk mereset status meja secara manual jika diperlukan
            _buildOutlineButton(
              label: "BERSIHKAN / KOSONGKAN MEJA",
              onPressed: () => _confirmResetMeja(context, noMeja),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Kartu Atas
  Widget _buildSummaryCard(String no, String status, String cap) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
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
                  color: status == 'terisi' ? Colors.redAccent : Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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

  // Widget: Tombol Utama
  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // Widget: Tombol Outline
  Widget _buildOutlineButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 2),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Dialog Konfirmasi Reset Meja
  void _confirmResetMeja(BuildContext context, String noMeja) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Kosongkan Meja?"),
        content: Text("Meja $noMeja akan diatur kembali menjadi 'KOSONG'. Pastikan tamu sudah meninggalkan lokasi."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("BATAL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              // Logika API update_status_meja.php ke 'kosong' diletakkan di sini
              Navigator.pop(ctx);
              Navigator.pop(context);
            }, 
            child: const Text("YA, KOSONGKAN", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}