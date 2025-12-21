import 'package:flutter/material.dart';
import '../../configurasi/warna.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final String currentName;

  const EditProfileScreen({super.key, required this.userId, required this.currentName});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userCtrl;
  final TextEditingController _passCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userCtrl = TextEditingController(text: widget.currentName);
  }

  void _saveProfile() async {
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi username dan password baru!")));
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService().updateProfile(widget.userId, _userCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil diupdate! Silakan login ulang."), backgroundColor: Colors.green));
      // Kembali ke Login agar data refresh
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(title: const Text("EDIT PROFIL")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Text("Ubah Username / Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            TextField(
              controller: _userCtrl,
              decoration: InputDecoration(
                labelText: "Username Baru",
                prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passCtrl,
              decoration: InputDecoration(
                labelText: "Password Baru",
                prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.accent)
                  : const Text("SIMPAN PERUBAHAN", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}