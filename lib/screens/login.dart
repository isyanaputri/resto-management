import 'package:flutter/material.dart';
import '../configurasi/warna.dart';
import '../services/api_service.dart';
import 'owner/dashboard.dart';
import 'staff/meja.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController(); // [cite: 66]
  final TextEditingController _passCtrl = TextEditingController(); // [cite: 66]
  bool _isLoading = false;

  void _doLogin() async {
    // Validasi input tidak boleh kosong [cite: 66]
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password wajib diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Memanggil API Login [cite: 67, 83]
    final result = await ApiService().login(_userCtrl.text, _passCtrl.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') { // [cite: 68]
      String role = result['role']; // [cite: 68]
      
      // Navigasi Berdasarkan Role 
      if (role == 'owner') {
        // Bos bisa akses dashboard analisis [cite: 69]
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const DashboardAnalisis())
        );
      } else if (role == 'staff') {
        // Staff diarahkan ke manajemen meja [cite: 70]
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MejaScreen())
        );
      }
    } else {
      // Tampilkan error jika login gagal [cite: 71, 72]
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Login Gagal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent, // Latar belakang Cream
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant, size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                "RESTORA LOGIN",
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.primary
                ),
              ),
              const SizedBox(height: 40),
              
              // Input Username
              TextField(
                controller: _userCtrl,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: AppColors.primary),
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Input Password
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: AppColors.primary),
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Warna Maroon
                    foregroundColor: AppColors.accent, // Teks Cream
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.accent)
                    : const Text("MASUK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}