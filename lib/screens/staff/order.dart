import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu Order',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF333333),
        primarySwatch: Colors.brown,
      ),
      home: const MenuOrderScreen(),
    );
  }
}

// ======================= MODEL =======================
class MenuItem {
  final String name;
  final String image;
  final double price;
  int qty;

  MenuItem({
    required this.name,
    required this.image,
    required this.price,
    this.qty = 0,
  });
}

// ======================= SCREEN =======================
class MenuOrderScreen extends StatefulWidget {
  const MenuOrderScreen({super.key});

  @override
  State<MenuOrderScreen> createState() => _MenuOrderScreenState();
}

class _MenuOrderScreenState extends State<MenuOrderScreen> {
  final List<MenuItem> menuItems = [
    MenuItem(name: 'Americano', image: 'assets/americano.png', price: 25000),
    MenuItem(name: 'Beef Steak', image: 'assets/beef steak.png', price: 75000),
    MenuItem(
      name: 'Cheesecake',
      image: 'assets/cheesecake strawberry.png',
      price: 30000,
    ),
    MenuItem(
      name: 'Chicken Steak',
      image: 'assets/chicken steak.png',
      price: 65000,
    ),
    MenuItem(
      name: 'Ice Cream Matcha',
      image: 'assets/ice cream matcha.png',
      price: 20000,
    ),
    MenuItem(name: 'Lychee Tea', image: 'assets/lychee tea.png', price: 18000),
    MenuItem(
      name: 'Milkshake Chocolate',
      image: 'assets/milkshake chocolate.png',
      price: 28000,
    ),
    MenuItem(
      name: 'Mojito Series',
      image: 'assets/mojito series.png',
      price: 22000,
    ),
    MenuItem(
      name: 'Parfait Buah',
      image: 'assets/parfait buah.png',
      price: 26000,
    ),
    MenuItem(name: 'Pizza', image: 'assets/pizza.png', price: 200000),
    MenuItem(
      name: 'Pudding Strawberry',
      image: 'assets/pudding strawberry.png',
      price: 24000,
    ),
    MenuItem(name: 'Spaghetti', image: 'assets/spaghetti.png', price: 50000),
  ];

  String rupiah(double value) => 'Rp${value.toStringAsFixed(0)}';

  double get total =>
      menuItems.fold(0, (sum, item) => sum + item.price * item.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Order'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ================= GRID MENU =================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: menuItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85, // CARD LEBIH PENDEK
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF4EF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      // ================= GAMBAR FIX =================
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        child: SizedBox(
                          height: 110, // <<<<<< KUNCI UTAMA
                          width: double.infinity,
                          child: Image.asset(
                            item.image,
                            fit: BoxFit.contain, // AMAN
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(rupiah(item.price)),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: item.qty > 0
                                ? () => setState(() => item.qty--)
                                : null,
                          ),
                          Text(item.qty.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => setState(() => item.qty++),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ================= TOTAL =================
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFBF4EF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  rupiah(total),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
