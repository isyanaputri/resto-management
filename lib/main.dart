import 'package:flutter/material.dart';
import 'configurasi/warna.dart';
import 'screens/splash_screen.dart';

void main() {
  // Menjalankan aplikasi Restora
  runApp(const RestoraApp());// [cite: 92]
}

class RestoraApp extends StatelessWidget {
  const RestoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,// [cite: 93]
      title: 'Restora Management System',// [cite: 93]
      
      // Mengatur tema global aplikasi sesuai permintaan (Maroon & Cream)
      theme: ThemeData(
        useMaterial3: true,// [cite: 93]
        // Warna background default untuk semua halaman
        scaffoldBackgroundColor: AppColors.accent, 
        
        // Mengatur font default agar terlihat lebih profesional
        fontFamily: 'Poppins', 
        
        // Tema AppBar global
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(color: AppColors.accent),
          titleTextStyle: TextStyle(
            color: AppColors.accent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Halaman pertama yang akan dijalankan adalah SplashScreen
      home: const SplashScreen(), //[cite: 93]
    );
  }
}