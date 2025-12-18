import 'dart:async';
import 'package:flutter/material.dart';
import '../configurasi/warna.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Berpindah ke halaman Login setelah 3 detik secara otomatis
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna Maroon sebagai latar belakang utama
      backgroundColor: AppColors.primary, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container untuk Logo agar terlihat lebih rapi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child: Image.asset(
                'assets/images/logo.png', // Pastikan file ini ada di folder assets
                width: 120,
                // Fallback jika gambar logo belum tersedia, menggunakan Icon Restaurant
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.restaurant_menu, 
                    size: 100, 
                    color: AppColors.accent, 
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Nama Aplikasi dengan styling elegan
            const Text(
              "RESTORA",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.accent, 
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Management System",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}