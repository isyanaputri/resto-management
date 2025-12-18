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
    _fetchTables(); // Ambil data saat layar dibuka [cite: 19]
  }

  // Fungsi untuk sinkronisasi dengan database MySQL
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
      backgroundColor: AppColors.accent, // Background Cream
      appBar: AppBar(
        title: const Text("RESTORA MAP", style: TextStyle(letterSpacing: 2)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTables),//cite: 22]
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservasiScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),//cite: 23]
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))//cite: 24]
          : Column(
              children: [
                _buildLegend(), // Indikator Status [cite: 25]
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 15, 
                      mainAxisSpacing: 15, 
                      childAspectRatio: 1.3,//cite: 27]
                    ),
                    itemCount: _tables.length,
                    itemBuilder: (context, index) {
                      final table = _tables[index];
                      return _buildTableCard(table);//cite: 29]
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Widget Legenda Status Meja
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem("Kosong", Colors.transparent, AppColors.primary),//cite: 31, 33]
          _legendItem("Terisi", AppColors.primary, AppColors.accent),//cite: 34]
          _legendItem("Dipesan", Colors.orangeAccent, Colors.white),//cite: 3, 35]
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color bg, Color text) {
    return Row(
      children: [
        Container(
          width: 15, height: 15, 
          decoration: BoxDecoration(
            color: bg, 
            shape: BoxShape.circle, 
            border: Border.all(color: AppColors.primary)
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  // Card Meja dengan Logika Navigasi
  Widget _buildTableCard(dynamic table) {
    String no = table['nomor_meja'];
    String status = table['status']; // 'kosong', 'terisi', 'dipesan' [cite: 29]
    String kapasitas = table['kapasitas'].toString();

    Color bgColor = Colors.transparent;
    Color txtColor = AppColors.primary;
    BoxBorder? border = Border.all(color: AppColors.primary, width: 2);//cite: 36]

    if (status == 'terisi') {
      bgColor = AppColors.primary;//cite: 34]
      txtColor = AppColors.accent;
      border = null;
    } else if (status == 'dipesan') {
      bgColor = Colors.orangeAccent;//cite: 35]
      txtColor = Colors.white;
      border = null;
    }

    return InkWell(
      onTap: () {
        // LOGIKA: Jika kosong ke Order, jika terisi/dipesan ke Detail Meja
        if (status == 'kosong') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => OrderScreen(tableNumber: no))); //ite: 35]
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailMeja(tableData: table)));
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
            Text(no, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: txtColor)), //ite: 36]
            Text(status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: txtColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 16, color: txtColor),
                const SizedBox(width: 5),
                Text(kapasitas, style: TextStyle(color: txtColor, fontWeight: FontWeight.bold)),//cite: 37]
              ],
            )
          ],
        ),
      ),
    );
  }
}