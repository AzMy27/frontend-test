import 'dart:convert';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
        }),
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: 'Reset Password'.text.make(),
            content: (responseData['message'] ?? 'Tautan reset password telah dikirim ke email Anda.').text.make(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke halaman login
                },
                child: 'OK'.text.make(),
              ),
            ],
          ),
        );
      } else {
        // Tampilkan pesan error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: 'Error'.text.make(),
            content: (responseData['message'] ?? 'Terjadi kesalahan').text.make(),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: 'OK'.text.make(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: 'Error'.text.make(),
          content: 'Terjadi kesalahan koneksi'.text.make(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: 'OK'.text.make(),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Lupa Password'.text.make(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: context.screenWidth,
              height: context.screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.all(16),
              child: VStack(
                [
                  'Masukkan email Anda untuk mereset password'.text.xl.make().pOnly(bottom: 16),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ).pOnly(bottom: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : 'Reset Password'.text.make(),
                  ),
                ],
                alignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.stretch,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
