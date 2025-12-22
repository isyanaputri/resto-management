# RESTORA Management System

**RESTORA** adalah aplikasi manajemen restoran modern berbasis Flutter yang dirancang untuk mengoptimalkan operasional harian. Aplikasi ini mengintegrasikan pemetaan meja real-time (Heatmap), sistem reservasi digital, pemesanan menu otomatis, hingga analisis pendapatan mendalam untuk pemilik restoran.

---

## 1. Nama Aplikasi
**RESTORA Management System (Restora)**

## 2. Tim Pengembang (Kelompok 8)
* **Parida Lubis** (241712006)
* **Isyana Putri Mayza** (241712020)
* **Ivana Kristina Siagian** (241712021)
* **Adeptri Sagala** (241712024)
* **Adriel Gerald Tobing** (241712029)

---

## 3. Deskripsi Singkat
Restora memberikan solusi digital terintegrasi untuk menjembatani operasional staf lapangan dan kebutuhan manajerial owner. Staf dapat memantau status meja secara visual dan memproses transaksi dengan cepat, sementara Owner dapat memantau performa finansial secara real-time melalui dashboard analitik.

---

## 4. Daftar Fitur Utama
* **Splash Screen**: Tampilan awal estetik dengan branding Restora.
* **Multi-Role Authentication**: Hak akses berbeda untuk **Owner** (Analisis) dan **Staff** (Operasional).
* **Manajemen Akun**: Fitur edit profil (Username & Password) dengan verifikasi kredensial lama.
* **Heatmap Meja Real-time**: Visualisasi status meja menggunakan indikator warna yang sinkron dengan database:
    * **Transparan**: Kosong/Tersedia.
    * **Maroon**: Terisi (Active Order).
    * **Kuning Emas**: Dipesan (Reservasi).
* **Sistem Reservasi**: Pencatatan data tamu, jadwal berkunjung, dan pemilihan meja otomatis.
* **Digital Menu & Ordering**: Pemilihan menu berdasarkan kategori dengan kalkulasi total harga real-time.
* **Kasir Multi-Metode**: Mendukung pembayaran melalui **Cash** (dengan hitung kembalian), **QRIS**, **Debit**, dan **Credit Card**.
* **Digital Receipt (Struk)**: Penampilan struk belanja otomatis setelah transaksi berhasil disimpan.
* **Dashboard Analisis**: Grafik/ringkasan pendapatan, pengeluaran, keuntungan, serta daftar menu terlaris.

---

## 5. Stack Technology
### **Frontend**
* **Framework**: Flutter 3.x (Material 3)
* **Language**: Dart
* **Libraries**: `http` (API Communication), `intl` (Currency & Date Formatting), `setState/Provider` (State Management).

### **Backend & Database**
* **Server**: XAMPP (Apache)
* **Language**: PHP (REST API)
* **Database**: MySQL / MariaDB
* **API Connection**: Private Local API (Localhost/10.0.2.2)

---

## 6. Cara Menjalankan Aplikasi
### **Persiapan Database**
1.  Impor file `db_restora.sql` ke phpMyAdmin.
2.  Pastikan tabel `users`, `tables`, `menu`, `reservations`, `orders`, dan `order_items` sudah tersedia.

### **Konfigurasi Backend**
1.  Letakkan folder `php` di dalam direktori `htdocs/restomanagement/`.
2.  Sesuaikan kredensial database pada file `config.php`.

### **Konfigurasi Flutter**
1.  Buka file `lib/services/api_service.dart`.
2.  Sesuaikan `baseUrl` dengan:
    * `http://localhost/...` jika menggunakan **Chrome**.
    * `http://10.0.2.2/...` jika menggunakan **Emulator Android**.
    * `http://[IP_LAPTOP]/...` jika menggunakan **HP Fisik**.

### **Running**
1.  Jalankan perintah `flutter run` atau tekan **F5** di VS Code.

---

## 7. Panduan Penggunaan (User Guide)

### **A. Untuk Staf Operasional**
1.  **Login**: Masuk dengan akun staf.
2.  **Manajemen Meja**: Pantau warna meja pada heatmap. Gunakan tombol **Refresh** untuk sinkronisasi data terbaru.
3.  **Reservasi**: Klik ikon **Kalender**, isi data pelanggan dan pilih meja kosong. Status meja akan otomatis berubah menjadi Kuning.
4.  **Pemesanan**: Klik meja **Kosong**, pilih menu, dan tentukan kuantitas. Klik **Konfirmasi Pesanan**; status meja akan berubah menjadi Maroon (Terisi).
5.  **Pembayaran**: Klik meja **Terisi**, pilih **Proses Pembayaran**. Pilih metode (Cash/QRIS/Debit/Credit). Jika Cash, masukkan nominal uang untuk melihat kembalian. Tekan **Selesaikan** untuk mencetak struk digital.

### **B. Untuk Owner (Pemilik)**
1.  **Dashboard**: Lihat ringkasan pendapatan harian dan keuntungan bersih.
2.  **Analisis Menu**: Pantau menu mana yang paling populer berdasarkan jumlah penjualan.
3.  **Monitor Meja**: Pantau tingkat keramaian restoran secara visual melalui Heatmap.
