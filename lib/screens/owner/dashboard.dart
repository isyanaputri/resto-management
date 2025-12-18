import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
import '../login.dart';
import '../staff/meja.dart';

class DashboardAnalisis extends StatefulWidget {
  const DashboardAnalisis({super.key});

  @override
  State<DashboardAnalisis> createState() => _DashboardAnalisisState();
}

class _DashboardAnalisisState extends State<DashboardAnalisis> {
  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _fetchAnalisis();
  }

  // Mengambil data analisis dari database [cite: 82]
  void _fetchAnalisis() async {
    setState(() => _isLoading = true);
    final result = await ApiService().getAnalysisData();
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: const Text("OWNER DASHBOARD"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAnalisis,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 25),
                  
                  // Statistik Utama (Pendapatan & Pengeluaran)
                  _buildFinancialCards(),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Analisis Menu Terpopuler"),
                  const SizedBox(height: 10),
                  _buildPopularItemsList(),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Status Operasional Meja"),
                  const SizedBox(height: 15),
                  // Tombol Cepat ke Denah Meja (Heatmap)
                  _buildAccessStaffFeature(),
                ],
              ),
            ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Halo, Bos!", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text("Berikut adalah ringkasan performa restoran hari ini.", 
          style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildFinancialCards() {
    return Row(
      children: [
        _statCard("Pendapatan", "Rp 5.250.000", Icons.trending_up, Colors.green),
        const SizedBox(width: 15),
        _statCard("Pengeluaran", "Rp 1.120.000", Icons.trending_down, Colors.red),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value, 
              style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItemsList() {
    // Data dummy simulasi dari database
    List items = [
      {"name": "Beef Steak", "sold": 45},
      {"name": "Mojito Series", "sold": 38},
      {"name": "Pizza Deluxe", "sold": 22},
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: items.map((i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: Text("${i['sold']} Porsi", 
                  style: const TextStyle(color: AppColors.accent, fontSize: 10)),
              )
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAccessStaffFeature() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MejaScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF63140F)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pantau Heatmap Meja", 
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Lihat status real-time tiap meja", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            Icon(Icons.map, color: AppColors.accent, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, 
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary));
  }
}