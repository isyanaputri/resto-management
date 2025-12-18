import 'package:flutter/material.dart';

// Definisi Warna yang Digunakan (Konstanta Global)
const Color kPrimaryColor = Color(0xFF5D1E1E); // Merah Marun/Cokelat Tua
const Color kAccentColor = Color(0xFFD32F2F);  // Merah terang untuk aksen
const Color kBackgroundColor = Color(0xFFF9F9F9); // Krem/Putih Gading
const Color kSuccessColor = Color(0xFF4CAF50); // Hijau
const double kPadding = 16.0;

void main() {
  runApp(const MyApp());
}

// =========================================================================
// MODEL DATA PESANAN
// =========================================================================

class OrderItem {
  final String name;
  final int price;
  int quantity;
  final String imageUrl;

  OrderItem({required this.name, required this.price, this.quantity = 1, required this.imageUrl});
  
  int get subtotal => price * quantity;
}

// =========================================================================
// KONFIGURASI APLIKASI UTAMA
// =========================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pembayaran Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const DetailPesananScreen(), // Frame Awal
    );
  }
}

// =========================================================================
// WIDGET BANTUAN UMUM
// =========================================================================

// Widget untuk menampilkan gambar asli dari assets
Widget _buildProductImage(String type, double size) {
  String imagePath = 'assets/placeholder.png'; // fallback bila tidak ada gambar

  if (type == 'Pizza') {
    imagePath = 'assets/pizza.png';
  } else if (type == 'Americano') {
    imagePath = 'assets/americano.png';
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}


// Helper untuk format mata uang
String formatCurrency(int amount) {
  return 'Rp${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

// =========================================================================
// FRAME 1: DETAIL PESANAN (StatefulWidget untuk Kuantitas)
// =========================================================================

class DetailPesananScreen extends StatefulWidget {
  const DetailPesananScreen({super.key});

  @override
  State<DetailPesananScreen> createState() => _DetailPesananScreenState();
}

class _DetailPesananScreenState extends State<DetailPesananScreen> {
  // Data Pesanan Awal
  List<OrderItem> cartItems = [
    OrderItem(name: 'Pizza Hut (Size M)', price: 150000, quantity: 1, imageUrl: 'Pizza'),
    OrderItem(name: 'Americano Coffee', price: 35000, quantity: 2, imageUrl: 'Americano'),
  ];
  
  // Biaya Tambahan
  final int serviceFee = 25000;
  final int tax = 20000;
  int get subtotal => cartItems.fold(0, (sum, item) => sum + item.subtotal);
  int get totalAmount => subtotal + serviceFee + tax;

  // Catatan Tambahan
  String note = '';
  
  void _updateQuantity(int index, int change) {
    setState(() {
      int current = cartItems[index].quantity;
      if (current + change > 0) {
        cartItems[index].quantity += change;
      } else if (current + change == 0) {
        // Hapus item jika kuantitasnya menjadi nol
        cartItems.removeAt(index);
      }
    });
  }

  void _showNoteEditor() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String tempNote = note;
        return AlertDialog(
          title: const Text('Tinggalkan Catatan'),
          content: TextField(
            onChanged: (value) => tempNote = value,
            controller: TextEditingController(text: note),
            decoration: const InputDecoration(hintText: "Contoh: Jangan terlalu pedas..."),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: kAccentColor)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Simpan', style: TextStyle(color: kPrimaryColor)),
              onPressed: () => Navigator.pop(context, tempNote),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        note = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Daftar Item Pesanan ---
            const Text('Daftar Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const Divider(),
            ...List.generate(cartItems.length, (index) {
              return _buildOrderItem(context, cartItems[index], index);
            }),
            const SizedBox(height: 25),

            // --- Catatan Tambahan ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Catatan Tambahan', style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: _showNoteEditor,
                  child: Text(
                    note.isEmpty ? 'Tinggalkan Catatan...' : 'Edit Catatan',
                    style: const TextStyle(color: kAccentColor),
                  ),
                ),
              ],
            ),
            if (note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0, left: 5),
                child: Text('Note: $note', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700)),
              ),
            
            // --- Rincian Total Card ---
            const Text('Rincian Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const Divider(),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Column(
                  children: [
                    _buildTotalRow('Subtotal Pesanan', formatCurrency(subtotal)),
                    _buildTotalRow('Biaya Layanan', formatCurrency(serviceFee)),
                    _buildTotalRow('Pajak (10%)', formatCurrency(tax)),
                    const Divider(height: 20),
                    _buildTotalRow('Total Tagihan', formatCurrency(totalAmount), isBold: true, fontSize: 18, isAccent: true),
                    const SizedBox(height: 5),
                    const Text('Total yang harus dibayar', style: TextStyle(fontSize: 12, color: kSuccessColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      // --- Bottom Navigasi ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(kPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatCurrency(totalAmount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MetodePembayaranScreen(
                    total: totalAmount,
                    cartItems: cartItems,
                  )),
                );
              },
              child: const Text('Lanjut Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildProductImage(item.imageUrl, 60),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(formatCurrency(item.price), style: const TextStyle(color: kAccentColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              _buildQuantityControl(item.quantity, (change) {
                _updateQuantity(index, change);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl(int quantity, ValueChanged<int> onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: quantity > 1 ? kPrimaryColor : Colors.grey, size: 20), 
            onPressed: () => onChanged(-1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: kAccentColor, size: 20), 
            onPressed: () => onChanged(1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount, {bool isBold = false, bool isAccent = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isBold ? kPrimaryColor : Colors.black)),
          Text(amount, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isAccent ? kAccentColor : Colors.black, fontSize: fontSize)),
        ],
      ),
    );
  }
}

