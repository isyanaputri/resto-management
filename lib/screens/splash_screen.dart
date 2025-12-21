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
  
      backgroundColor: AppColors.primary, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
   
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child: Image.asset(
                'assets/images/logo.png', 
                width: 120,
     
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