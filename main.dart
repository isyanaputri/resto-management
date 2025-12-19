import 'package:flutter/material.dart';

void main() {
  runApp(const MenuApp());
}

// --- Data Model ---

class MenuItem {
  final String name;
  final String description; // Deskripsi singkat untuk kartu menu
  final String imagePath; // Path lokal ke assets/
  final String fullDescription; // Deskripsi lengkap untuk layar detail
  final double price;
  final double rating; // <--- PROPERTI BARU: Rating

  MenuItem(
    this.name,
    this.description,
    this.imagePath,
    this.fullDescription,
    this.price,
    this.rating, // <--- Diperbarui
  );
}

class MenuSection {
  final String title;
  final List<MenuItem> items;

  MenuSection(this.title, this.items);
}

// Data Dummy: Ditambahkan rating di akhir setiap item
final List<MenuSection> menuData = [
  MenuSection('Makanan Utama', [
    MenuItem(
      'Beef Steak',
      'Potongan daging sapi impor premium.',
      'assets/beefsteak.png',
      'Daging sapi impor yang dipanggang sempurna sesuai tingkat kematangan pilihan Anda. Disajikan dengan saus spesial lada hitam atau jamur, kentang tumbuk, dan sayuran panggang. Pilihan sempurna untuk pecinta daging.',
      160000.00,
      4.8, // <--- RATING
    ),
    MenuItem(
      'Chicken Steak',
      'Steak ayam dengan saus jamur klasik.',
      'assets/chickensteak.png',
      'Daging ayam fillet panggang yang lembut dan juicy, disajikan dengan saus jamur creamy, kentang goreng, dan sayuran segar. Pilihan lebih ringan namun tetap mengenyangkan.',
      95000.00,
      4.5, // <--- RATING
    ),
    MenuItem(
      'Pizza Deluxe',
      'Roti pizza renyah dengan topping premium.',
      'assets/pizza.png',
      'Roti tipis khas Italia dengan topping keju mozzarella, pepperoni, jamur, paprika, dan bawang bombay. Dipanggang dengan oven kayu hingga renyah.',
      85000.00,
      4.6, // <--- RATING
    ),
    MenuItem(
      'Spaghetti Carbonara',
      'Pasta klasik dengan saus krim keju dan telur.',
      'assets/sphagetti.png',
      'Spaghetti Al dente yang disajikan dengan saus krim yang kaya, keju Parmesan, dan potongan daging sapi asap. Sebuah hidangan pasta Italia yang otentik.',
      65000.00,
      4.3, // <--- RATING
    ),
  ]),
  MenuSection('Minuman', [
    MenuItem(
      'Mojito Series',
      'Minuman segar rasa mint dan jeruk nipis.',
      'assets/mojitoseries.png',
      'Berbagai varian Mojito yang menyegarkan (seperti Strawberry, Lychee, atau Classic Lime). Perpaduan daun mint, jeruk nipis, dan soda dingin.',
      35000.00,
      4.7, // <--- RATING
    ),
    MenuItem(
      'Americano',
      'Kopi hitam murni yang kuat.',
      'assets/americano.png',
      'Espresso yang diencerkan dengan air panas. Tersedia panas atau dingin. Ideal untuk Anda yang menyukai rasa kopi murni.',
      30000.00,
      4.2, // <--- RATING
    ),
    MenuItem(
      'Lychee Tea',
      'Teh dengan rasa leci yang manis dan harum.',
      'assets/lycheetea.png',
      'Teh hitam yang disajikan dingin dengan ekstrak leci, dilengkapi dengan buah leci utuh. Manis dan sangat menyegarkan.',
      25000.00,
      4.5, // <--- RATING
    ),
    MenuItem(
      'Milkshake Chocolate',
      'Susu kocok cokelat kental dan dingin.',
      'assets/milkshakechocolate.png',
      'Minuman penutup yang lembut dan kental. Es krim cokelat premium diblender dengan susu segar dan disajikan dengan *whipped cream*.',
      40000.00,
      4.8, // <--- RATING
    ),
  ]),
  MenuSection('Makanan Penutup', [
    MenuItem(
      'Strawberry Cheesecake',
      'Kue keju lembut dengan irisan stroberi segar.',
      'assets/cheescakestrawberry.png',
      'Cheesecake klasik dengan dasar biskuit, lapisan keju krim lembut, dan topping selai serta irisan stroberi segar. Pilihan manis yang sempurna.',
      40000.00,
      4.9, // <--- RATING
    ),
    MenuItem(
      'Pudding Strawberry',
      'Puding lembut dengan saus stroberi.',
      'assets/puddingstrawberry.png',
      'Puding susu vanila yang lembut, disajikan dengan saus stroberi buatan sendiri. Hidangan penutup ringan dan dingin.',
      35000.00,
      4.4, // <--- RATING
    ),
    MenuItem(
      'Parfait Buah',
      'Lapisan yogurt, granola, dan buah-buahan.',
      'assets/parfaitbuah.png',
      'Makanan penutup sehat yang terdiri dari lapisan yogurt dingin, granola renyah, dan berbagai buah segar musiman (kiwi, mangga, stroberi).',
      38000.00,
      4.6, // <--- RATING
    ),
    MenuItem(
      'Ice Cream Matcha',
      'Es krim rasa teh hijau Jepang.',
      'assets/icecreammatcha.png',
      'Es krim yang kaya dengan rasa teh hijau Matcha Jepang yang khas. Memberikan rasa manis dan sedikit pahit yang unik.',
      32000.00,
      4.1, // <--- RATING
    ),
  ]),
];

