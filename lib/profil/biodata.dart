import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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

  List<File> _fotoDai = [];
  bool _isNotValidate = false;
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
        centerTitle: true, // Untuk menempatkan title di tengah
      ),
      body: SingleChildScrollView(
        child: Container(
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
                      child: Image.asset('images/polbeng.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.yellow,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined, // Properti icon seharusnya di sini
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Anda dapat menambahkan elemen lain di bawah sini\
              Form(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nikController,
                      icon: Icons.credit_card_off,
                      hint: 'NIK',
                      errorText: _isNotValidate ? "Masukkan NIK" : null,
                      readOnly: true,
                    ),
                    _buildTextField(
                      controller: _namaController,
                      icon: Icons.person,
                      hint: 'Nama',
                      errorText: _isNotValidate ? "Masukkan Nama" : null,
                    ),
                    _buildTextField(
                      controller: _namaController,
                      icon: Icons.person,
                      hint: 'Nama',
                      errorText: _isNotValidate ? "Masukkan Nama" : null,
                    ),
                    _buildTextField(
                      controller: _noHpController,
                      icon: Icons.person,
                      hint: 'No Hp',
                      errorText: _isNotValidate ? "Masukkan No. Hp" : null,
                    ),
                    _buildTextField(
                      controller: _tempatLahirController,
                      icon: Icons.person,
                      hint: 'Tempat Lahir',
                      errorText: _isNotValidate ? "Masukkan Tempat Lahir" : null,
                    ),
                    _buildDateField(),
                    _buildTextField(
                      controller: _alamatController,
                      icon: Icons.person,
                      hint: 'Alamat',
                      errorText: _isNotValidate ? "Masukkan Alamat" : null,
                    ),
                    _buildTextField(
                      controller: _pendidikanAkhirController,
                      icon: Icons.person,
                      hint: 'Pendidikan Akhir',
                      errorText: _isNotValidate ? "Masukkan Pendidikan Akhir" : null,
                    ),
                    _buildTextField(
                      controller: _statusKawinController,
                      icon: Icons.person,
                      hint: 'Status Kawin',
                      errorText: _isNotValidate ? "Masukkan Status Kawin" : null,
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
    bool readOnly = false,
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
          border: OutlineInputBorder(
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
          border: OutlineInputBorder(
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
