import 'dart:io';
import 'package:android_fe/config/config.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _images = [];
  bool _isNotValidate = false;

  void _submitButton() async {
    if (_titleController.text.isEmpty ||
        _placeController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(testReport),
    );

    // Menambahkan field teks
    request.fields['title'] = _titleController.text;
    request.fields['place'] = _placeController.text;
    request.fields['date'] = _dateController.text;
    request.fields['description'] = _descriptionController.text;

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);
        print('Success: $jsonResponse');
      } else {
        print('Error: ${response.statusCode}');
        // Tampilkan pesan kesalahan
      }
    } catch (e) {
      print('Exception: $e');
      // Tampilkan pesan kesalahan
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(File image) {
    setState(() {
      _images.remove(image);
    });
  }

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
              tileMode: TileMode.mirror,
            ),
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
                  // Tombol untuk mengambil gambar
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Ambil Gambar"),
                  ),
                  // Menampilkan semua gambar yang diambil
                  if (_images.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      // Menggunakan Wrap untuk menampilkan gambar dalam grid
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(_images.length, (index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                _removeImage(_images[index]);
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitButton,
                    child: const Text("Kirim"),
                  ),
                  const SizedBox(height: 20),
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
        controller: _dateController,
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
              _dateController.text = formattedDate;
            });
          }
        },
      ).p4().px24(),
    );
  }
}
