import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  
  // PENTING:
  // Gunakan '10.0.2.2' jika menggunakan Emulator Android Studio.
  // Gunakan IP Address Laptop (contoh: '192.168.1.X') jika menggunakan HP Fisik.
  // Jangan pakai 'localhost' kecuali di Web Browser.
  static const String baseUrl = "http://localhost/restomanagement/php"; 

  // ===========================================================================
  // 1. AUTHENTICATION (LOGIN & UPDATE USER)
  // ===========================================================================

  // Login User
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {'username': username, 'password': password},
      );
      // Decode response dari server
      return json.decode(response.body); 
    } catch (e) {
      return {"status": "error", "message": "Koneksi ke server gagal: $e"};
    }
  }

  // Update Username & Password (Fitur Baru Tahap 1)
  Future<Map<String, dynamic>> updateUser(
      String oldUser, String oldPass, String newUser, String newPass) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_user.php"),
        body: {
          'old_username': oldUser,
          'old_password': oldPass,
          'new_username': newUser,
          'new_password': newPass,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal update data: $e"};
    }
  }

  // ===========================================================================
  // 2. TABLE MANAGEMENT (MEJA)
  // ===========================================================================

  // Mengambil Data Semua Meja
  Future<List<dynamic>> getTables() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_tables.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      // Kembalikan list kosong jika error agar aplikasi tidak crash
      return [];
    }
  }

  // Membatalkan/Mengosongkan Meja (Fitur Baru Tahap 2)
  Future<Map<String, dynamic>> cancelTable(String tableNo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/cancel_table.php"),
        body: {'table_no': tableNo},
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal membatalkan status meja: $e"};
    }
  }

  // ===========================================================================
  // 3. MENU & RESERVATION
  // ===========================================================================

  // Mengambil Daftar Menu Makanan/Minuman
  Future<List<dynamic>> getMenu() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_menu.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Mengirim Data Reservasi (Diupdate Tahap 3: Tambah phone, people, notes)
  Future<Map<String, dynamic>> sendReservation(
      String name, String phone, String date, String people, String tableNo, String notes) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservasi.php"),
        body: {
          'name': name,
          'phone': phone,
          'date': date,
          'people': people,
          'table_no': tableNo,
          'notes': notes,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal melakukan reservasi: $e"};
    }
  }

  // ===========================================================================
  // 4. ORDER & TRANSACTION PROCESSING
  // ===========================================================================

  // FUNGSI BARU (Tahap 4): Input Pesanan Awal (Ubah status meja jadi Terisi & Catat Menu)
  // Digunakan saat tombol "KONFIRMASI PESANAN" ditekan di OrderScreen
  Future<Map<String, dynamic>> inputOrder(
      String tableNo, double total, List items) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/input_order.php"),
        body: {
          'table_no': tableNo,
          'total': total.toString(),
          'items': jsonEncode(items), // Kirim list menu sebagai JSON
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal input order: $e"};
    }
  }

  // Simpan Transaksi Akhir / Pembayaran (Akan digunakan di Tahap 5)
  // Digunakan saat tombol "SELESAIKAN PEMBAYARAN" ditekan di PaymentScreen
  Future<Map<String, dynamic>> saveOrder(
      String tableNo, double total, String method, List items) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/simpan_order.php"),
        body: {
          'table_no': tableNo,
          'total': total.toString(),
          'method': method,
          'items': jsonEncode(items), 
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal memproses pembayaran: $e"};
    }
  }

  // ===========================================================================
  // 5. ANALYSIS (DASHBOARD OWNER)
  // ===========================================================================

  // Ambil Data Analisis Penjualan
  Future<Map<String, dynamic>> getAnalysisData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_analisis.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {"status": "error"};
    } catch (e) {
      return {"status": "error"};
    }
  }
}