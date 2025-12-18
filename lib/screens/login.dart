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
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _isLoading = false;
  
  // Variabel untuk mengontrol tampilan password
  bool _obscurePassword = true; 

  void _doLogin() async {
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua data!")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService().login(_userCtrl.text, _passCtrl.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      String role = result['role'];
      if (role == 'owner') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAnalisis()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MejaScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Gagal"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Icon(Icons.restaurant_menu, size: 80, color: AppColors.primary),
              const SizedBox(height: 10),
              const Text(
                "RESTORA LOGIN",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 40),
              
              // Input Username
              _buildInput(
                controller: _userCtrl,
                label: "Username",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              
              // Input Password dengan tombol mata
              _buildInput(
                controller: _passCtrl,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggle: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 30),
              
              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.accent)
                    : const Text("MASUK", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primary),
        prefixIcon: Icon(icon, color: AppColors.primary),
        // Menambahkan ikon mata di sebelah kanan jika ini input password
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: onToggle,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}