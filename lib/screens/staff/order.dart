import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
import '../payment/payment.dart';

// Model untuk item menu
class MenuItem {
  final int id;
  final String name, desc, img, category;
  final double price;
  int qty;

  MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.img,
    required this.price,
    required this.category,
    this.qty = 0,
  });
}

class OrderScreen extends StatefulWidget {
  final String tableNumber;
  const OrderScreen({super.key, required this.tableNumber});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<MenuItem> _allMenu = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  // Mengambil 12 menu dari database melalui ApiService
  void _loadMenu() async {
    final data = await ApiService().getMenu();
    setState(() {
      _allMenu = data.map((item) {
        return MenuItem(
          id: int.parse(item['id'].toString()),
          name: item['nama'],
          desc: item['deskripsi'],
          img: item['gambar'], // Contoh: 'assets/images/beef_steak.png'
          price: double.parse(item['harga'].toString()),
          category: item['kategori'],
        );
      }).toList();
      _isLoading = false;
    });
  }

  // Hitung total harga
  double get _totalPrice => _allMenu.fold(0, (sum, item) => sum + (item.price * item.qty));
  // Hitung total item dipesan
  int get _totalItems => _allMenu.fold(0, (sum, item) => sum + item.qty);

  @override
  Widget build(BuildContext context) {
    // Mengelompokkan menu berdasarkan kategori untuk tampilan section
    Map<String, List<MenuItem>> groupedMenu = {};
    for (var item in _allMenu) {
      groupedMenu.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: AppColors.accent, // Latar belakang Cream [cite: 45]
      appBar: AppBar(
        title: Text("Pesan Meja ${widget.tableNumber}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  children: groupedMenu.keys.map((category) {
                    return Column(
                      children: [
                        // Header Kategori (Makanan Utama, Minuman, dll)
                        _buildCategoryHeader(category),
                        // Daftar Item dalam kategori tersebut
                        ...groupedMenu[category]!.map((item) => _buildMenuCard(item)),
                      ],
                    );
                  }).toList(),
                ),
                // Tombol Konfirmasi Order (Muncul jika ada item yang dipilih)
                if (_totalItems > 0) _buildBottomCart(),
              ],
            ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary, // Maroon [cite: 47]
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    );
  }

  Widget _buildMenuCard(MenuItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary, // Card Maroon [cite: 55]
        borderRadius: BorderRadius.circular(50), // Sudut sangat melengkung sesuai gambar
      ),
      child: Row(
        children: [
          // Gambar Menu Bulat
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            backgroundImage: AssetImage(item.img),
          ),
          const SizedBox(width: 15),
          // Detail Menu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  item.desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "Rp ${item.price.toStringAsFixed(0)}",
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Kontrol Quantity (Plus/Minus)
          _buildQtyControl(item),
        ],
      ),
    );
  }

  Widget _buildQtyControl(MenuItem item) {
    return Row(
      children: [
        if (item.qty > 0) ...[
          IconButton(
            onPressed: () => setState(() => item.qty--),
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.accent, size: 28),
          ),
          Text(
            "${item.qty}",
            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
        IconButton(
          onPressed: () => setState(() => item.qty++),
          icon: const Icon(Icons.add_circle, color: AppColors.accent, size: 32),
        ),
      ],
    );
  }

  Widget _buildBottomCart() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$_totalItems Item terpilih", style: const TextStyle(color: Colors.white70)),
                Text(
                  "Total: Rp ${_totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(color: AppColors.accent, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Kirim data item yang dipesan ke halaman pembayaran
                List<MenuItem> orderedItems = _allMenu.where((i) => i.qty > 0).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                      tableNumber: widget.tableNumber,
                      totalTagihan: _totalPrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("LANJUT BAYAR", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}