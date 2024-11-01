// import 'dart:io'; // Import untuk File
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart'; // Import image_picker

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   List<File> _images = []; // Variabel untuk menyimpan gambar
//   String userName = "Muhammad Azmi";
//   String userEmail = "azmiABCD@gmail.com";

//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path)); // Menyimpan gambar di list
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Profil'),
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             color: Colors.white, // Mengatur warna background
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   // Container untuk gambar profil
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle, // Bentuk lingkaran
//                       image: DecorationImage(
//                         image: _images.isNotEmpty 
//                           ? FileImage(_images[0]) // Gambar pertama dari list
//                           : NetworkImage('https://via.placeholder.com/100'), // Gambar default
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Nama pengguna
//                   Text(
//                     userName,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   // Email pengguna
//                   Text(
//                     userEmail,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 20), // Jarak vertikal
//                   // Tombol untuk mengedit profil
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Logika untuk edit profile
//                       },
//                       child: const Text('Edit Profile'),
//                     ),
//                   ),
//                   const SizedBox(height: 10), // Jarak antara tombol
//                   // Tombol untuk tentang
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Logika untuk tombol tentang
//                       },
//                       child: const Text('Tentang'),
//                     ),
//                   ),
//                   const SizedBox(height: 10), // Jarak antara tombol
//                   // Tombol untuk aplikasi
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Logika untuk tombol aplikasi
//                       },
//                       child: const Text('Aplikasi'),
//                     ),
//                   ),
//                   const SizedBox(height: 20), // Jarak vertikal
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
