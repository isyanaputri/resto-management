import 'package:flutter/material.dart';
import '../configurasi/warna.dart'; // Menggunakan warna dari file source 
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
  bool _obscurePassword = true;

  // Controller untuk Dialog Update Akun
  final TextEditingController _oldUserCtrl = TextEditingController();
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newUserCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();

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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const DashboardAnalisis()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MejaScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message'] ?? "Gagal"),
            backgroundColor: Colors.red),
      );
    }
  }

  // Fungsi Baru: Menampilkan Dialog Ubah Akun
  void _showChangeAccountDialog() {
    // Reset form
    _oldUserCtrl.clear();
    _oldPassCtrl.clear();
    _newUserCtrl.clear();
    _newPassCtrl.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.accent,
          title: const Text("Ubah Data Login",
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Masukkan data lama untuk verifikasi, lalu data baru.",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 15),
                _buildInput(
                    controller: _oldUserCtrl,
                    label: "Username Lama",
                    icon: Icons.person_outline),
                const SizedBox(height: 10),
                _buildInput(
                    controller: _oldPassCtrl,
                    label: "Password Lama",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: true), // Password lama selalu hidden
                const Divider(color: AppColors.primary, height: 30),
                _buildInput(
                    controller: _newUserCtrl,
                    label: "Username BARU",
                    icon: Icons.person),
                const SizedBox(height: 10),
                _buildInput(
                    controller: _newPassCtrl,
                    label: "Password BARU",
                    icon: Icons.lock,
                    isPassword: true,
                    obscureText: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog dulu
                _processUpdateAccount();
              },
              child: const Text("SIMPAN PERUBAHAN",
                  style: TextStyle(color: AppColors.accent)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi Baru: Proses API Update Akun
  void _processUpdateAccount() async {
    if (_oldUserCtrl.text.isEmpty ||
        _oldPassCtrl.text.isEmpty ||
        _newUserCtrl.text.isEmpty ||
        _newPassCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Semua data wajib diisi!"),
          backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    final res = await ApiService().updateUser(
      _oldUserCtrl.text,
      _oldPassCtrl.text,
      _newUserCtrl.text,
      _newPassCtrl.text,
    );
    setState(() => _isLoading = false);

    if (res['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['message']), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res['message']), backgroundColor: Colors.red));
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
              const Icon(Icons.restaurant_menu,
                  size: 80, color: AppColors.primary),
              const SizedBox(height: 10),
              const Text(
                "RESTORA LOGIN",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 40),

              // Input Username
              _buildInput(
                controller: _userCtrl,
                label: "Username",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),

              // Input Password
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.accent)
                      : const Text("MASUK",
                          style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Ganti Data Login (Fitur Baru)
              TextButton.icon(
                onPressed: _showChangeAccountDialog,
                icon: const Icon(Icons.settings,
                    color: AppColors.primary, size: 18),
                label: const Text("Ubah Username / Password",
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              )
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