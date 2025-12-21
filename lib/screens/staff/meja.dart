import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
import '../login.dart';
import 'order.dart';
import 'detail_meja.dart';
import 'reservasi.dart';

class MejaScreen extends StatefulWidget {
  const MejaScreen({super.key});

  @override
  State<MejaScreen> createState() => _MejaScreenState();
}

class _MejaScreenState extends State<MejaScreen> {
  List<dynamic> _tables = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  // Ambil data meja dari database (Refresh)
  void _fetchTables() async {
    setState(() => _isLoading = true);
    final data = await ApiService().getTables();
    setState(() {
      _tables = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: const Text("RESTORA MAP", style: TextStyle(letterSpacing: 2)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTables),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservasiScreen())).then((_) => _fetchTables()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                _buildLegend(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _fetchTables(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _tables.length,
                      itemBuilder: (context, index) {
                        final table = _tables[index];
                        return _buildTableCard(table);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem("Kosong", Colors.transparent, AppColors.primary),
          _legendItem("Terisi", AppColors.primary, AppColors.accent),
          _legendItem("Dipesan", AppColors.reserved, Colors.white),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color bg, Color text) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildTableCard(dynamic table) {
    String no = table['nomor_meja'];
    String status = table['status']; // 'kosong', 'terisi', 'dipesan'
    String kapasitas = table['kapasitas'].toString();

    Color bgColor = Colors.transparent;
    Color txtColor = AppColors.primary;
    BoxBorder? border = Border.all(color: AppColors.primary, width: 2);

    if (status == 'terisi') {
      bgColor = AppColors.primary;
      txtColor = AppColors.accent;
      border = null;
    } else if (status == 'dipesan') {
      bgColor = AppColors.reserved; // Kuning Emas
      txtColor = Colors.white;
      border = null;
    }

    return InkWell(
      onTap: () {
        if (status == 'kosong') {
          // JIKA KOSONG: Tampilkan Pilihan (Info / Order)
          _showEmptyTableOptions(context, table);
        } else {
          // JIKA TERISI/DIPESAN: Langsung ke Detail Meja
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailMeja(tableData: table)),
          ).then((_) => _fetchTables()); // Refresh saat kembali
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(no,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: txtColor)),
            Text(status.toUpperCase(),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: txtColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 16, color: txtColor),
                const SizedBox(width: 5),
                Text(kapasitas,
                    style: TextStyle(color: txtColor, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- LOGIKA BARU: Dialog Pilihan untuk Meja Kosong ---
  void _showEmptyTableOptions(BuildContext context, dynamic tableData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.accent,
        title: Text("Meja ${tableData['nomor_meja']} (KOSONG)", 
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        content: const Text("Silakan pilih tindakan untuk meja ini."),
        actions: [
          // Opsi 1: Lihat Informasi Meja
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
            ),
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailMeja(tableData: tableData)),
              );
            },
            child: const Text("LIHAT INFO", style: TextStyle(color: AppColors.primary)),
          ),
          
          // Opsi 2: Order Menu
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderScreen(tableNumber: tableData['nomor_meja'])),
              ).then((_) => _fetchTables());
            },
            child: const Text("ORDER MENU", style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}