// =========================================================================
// FRAME 2: METODE PEMBAYARAN
// =========================================================================

class MetodePembayaranScreen extends StatelessWidget {
  final int total;
  final List<OrderItem> cartItems;

  const MetodePembayaranScreen({super.key, required this.total, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Pilih Opsi Pembayaran'),
          
          // Detail Pesanan Ringkas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16.0),
            child: Text('Total ${formatCurrency(total)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kAccentColor)),
          ),
          
          // Opsi Pembayaran List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Metode Populer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(),
                  // QRIS 
                  _buildPaymentOption(context, 'QRIS (Semua Bank)', Icons.qr_code, const QRISScreen(total: 245000)), 
                  
                  const SizedBox(height: 20),
                  const Text('Pembayaran Tunai & Kartu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(),
                  // Kartu Debit/Kredit
                  _buildPaymentOption(context, 'Kartu Debit/Kredit', Icons.credit_card, const PembayaranGagalScreen()), // Simulasi kartu gagal
                  // Cash 
                  _buildPaymentOption(context, 'Cash/Tunai (Bayar di Kasir)', Icons.money, const PembayaranBerhasilScreen(total: 245000, isCash: true)),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      // --- Bottom Navigasi ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(kPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Default ke QRIS
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRISScreen(total: 245000)),
            );
          },
          child: Text('Bayar Sekarang ${formatCurrency(total)}'),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, Widget nextScreen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: kPrimaryColor, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// FRAME 3: QRIS
// =========================================================================

class QRISScreen extends StatelessWidget {
  final int total;
  const QRISScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(color: kAccentColor),
            child: Text('Total Pembayaran: ${formatCurrency(total)}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded( 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.all(kPadding),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20), 
                    // QRIS Code Container
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Placeholder for QR Code
                          ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                       child: Image.asset(
                      'assets/qris.png',
                      width: 200,
                       height: 200,
                       fit: BoxFit.cover,
                        ),
                        ),

