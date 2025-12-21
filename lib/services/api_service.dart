import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Pastikan IP Address ini sesuai dengan laptop kamu (ipconfig)
  // Jangan pakai localhost jika dijalankan di Emulator HP/HP Fisik, gunakan IP LAN (contoh: 192.168.1.X)
  static const String baseUrl = "http://localhost/restomanagement/php"; 

  // 1. Login Existing
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {'username': username, 'password': password},
      );
      return json.decode(response.body); 
    } catch (e) {
      return {"status": "error", "message": "Koneksi ke server gagal: $e"};
    }
  }

  // 2. Update User (BARU DITAMBAHKAN)
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

  // 3. Get Tables
  Future<List<dynamic>> getTables() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_tables.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 4. Get Menu
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

  // 5. Reservasi
  Future<Map<String, dynamic>> sendReservation(
      String name, String date, String tableNo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservasi.php"),
        body: {
          'name': name,
          'date': date,
          'table_no': tableNo,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal reservasi: $e"};
    }
  }

  // 6. Simpan Order
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
      return {"status": "error", "message": "Gagal memproses pembayaran"};
    }
  }

  // 7. Get Analisis
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