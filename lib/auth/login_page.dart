import 'package:android_fe/auth/app_logo.dart';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/page/navbar.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loginButton() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isNotValidate = false;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginSubmit), // Sesuaikan dengan URL API Anda
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Simpan token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('username', responseData['user']['name']);

        if (mounted) {
          // Navigate ke halaman utama
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RoutersPage()),
          );
        }
      } else {
        if (mounted) {
          _showErrorDialog(responseData['message'] ?? 'Login failed');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Network error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0XFFF95A3B),
                const Color(0XFFF96713),
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CommonLogo(),
                  HeightBox(10.0),
                  "Email Sign in".text.size(22).yellow100.make(),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email), // Tambah icon email
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Masukkan Email" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Toggle visibility berdasarkan state
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock), // Tambah icon lock
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Masukkan Password" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  HStack([
                    GestureDetector(
                      onTap: _isLoading ? null : _loginButton,
                      child: VxBox(
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : "Login".text.white.makeCentered().p16(),
                      ).green600.roundedLg.make().px16().py16(),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
