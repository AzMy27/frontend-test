import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _titleController = TextEditingController(),
      _placeController = TextEditingController(),
      _dateController = TextEditingController(),
      _descriptionController = TextEditingController();

  bool _isNotValidate = false;

  void _submitButton() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0XFFF95A3B), Color(0xFFF96713)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0, 0.8],
                tileMode: TileMode.mirror),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Laporan Kegiatan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Judul
                  _buildTextField(
                    controller: _titleController,
                    icon: Icons.library_books,
                    hint: 'Judul Kegiatan',
                    errorText: _isNotValidate ? "Masukkan Judul" : null,
                  ),
                  // Lokasi
                  _buildTextField(
                    controller: _placeController,
                    icon: Icons.location_on,
                    hint: 'Lokasi',
                    errorText: _isNotValidate ? "Masukkan Lokasi" : null,
                  ),
                  // Tanggal
                  _buildDateField(),
                  // Deskripsi
                  _buildTextField(
                    controller: _descriptionController,
                    icon: null,
                    hint: 'Deskripsi',
                    maxLines: 5,
                    errorText: _isNotValidate ? "Masukkan Deskripsi" : null,
                  ),
                  // Camera
                  _cameraPicker(),
                ],
              ),
            ),
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
      margin: EdgeInsets.symmetric(vertical: 4), // Menyesuaikan jarak antar TextField
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(color: Colors.red), // Ubah agar terlihat
          errorText: errorText,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        maxLines: maxLines,
      ).p4().px24(), // Padding dan margin
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4), // Menyesuaikan jarak antar TextField
      child: TextField(
        controller: _dateController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(color: Colors.red),
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
              _dateController.text = formattedDate;
            });
          }
        },
      ).p4().px24(),
    );
  }

  Widget _cameraPicker() {
    return Container();
  }
}