                          const SizedBox(height: 20),
                          const Text('Scan kode di atas menggunakan aplikasi Bank/E-wallet Anda.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), 

                    // Tombol Simulasi Aksi
                    ElevatedButton(
                      onPressed: () {
                        // Simulasi Pembayaran Berhasil
                        Navigator.pushReplacement( 
                          context,
                          MaterialPageRoute(builder: (context) => const PembayaranBerhasilScreen(total: 245000)),
                        );
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSuccessColor,
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: const Text('Simulasi Pembayaran Berhasil', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        // Simulasi Pembayaran Gagal
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const PembayaranGagalScreen()),
                        );
                      }, 
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kAccentColor,
                        side: const BorderSide(color: kAccentColor, width: 2),
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: const Text('Simulasi Pembayaran Gagal', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(kPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Bagikan', Icons.share, () {}, kPrimaryColor),
                _buildActionButton('Download', Icons.download, () {}, kPrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap, Color color) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// =========================================================================
// FRAME 4: PEMBAYARAN GAGAL
// =========================================================================

class PembayaranGagalScreen extends StatelessWidget {
  const PembayaranGagalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Gagal'),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            // Status Gagal Card
            Card(
              color: kAccentColor.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: kAccentColor)),
              child: Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                child: const Column(
                  children: [
                    Icon(Icons.cancel_outlined, color: kAccentColor, size: 90), 
                    SizedBox(height: 10),
                    Text('Pembayaran Gagal!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kAccentColor)),
                    Text('Terjadi kesalahan. Silakan coba metode pembayaran lain atau ulangi transaksi.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Detail Ringkas Pesanan
            _buildDetailSection('Rincian Gagal', [
              _buildDetailRow('Tanggal', '11 Des 2025'),
              _buildDetailRow('Metode', 'Kartu Debit/Kredit'),
              _buildDetailRow('Status', 'Ditolak Bank', isAccent: true),
              const Divider(),
              _buildDetailRow('Total Tagihan', formatCurrency(245000), isBold: true, fontSize: 16),
            ]),
            const SizedBox(height: 50),
            
            // Tombol Aksi
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Kembali ke Metode Pembayaran
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Text('Coba Lagi / Pilih Metode Lain', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const Divider(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isBold = false, double fontSize = 14, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isBold ? kPrimaryColor : Colors.black)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isAccent ? kAccentColor : Colors.black)),
        ],
      ),
    );
  }
}


// =========================================================================
// FRAME 5: PEMBAYARAN BERHASIL
// =========================================================================

class PembayaranBerhasilScreen extends StatelessWidget {
  final int total;
  final bool isCash;
  const PembayaranBerhasilScreen({super.key, required this.total, this.isCash = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Berhasil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            // Status Berhasil Card
            Card(
              color: kSuccessColor.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: kSuccessColor)),
              child: Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, color: kSuccessColor, size: 90),
                    const SizedBox(height: 10),
                    const Text('Pesanan Selesai!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kSuccessColor)),
                    Text(
                      isCash ? 'Silakan lanjutkan ke kasir untuk menyelesaikan transaksi tunai.' : 'Pembayaran berhasil dikonfirmasi.', 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54)
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Detail Pembayaran Ringkas
            _buildDetailSection('Rincian Pembayaran', [
              _buildDetailRow('Metode', isCash ? 'Cash/Tunai' : 'QRIS'),
              _buildDetailRow('Waktu Transaksi', '12:15 WIB'),
              _buildDetailRow('Total Dibayar', formatCurrency(total), isBold: true, fontSize: 16),
            ]),
            
            const SizedBox(height: 50),

            // Tombol Aksi
            OutlinedButton(
              onPressed: () {
                // Ke Bukti Pembayaran (Frame 6)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuktiPembayaranScreen(total: total, isCash: isCash)),
                );
              }, 
              style: OutlinedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                side: const BorderSide(color: kPrimaryColor, width: 2),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Lihat Bukti Pembayaran', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Kembali ke Frame 1
                Navigator.popUntil(context, (route) => route.isFirst); 
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColor,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Text('Kembali ke Menu Awal', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const Divider(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isBold = false, double fontSize = 14, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isBold ? kPrimaryColor : Colors.black)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: isAccent ? kAccentColor : Colors.black)),
        ],
      ),
    );
  }
}


// =========================================================================
// FRAME 6: BUKTI PEMBAYARAN (Struk)
// =========================================================================

class BuktiPembayaranScreen extends StatelessWidget {
  final int total;
  final bool isCash;
  const BuktiPembayaranScreen({super.key, required this.total, this.isCash = false});

  @override
  Widget build(BuildContext context) {
    // Simulasi total yang dibayar dan kembalian hanya untuk Cash
    final int paidAmount = isCash ? 300000 : total;
    final int change = isCash ? paidAmount - total : 0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pembayaran'),
      ),
      body: Center(
        child: SingleChildScrollView( 
          child: Container(
            margin: const EdgeInsets.all(kPadding),
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Struk
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant, color: kPrimaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text('Restoran Fantasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  ],
                ),
                const Center(child: Text('Jl. Padang Bulan Km9, Sumatera Utara', style: TextStyle(fontSize: 12, color: Colors.grey))),
                const Divider(height: 30, thickness: 2, color: Colors.black),

                // Detail Transaksi
                _buildStrukRow('Tanggal', '11 Des 2025 | 12:15 WIB'),
                _buildStrukRow('Nomor Struk', 'S-202512110045'),
                _buildStrukRow('Nama Kasir', 'Cecanb'),
                _buildStrukRow('Metode', isCash ? 'Tunai' : 'QRIS'),
                const Divider(height: 20),

                // Status Lunas
                Center(
                  child: Text(isCash ? '## MENUNGGU KONFIRMASI KASIR ##' : '## LUNAS ##', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isCash ? kAccentColor : kSuccessColor)),
                ),
                
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Detail Pembelian', style: TextStyle(color: kPrimaryColor)),
                  ),
                ),
                const Divider(height: 20),

                // Rincian Pembayaran
                _buildStrukRow('Total Tagihan', formatCurrency(total), isBold: true),
                const Divider(height: 20, thickness: 1.5, color: Colors.black),
                
                if (isCash) ...[
                  _buildStrukRow('Bayar', formatCurrency(paidAmount), isLarge: true),
                  _buildStrukRow('Kembali', formatCurrency(change), isLarge: true, isAccent: true),
                  const Divider(height: 20),
                ],

                // Tombol Cetak
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Kembali ke Frame 1
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }, 
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text('Cetak Struk / Selesai', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrukRow(String label, String value, {bool isBold = false, bool isLarge = false, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isLarge ? 18 : 14, fontWeight: isBold || isLarge ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isLarge ? 18 : 14, fontWeight: isBold || isLarge ? FontWeight.bold : FontWeight.normal, color: isAccent ? kAccentColor : Colors.black)),
        ],
      ),
    );
  }
}