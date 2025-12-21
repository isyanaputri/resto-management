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

  // Fungsi Helper: Mengambil angka total dari teks keterangan (misal: "Est. Tagihan: Rp 50.000")
  double _parseTotalBill(String info) {
    try {
      if (info.contains("Est. Tagihan: Rp")) {
        // Ambil teks setelah "Rp "
        String raw = info.split("Rp")[1]; 
        // Bersihkan titik ribuan dan spasi (misal " 50.000" jadi "50000")
        String clean = raw.replaceAll(".", "").replaceAll(",", "").trim();
        
        // Ambil angka pertama yang ditemukan
        RegExp regex = RegExp(r'(\d+)');
        var match = regex.firstMatch(clean);
        if (match != null) {
          return double.parse(match.group(0)!);
        }
      }
    } catch (e) {
      return 0.0;
    }
    return 0.0;
  }

  // Fungsi untuk Membatalkan Status Meja (Kosongkan Paksa)
  void _cancelTable() async {
    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Konfirmasi Pembatalan"),
            content: const Text(
                "Yakin ingin membatalkan/mengosongkan meja ini? Data order aktif akan dihapus."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text("TIDAK")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("YA, BATALKAN",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      final res =
          await ApiService().cancelTable(widget.tableData['nomor_meja']);
      if (!mounted) return;
      
      if (res['status'] == 'success') {
        Navigator.pop(context); // Kembali ke peta meja agar refresh
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Meja berhasil dikosongkan.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String noMeja = widget.tableData['nomor_meja'] ?? "-";
    String kapasitas = widget.tableData['kapasitas']?.toString() ?? "0";
    // Info tambahan (pesanan atau reservasi) diambil dari database
    String infoAktivitas =
        widget.tableData['keterangan'] ?? "Tidak ada catatan aktif.";

    // Deteksi otomatis total tagihan dari infoAktivitas
    double detectedTotal = _parseTotalBill(infoAktivitas);

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
                Text(
                  "Informasi Status",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ],
            ),
            const Divider(color: AppColors.primary, thickness: 1),
            const SizedBox(height: 10),

            // 3. Konten Informasi (Scrollable)
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
                        status == 'kosong'
                            ? "Meja ini tersedia untuk pelanggan baru."
                            : infoAktivitas,
                        style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Tombol Aksi Dinamis Berdasarkan Status
            
            // KASUS A: MEJA KOSONG
            if (status == 'kosong')
              _buildActionButton(
                label: "MULAI ORDER",
                icon: Icons.add_shopping_cart,
                color: AppColors.primary,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrderScreen(tableNumber: noMeja)),
                  );
                },
              ),

            // KASUS B: MEJA TERISI (Ada Pesanan)
            if (status == 'terisi') ...[
              _buildActionButton(
                label: "PROSES PEMBAYARAN",
                icon: Icons.payments_outlined,
                color: Colors.green, // Hijau agar menonjol
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        tableNumber: noMeja,
                        totalTagihan: detectedTotal, // Kirim total otomatis
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

            // KASUS C: MEJA DIPESAN (Reservasi)
            if (status == 'dipesan') ...[
              _buildActionButton(
                label: "CHECK-IN (ORDER)", 
                icon: Icons.edit_note,
                color: AppColors.primary,
                onPressed: () {
                  // Saat reservasi datang, langsung masuk ke mode order
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrderScreen(tableNumber: noMeja)),
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

  // Widget: Kartu Ringkasan Atas
  Widget _buildSummaryCard(String no, String status, String cap) {
    Color statusColor = status == 'terisi'
        ? AppColors.primary
        : (status == 'dipesan' ? AppColors.reserved : Colors.green);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MEJA",
                  style: TextStyle(
                      color: Colors.white70, fontSize: 14, letterSpacing: 2)),
              Text(no,
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor == AppColors.primary
                      ? Colors.white
                      : statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor == AppColors.primary
                          ? AppColors.primary
                          : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.group, color: AppColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Text("$cap Kursi",
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Widget: Tombol Utama (Solid)
  Widget _buildActionButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // Widget: Tombol Outline (Garis)
  Widget _buildOutlineButton(
      {required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          foregroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}