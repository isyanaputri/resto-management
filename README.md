# Restora - Manajemen Restoran 

Restora adalah aplikasi mobile manajemen restoran yang dirancang untuk memudahkan proses pemesanan, reservasi, pembayaran, serta pengelolaan meja dalam satu sistem terintegrasi. Aplikasi ini mendukung pengalaman pelanggan melalui menu digital sekaligus membantu pihak restoran dalam menganalisis performa bisnis secara real-time.

## Struktur Kelompok (Kelompok 8)
- **Parida Lubis** (241712006)
- **Isyana Putri Mayza** (241712020)
- **Ivana Kristina Siagian** (241712021)
- **Adeptri Sagala** (241712024)
- **Adriel Gerald Tobing** (241712029)

## Fitur Utama
- **Digital Menu**: Kategori menu, detail menu, manajemen stok, dan fitur add to order.
- **Reservation**: Reservasi meja dengan pemilihan tanggal, jam, dan jumlah orang.
- **Order Management**: Manajemen keranjang pesanan untuk layanan dine-in maupun takeaway.
- **Payment System**: Integrasi pembayaran melalui QRIS, e-wallet, kartu, dan cash.
- **Table Management**: Monitoring status meja (Kosong, Terisi, Reserved, Cleaning).
- **Dashboard & Analysis**: Laporan penjualan, menu terlaris, jam ramai, dan statistik pembayaran.

## Stack Technology yang Digunakan

### Dependensi
Project ini menggunakan library dan plugin berikut sesuai dengan hasil `flutter --version`:

- **Flutter Version**: 3.35.3
- **Dart Version**: 3.9.2
- **DevTools**: 2.48.0
- **Android SDK**: Minimum SDK 21 (Android 5.0 Lollipop)

### Library Utama
- **Flutter SDK**: Framework UI utama.
- **Material Design**: Basis desain antarmuka.
- **HTTP / Dio**: Komunikasi data dengan API (PHP Backend).
- **sqflite**: Database lokal untuk operasional offline.
- **Provider / Riverpod**: Manajemen state aplikasi.
- **Chart Library**: Visualisasi data untuk dashboard analisis.

## Cara Mengimpor ke Android Studio / VS Code
1. Buka Android Studio atau VS Code.
2. Pilih **"Open an Existing Project"**.
3. Arahkan ke folder proyek **Restora**.
4. Buka terminal di dalam proyek dan jalankan perintah:
   ```bash
   flutter pub get
