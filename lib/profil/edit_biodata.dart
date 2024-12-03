// import 'dart:convert';
import 'dart:io';
// import 'package:android_fe/auth/login_page.dart';
// import 'package:android_fe/config/routing/ApiRoutes.dart';
// import 'package:android_fe/model/dai_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _pendidikanAkhirController = TextEditingController();
  final TextEditingController _statusKawinController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final bool _isNotValidate = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _ShowDai(int id) async {
    // Code show dai here...
  }

  Future<void> _simpanSubmit() async {
    //Code update here...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFD3D3D3)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('images/polbeng.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.yellow,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Rest of your existing code...
              const Text(
                'NIK DAI',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _namaController,
                      icon: Icons.person,
                      hint: 'Nama',
                      errorText: _isNotValidate ? "Masukkan Nama" : null,
                    ),
                    _buildTextField(
                      controller: _noHpController,
                      icon: Icons.phone,
                      hint: 'No Hp',
                      errorText: _isNotValidate ? "Masukkan No. Hp" : null,
                    ),
                    _buildTextField(
                      controller: _tempatLahirController,
                      icon: Icons.location_city_rounded,
                      hint: 'Tempat Lahir',
                      errorText: _isNotValidate ? "Masukkan Tempat Lahir" : null,
                    ),
                    _buildDateField(),
                    _buildTextField(
                      controller: _alamatController,
                      icon: Icons.location_on,
                      hint: 'Alamat',
                      errorText: _isNotValidate ? "Masukkan Alamat" : null,
                    ),
                    _buildTextField(
                      controller: _pendidikanAkhirController,
                      icon: Icons.school,
                      hint: 'Pendidikan Akhir',
                      errorText: _isNotValidate ? "Masukkan Pendidikan Akhir" : null,
                    ),
                    _buildTextField(
                      controller: _statusKawinController,
                      icon: Icons.person,
                      hint: 'Status Kawin',
                      errorText: _isNotValidate ? "Masukkan Status Kawin" : null,
                    ),
                    ElevatedButton(
                      onPressed: _simpanSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? errorText,
    IconData? icon,
    int? maxLines,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(color: Colors.red),
          errorText: errorText,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        maxLines: maxLines,
      ).p4().px24(),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: _tanggalLahirController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(color: Colors.red),
          errorText: _isNotValidate ? "Pilih tanggal" : null,
          hintText: "Pilih tanggal",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              _tanggalLahirController.text = formattedDate;
            });
          }
        },
      ).p4().px24(),
    );
  }
}
