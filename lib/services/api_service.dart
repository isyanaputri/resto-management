import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Gunakan localhost jika dijalankan di Chrome
  // Jika pakai Emulator Android, ganti dengan IP Laptop (misal: 10.0.2.2)
  static const String baseUrl = "http://localhost/restomanagement/php";//cite: 82]

  // 1. Fitur Login (Owner & Staff)
  Future<Map<String, dynamic>> login(String username, String password) async {//cite: 83]
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {'username': username, 'password': password},
      ); //[cite: 83]
      return json.decode(response.body);// [cite: 84]
    } catch (e) {
      return {"status": "error", "message": "Koneksi ke server gagal: $e"}; //[cite: 85]
    }
  }

  // 2. Ambil Data Meja (Real-time Status)
  Future<List<dynamic>> getTables() async {// [cite: 85]
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_tables.php")); //[cite: 85]
      if (response.statusCode == 200) {// [cite: 86]
        return json.decode(response.body);// [cite: 86]
      }
      return [];// [cite: 87]
    } catch (e) {
      return [];// [cite: 88]
    }
  }

  // 3. Ambil Data Menu (12 Item dari Database)
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

  // 4. Kirim Data Reservasi & Update Status Meja
  Future<Map<String, dynamic>> sendReservation(
      String name, String date, String tableNo) async {// [cite: 88]
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservasi.php"),
        body: {
          'name': name,
          'date': date,
          'table_no': tableNo,// [cite: 89]
        },
      );// [cite: 89]
      return json.decode(response.body);// [cite: 90]
    } catch (e) {
      return {"status": "error", "message": "Gagal reservasi: $e"};// [cite: 91]
    }
  }

  // 5. Simpan Order & Proses Pembayaran (Cash/Barcode)
  Future<Map<String, dynamic>> saveOrder(
      String tableNo, double total, String method, List items) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/simpan_order.php"),
        body: {
          'table_no': tableNo,
          'total': total.toString(),
          'method': method,
          'items': jsonEncode(items), // Mengirim detail item yang dipesan
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Gagal memproses pembayaran"};
    }
  }

  // 6. Ambil Data Analisis (Khusus Boss)
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