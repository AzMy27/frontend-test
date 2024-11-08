import 'package:android_fe/auth/login_page.dart';
import 'package:android_fe/profil/about.dart';
import 'package:android_fe/profil/biodata.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('images/polbeng.png'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nama Pengguna',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Email Pengguna',
                style: TextStyle(
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
                onPressed: () {},
              ),
              ProfileMenuWidget(
                title: 'Account',
                icon: Icons.account_circle,
                onPressed: () {},
              ),
              ProfileMenuWidget(
                title: 'Help',
                icon: Icons.help,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ProfileMenuWidget(
                title: 'Logout',
                icon: Icons.logout,
                textColor: Colors.red, // Set the text color
                onPressed: () {
                  // Add your logout logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? textColor; // Specify the type as Color
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
          color: textColor ?? Colors.black, // Apply textColor here
        ),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.arrow_right,
          size: 28.0,
          color: Colors.grey,
        ),
      ),
      onTap: onPressed,
    );
  }
}
