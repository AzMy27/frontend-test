import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Dio _dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? token = await _getStoredToken();

        final response = await _dio.post(
          ApiConstants.changePassword,
          data: {
            'current_password': _currentPasswordController.text,
            'new_password': _newPasswordController.text,
            'new_password_confirmation': _confirmPasswordController.text,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          _showSuccessDialog();
        }
      } on DioException catch (e) {
        String errorMessage = 'Gagal mengubah password';

        if (e.response != null) {
          if (e.response?.statusCode == 400) {
            errorMessage = e.response?.data['message'] ?? 'Password saat ini salah';
          } else if (e.response?.statusCode == 422) {
            errorMessage = 'Validasi gagal. Periksa kembali password Anda.';
          }
        }

        _showErrorDialog(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _getStoredToken() async {
    return null; // Implement token retrieval logic
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: 'Berhasil'.text.bold.make(),
        content: 'Password berhasil diubah'.text.make(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: 'OK'.text.make(),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: 'Kesalahan'.text.bold.red500.make(),
        content: message.text.make(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: 'OK'.text.make(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Ganti Password'.text.make(),
      ),
      body: VStack([
        Form(
          key: _formKey,
          child: VStack([
            'Password Saat Ini'.text.bold.make().pOnly(bottom: 5),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: !_isCurrentPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Masukkan password saat ini',
                suffixIcon: IconButton(
                  icon: Icon(_isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Masukkan password saat ini';
                return null;
              },
            ).pOnly(bottom: 16),

            'Password Baru'.text.bold.make().pOnly(bottom: 5),
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Masukkan password baru',
                suffixIcon: IconButton(
                  icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Masukkan password baru';
                if (value.length < 8) return 'Password minimal 8 karakter';
                return null;
              },
            ).pOnly(bottom: 16),

            'Konfirmasi Password Baru'.text.bold.make().pOnly(bottom: 5),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Konfirmasi password baru',
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Konfirmasi password baru';
                if (value != _newPasswordController.text) return 'Password tidak cocok';
                return null;
              },
            ).pOnly(bottom: 24),

            // Change Password Button
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading ? const CircularProgressIndicator() : 'Ganti Password'.text.white.bold.make(),
            ).wFull(context),
          ]),
        ).scrollVertical().p16(),
      ]),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