// --- Konstanta Warna ---
const Color kBackgroundColor = Color(0xFFF4E6DD); // Background tetap
const Color kPrimaryColor = Color(
  0xFF420B08,
); // PRIMARY BARU: Sama dengan Card Color
const Color kCardColor = Color(0xFF420B08); // Card color baru

// ===========================================
//             WIDGET LAYAR DETAIL
// ===========================================

class MenuDetailScreen extends StatefulWidget {
  final MenuItem item;

  const MenuDetailScreen({super.key, required this.item});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  // BARIS 204: UBAH NILAI AWAL DARI 1 MENJADI 0
  int _quantity = 0;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      // BARIS 216: UBAH LOGIKA MENJADI HANYA MENGURANGI JIKA > 0
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  // Helper untuk format harga
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    // BARU: Tentukan apakah tombol order/minus dinonaktifkan
    final bool isOrderDisabled = _quantity == 0;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBackgroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Area Gambar - MENGGUNAKAN ASSET LOKAL
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 40),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    // Panggilan Gambar Asset
                    image: AssetImage(widget.item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Konten Detail (Bagian Bawah yang Melengkung)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        _formatPrice(
                          widget.item.price,
                        ), // Tampilkan harga di detail
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF420B08), // Warna harga yang menonjol
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating Bintang
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        widget.item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    widget.item.fullDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Bagian Quantity dan Tombol Order
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kontrol Kuantitas
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            // Tombol Minus
                            _buildQuantityButton(
                              Icons.remove,
                              // Jika kuantitas 0, set onPressed menjadi null
                              isOrderDisabled ? null : _decrementQuantity,
                              // BARU: Menambahkan Opacity untuk visual disabled
                              opacity: isOrderDisabled ? 0.5 : 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            // Tombol Plus
                            _buildQuantityButton(Icons.add, _incrementQuantity),
                          ],
                        ),
                      ),

                      // Tombol Order
                      ElevatedButton(
                        // BARU: Nonaktifkan tombol jika isOrderDisabled adalah true
                        onPressed: isOrderDisabled
                            ? null
                            : () {
                                // Aksi order di sini
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Memesan $_quantity ${widget.item.name} (Total: ${_formatPrice(_quantity * widget.item.price)})',
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          // BARU: Mengatur warna saat dinonaktifkan
                          disabledBackgroundColor: kPrimaryColor.withOpacity(
                            0.5,
                          ),
                        ),
                        child: Text(
                          'Order',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            // BARU: Mengatur warna teks saat dinonaktifkan
                            color: isOrderDisabled
                                ? kBackgroundColor.withOpacity(0.5)
                                : kBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BARIS 404: MENGUBAH FUNGSI UNTUK MENDUKUNG OPACITY
  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback? onPressed, {
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity, // Menggunakan opacity yang diberikan (default 1.0)
      child: InkWell(
        onTap: onPressed, // onTap bisa null (dinonaktifkan)
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kBackgroundColor, size: 20),
        ),
      ),
    );
  }
}

// ===========================================
//             WIDGET LAYAR DAFTAR
// ===========================================

class MenuSectionHeader extends StatelessWidget {
  final String title;

  const MenuSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: kBackgroundColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isLeftAligned;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.isLeftAligned,
  });

  // Helper untuk format harga
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;

    final itemImage = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          // Panggilan Gambar Asset
          image: AssetImage(item.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    final itemDetails = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                color: kBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.description,
              style: const TextStyle(
                // Warna teks deskripsi diubah agar kontras dengan card color yang gelap
                color: Color(0xFFF9E8D4), // Warna kuning/putih pucat
                fontSize: 12,
              ),
              maxLines: 1, // Dibuat 1 baris agar ada ruang untuk detail
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            // --- BARU: Harga dan Rating ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: kBackgroundColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Harga
                Text(
                  _formatPrice(item.price),
                  style: const TextStyle(
                    color: Color(0xFF420B08), // Warna merah untuk harga
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // --- END BARU ---
          ],
        ),
      ),
    );

    final cardContent = Row(
      children: isLeftAligned
          ? [itemImage, const SizedBox(width: 10), itemDetails]
          : [itemDetails, const SizedBox(width: 10), itemImage],
    );

    return InkWell(
      onTap: () {
        // Navigasi ke layar detail menu saat diklik
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetailScreen(item: item)),
        );
      },
      child: Container(
        width: cardWidth,
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: kCardColor, // Menggunakan warna kCardColor murni (0xFF420B08)
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: cardContent,
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildTopHeader(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 30.0, left: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50.0),
            topLeft: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0),
          ),
        ),
        child: const Icon(
          Icons.restaurant_menu,
          size: 40,
          color: kBackgroundColor,
        ),
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0, right: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: const Icon(Icons.local_bar, size: 40, color: kBackgroundColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Konten Menu (Scrollable)
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuData.map((section) {
                final header = MenuSectionHeader(title: section.title);

                final itemsGrid = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(section.items.length, (index) {
                      final item = section.items[index];
                      final isLeftAligned = index % 2 == 0;
                      return MenuItemCard(
                        item: item,
                        isLeftAligned: isLeftAligned,
                      );
                    }),
                  ),
                );

                return Column(
                  children: [header, itemsGrid, const SizedBox(height: 20)],
                );
              }).toList(),
            ),
          ),

          // 2. Header (Garpu & Pisau)
          _buildTopHeader(context),

          // 3. Footer (Gelas Minuman)
          Positioned(bottom: 0, right: 0, child: _buildBottomFooter(context)),
        ],
      ),
    );
  }
}

// ===========================================
//             APLIKASI UTAMA
// ===========================================

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Restaurant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
