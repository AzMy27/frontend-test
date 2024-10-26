import 'package:android_fe/page/Profile_page.dart';
import 'package:android_fe/page/home_page.dart';
import 'package:flutter/material.dart';

class RoutersPage extends StatefulWidget {
  const RoutersPage({super.key});

  @override
  State<RoutersPage> createState() => _RoutersPageState();
}

class _RoutersPageState extends State<RoutersPage> {
  final _routers = [
    const HomePage(),
    const ProfilePage(),
  ];
  int _selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        fixedColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
      ),
      body: _routers.elementAt(_selectIndex),
    );
  }
}
