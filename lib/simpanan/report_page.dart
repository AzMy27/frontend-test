// import 'dart:io';

// import 'package:android_fe/controller/images_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _dateController = TextEditingController();
//   bool _isNotValidate = false;

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ImagesController());
//     return SafeArea(
//       child: Scaffold(
//         body: GetBuilder<ImagesController>(
//           builder: (imagesController) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: [const Color(0XFFF95A3B), Color(0xFFF96713)],
//                     begin: FractionalOffset.topLeft,
//                     end: FractionalOffset.bottomCenter,
//                     stops: [0.0, 0.8],
//                     tileMode: TileMode.mirror),
//               ),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       // Judul
//                       TextField(
//                         controller: _titleController,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             errorStyle: TextStyle(color: Colors.white),
//                             errorText: _isNotValidate ? "Masukkan Judul" : null,
//                             hintText: 'Judul',
//                             border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
//                       ).p4().px24(),
//                       // tanggal
//                       TextField(
//                         controller: _dateController,
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.calendar_today),
//                             filled: true,
//                             fillColor: Colors.white,
//                             errorStyle: TextStyle(color: Colors.white),
//                             errorText: _isNotValidate ? "Pilih tanggal" : null,
//                             hintText: "Pilih tanggal",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
//                         readOnly: true,
//                         onTap: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(2024),
//                             lastDate: DateTime(2100),
//                           );
//                           if (pickedDate != null) {
//                             print(pickedDate);
//                             String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//                             print(formattedDate);
//                             setState(() {
//                               _dateController.text = formattedDate;
//                             });
//                           } else {}
//                         },
//                       ).p4().p24(),
//                       // Kamera
//                       GestureDetector(
//                         child: const Text('Pilih Gambar'),
//                         onTap: () => imagesController.pickedImage(),
//                       ),
//                       const SizedBox(height: 15.0),
//                       Container(
//                         alignment: Alignment.center,
//                         width: double.infinity,
//                         height: 200,
//                         color: Colors.grey[300],
//                         child: imagesController.pickedFile != null
//                             ? Image.file(
//                                 File(imagesController.pickedFile!.path),
//                                 height: 200,
//                                 width: 200,
//                                 fit: BoxFit.cover,
//                               )
//                             : const Text('Pilih salah satu gambar'),
//                       ),
//                       const SizedBox(height: 25),
//                       Center(
//                         child: GestureDetector(
//                           child: const Text('Server upload'),
//                           onTap: () => Get.find<ImagesController>().upload(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
