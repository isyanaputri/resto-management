import 'package:flutter/material.dart';
import 'configurasi/warna.dart';
import 'screens/splash_screen.dart';

void main() {

  runApp(const RestoraApp());
}

class RestoraApp extends StatelessWidget {
  const RestoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  
      debugShowCheckedModeBanner: false,
      title: 'Restora Management System',
      
      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: AppColors.accent, 
        
        fontFamily: 'Poppins', 
        

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
      

      home: const SplashScreen(), 
    );
  }
}