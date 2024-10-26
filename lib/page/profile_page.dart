import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [const Color(0xFFF95A3B), Color(0xFFF96713)],
              //   begin: FractionalOffset.topLeft,
              //   end: FractionalOffset.bottomCenter,
              //   stops: [0.0, 0.8],
              //   tileMode: TileMode.mirror,
              // ),
              ),
        ),
      ),
    );
  }
}
