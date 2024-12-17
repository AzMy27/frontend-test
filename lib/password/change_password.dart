import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

        if (token == null) {
          _showErrorDialog('Anda harus login terlebih dahulu');
          return;
        }

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

        // print('Response: ${response.data}');

        if (response.statusCode == 200) {
          _showSuccessDialog();
        }
      } on DioException catch (e) {
        // print('DioError: ${e.toString()}');
        String errorMessage = 'Gagal mengubah password';

        if (e.response != null) {
          // print('Error Response: ${e.response?.data}');
          switch (e.response?.statusCode) {
            case 400:
              errorMessage = e.response?.data['message'] ?? 'Password saat ini salah';
              break;
            case 401:
              errorMessage = 'Unauthorized. Silakan login kembali.';
              break;
            case 422:
              errorMessage = 'Validasi gagal. Periksa kembali password Anda.';
              break;
            default:
              errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
          }
        } else {
          errorMessage = e.message ?? 'Koneksi bermasalah';
        }

        _showErrorDialog(errorMessage);
      } catch (e) {
        // print('Unexpected Error: ${e.toString()}');
        _showErrorDialog('Terjadi kesalahan yang tidak terduga');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<String?> _getStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Berhasil', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Password berhasil diubah'),
        actions: [
          TextButton(
            onPressed: () {
              // Ensure we pop both the dialog and the current screen
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the change password screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kesalahan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
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
