import 'package:android_fe/auth/app_logo.dart';
import 'package:android_fe/auth/forgot_password.dart';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/main.dart';
import 'package:android_fe/page/routers_page.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 8) {
      return 'Password harus diisi dengan 8 huruf';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loginButton() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.loginSubmit),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timeout'),
          );
      final responseData = jsonDecode(response.body);

      if (!mounted) return;
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        await _saveUserData(responseData);
        _navigateToHome();
      } else {
        _showErrorDialog(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorDialog(
        e.toString().contains('timeout')
            ? 'Connection timeout. Please check your internet connection.'
            : 'Tidak ada koneksi internet',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('token', data['token'].toString()),
        prefs.setString('username', data['user']['name'].toString()),
        prefs.setString('email', data['user']['email'].toString()),
        prefs.setString('token_expired', data['expired_at'].toString()),
      ]);

      final savedToken = prefs.getString('token');
      final savedExpiry = prefs.getString('token_expired');

      if (savedToken == null || savedExpiry == null) {
        throw Exception('Failed to save authentication data');
      }
    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save authentication data');
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoutersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFFFFF3E0), Color(0XFFFFECB3)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.2, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CommonLogo().pOnly(bottom: 15),
                    "Login Dai".text.size(22).black.bold.make().pOnly(bottom: 10),
                    _buildEmailField(),
                    _buildPasswordField(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
                    //     );
                    //   },
                    //   child: 'Lupa Password?'.text.size(14).blue500.bold.make().pOnly(top: 5, left: 270),
                    // ),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        enabled: !_isLoading,
        validator: _validateEmail,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Email",
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        enabled: !_isLoading,
        validator: _validatePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Password",
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: _isLoading ? null : () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _loginButton,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(10),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class AuthInterceptor {
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String url) async {
    final headers = await getAuthHeaders();
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 401) {
      // Token expired, redirect to login
      await _handleTokenExpired();
      return http.Response('Token expired', 401);
    }

    return response;
  }

  Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('email');

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
