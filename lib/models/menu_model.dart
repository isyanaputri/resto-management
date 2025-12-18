import 'dart:convert';

class MenuModel {
  final String id;
  final String nama;
  final String deskripsi;
  final double harga;
  final String kategori;
  final String gambar;
  int qty; // Digunakan secara lokal untuk menghitung pesanan di keranjang

  MenuModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.kategori,
    this.gambar = 'default.png',
    this.qty = 0,
  });

  // Fungsi untuk mengubah data JSON dari PHP/Database menjadi Object Dart
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      // Memastikan harga dikonversi ke double meskipun dari database berupa string
      harga: double.tryParse(json['harga'].toString()) ?? 0.0,
      kategori: json['kategori'] ?? 'makanan',
      gambar: json['gambar'] ?? 'default.png',
    );
  }

  // Fungsi untuk mengirim data kembali ke server jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'qty': qty,
      'subtotal': harga * qty,
    };
  }
}