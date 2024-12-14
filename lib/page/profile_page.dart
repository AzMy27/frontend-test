import 'dart:convert';

import 'package:android_fe/auth/login_page.dart';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/profil/about.dart';
import 'package:android_fe/profil/crud/dai_provider.dart';
import 'package:android_fe/profil/edit_biodata.dart';
import 'package:android_fe/profil/settings.dart';
import 'package:android_fe/widget/image_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Pengguna';
  String _email = '';
  String _profilImage = 'images/polbeng.png';

  @override
  void initState() {
    super.initState();
    _validateToken();
    _loadUserProfile();
  }

  Future<void> _validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _redirectToLogin();
    }
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final daiProvider = Provider.of<DaiProvider>(context, listen: false);

    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
      _email = prefs.getString('email') ?? 'Email tidak ditemukan';
      String? fotoDai = daiProvider.daiProfile?.fotoDai ?? prefs.getString('foto_dai');
      if (fotoDai != null && fotoDai.isNotEmpty) {
        _profilImage = fotoDai;
      } else {
        _profilImage = 'images/polbeng.png'; // Default image
      }
    });
  }

  Future<void> _logoutSubmit() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        Navigator.of(context).pop();
        _redirectToLogin();
        return;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.logoutSubmit),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        await prefs.clear();
        Provider.of<DaiProvider>(context, listen: false).clearProviderData();
        _redirectToLogin();
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Logout failed');
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _redirectToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserProfile,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFFFFFF), const Color(0xFFfbfcff)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0, 0.8],
                tileMode: TileMode.mirror,
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _profilImage.startsWith('http')
                        ? ImageWithToken(
                            imageUrl: _profilImage,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/polbeng.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _username, // Tampilkan nama pengguna
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _email, // Tampilkan email pengguna
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BiodataPage(),
                        ),
                      );
                      _loadUserProfile();
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[600],
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                // Menu
                ProfileMenuWidget(
                  title: 'Settings',
                  icon: Icons.settings,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
                ProfileMenuWidget(
                  title: 'Help',
                  icon: Icons.help,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                ProfileMenuWidget(
                  title: 'Akan Datang',
                  icon: Icons.next_plan_outlined,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                Divider(),
                ProfileMenuWidget(
                  title: 'Logout',
                  icon: Icons.logout,
                  textColor: Colors.red,
                  onPressed: () {
                    _logoutSubmit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? textColor;
  final VoidCallback? onPressed;

  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 28.0,
          color: Colors.grey,
        ),
      ),
      onTap: onPressed,
    );
  }
}
