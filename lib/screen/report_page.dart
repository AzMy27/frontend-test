import 'dart:io';
import 'package:android_fe/config/routing/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      Uri.parse(addReport),
      // Uri.parse('http://192.168.9.116:8000/api/reports'),
    );

    // Menambahkan field teks
    request.fields['title'] = _titleController.text;
    request.fields['place'] = _placeController.text;
    request.fields['date'] = _dateController.text;
    request.fields['description'] = _descriptionController.text;

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'images[]',
        image.path,
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);
        print('Success: $jsonResponse');

        _titleController.clear();
        _placeController.clear();
        _dateController.clear();
        _descriptionController.clear();
        setState(() {
          _images.clear();
          _isNotValidate = false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final newFile = await _compressImage(File(pickedFile.path));
      if (newFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<XFile?> _compressImage(File imageFile) async {
    final dir = await Directory.systemTemp;

    final targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 60,
    );
    return result;
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
        appBar: AppBar(
          title: const Text('Laporan'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFFFFFF), const Color(0xFFD3D3D3)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50), // Tambahkan jarak atas jika diperlukan
                const Text(
                  'Laporan Kegiatan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Buat jarak yang konsisten
                SizedBox(height: 35),
                // Konten lainnya
                _buildTextField(
                  controller: _titleController,
                  icon: Icons.library_books,
                  hint: 'Judul Kegiatan',
                  errorText: _isNotValidate ? "Masukkan Judul" : null,
                ),
                _buildTextField(
                  controller: _placeController,
                  icon: Icons.location_on,
                  hint: 'Lokasi',
                  errorText: _isNotValidate ? "Masukkan Lokasi" : null,
                ),
                _buildDateField(),
                _buildTextField(
                  controller: _descriptionController,
                  icon: null,
                  hint: 'Deskripsi',
                  maxLines: 5,
                  errorText: _isNotValidate ? "Masukkan Deskripsi" : null,
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Ambil Gambar"),
                ),
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Wrap(
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
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
