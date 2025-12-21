import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';
// Note: Kita tidak import PaymentScreen lagi di sini karena alurnya: Order -> Simpan -> Balik ke Map

// Model Menu Item
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
  bool _isSending = false; // Loading saat tekan tombol pesan

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() async {
    final data = await ApiService().getMenu();
    setState(() {
      _allMenu = data.map((item) {
        return MenuItem(
          id: int.parse(item['id'].toString()),
          name: item['nama'],
          desc: item['deskripsi'],
          img: item['gambar'],
          price: double.parse(item['harga'].toString()),
          category: item['kategori'],
        );
      }).toList();
      _isLoading = false;
    });
  }

  // Hitung Total
  double get _totalPrice => _allMenu.fold(0, (sum, item) => sum + (item.price * item.qty));
  int get _totalItems => _allMenu.fold(0, (sum, item) => sum + item.qty);

  // FUNGSI BARU: Kirim Pesanan ke Database
  void _submitOrder() async {
    setState(() => _isSending = true);

    // 1. Ambil item yang qty > 0
    List<Map<String, dynamic>> itemsToSend = _allMenu
        .where((i) => i.qty > 0)
        .map((i) => {
              "id": i.id, // Pastikan ID dikirim (meski belum dipakai php, bagus untuk debug)
              "name": i.name,
              "price": i.price,
              "qty": i.qty,
              "subtotal": i.price * i.qty
            })
        .toList();

    // Cek jika kosong
    if (itemsToSend.isEmpty) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih minimal 1 menu!")),
      );
      return;
    }

    // 2. Panggil API
    final result = await ApiService().inputOrder(
      widget.tableNumber, 
      _totalPrice, 
      itemsToSend
    );

    if (!mounted) return;
    setState(() => _isSending = false);

    // 3. Cek Hasil
    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan Masuk!"), backgroundColor: Colors.green),
      );
      // Kembali ke halaman Map Meja
      Navigator.pop(context); 
    } else {
      // Tampilkan error spesifik dari PHP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${result['message']}"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Grouping Menu per Kategori
    Map<String, List<MenuItem>> groupedMenu = {};
    for (var item in _allMenu) {
      groupedMenu.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: AppColors.accent,
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
                  padding: const EdgeInsets.only(bottom: 120, top: 10),
                  children: groupedMenu.keys.map((category) {
                    return Column(
                      children: [
                        _buildCategoryHeader(category),
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
        color: AppColors.primary, 
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
        color: AppColors.primary, 
        borderRadius: BorderRadius.circular(20), // Card style
      ),
      child: Row(
        children: [
          // Gambar Menu
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            backgroundImage: AssetImage(item.img), 
            // Pastikan aset gambar tersedia, jika error gunakan Icon sebagai fallback di errorBuilder
            onBackgroundImageError: (_, __) {}, 
          ),
          const SizedBox(width: 15),
          
          // Detail Teks
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
          
          // Kontrol Qty
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$_totalItems Item", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(
                  "Total: Rp ${_totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSending ? null : _submitOrder, // Panggil fungsi kirim
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isSending
                    ? const CircularProgressIndicator(color: AppColors.accent)
                    : const Text("KONFIRMASI PESANAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}