import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama Maroon
  static const Color primary = Color(0xFF420B08); 
  
  // Warna Cream/Background
  static const Color accent = Color(0xFFF4E6DD);
  
  // Status Meja
  static const Color empty = Colors.transparent; // Kosong (Hanya Border)
  static const Color occupied = Color(0xFF420B08); // Terisi (Maroon Penuh)
  static const Color reserved = Color(0xFFEBC128); // Dipesan (Kuning Emas)
  
  // Text Colors
  static const Color textLight = Color(0xFFF4E6DD);
  static const Color textDark = Color(0xFF420B08);
}