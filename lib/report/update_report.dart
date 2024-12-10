import 'dart:io';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/model/report_model.dart';
import 'package:android_fe/report/crud/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class UpdateReport extends StatefulWidget {
  final Reports? report;

  const UpdateReport({super.key, this.report});

  @override
  State<UpdateReport> createState() => _UpdateReportState();
}

class _UpdateReportState extends State<UpdateReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coordinateController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      _titleController.text = widget.report!.title;
      _placeController.text = widget.report!.place;
      _dateController.text = widget.report!.date;
      _descriptionController.text = widget.report!.description;
      _coordinateController.text = widget.report!.coordinatePoint ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _coordinateController.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<XFile?> _compressImage(File imageFile) async {
    final dir = await Directory.systemTemp;
    final targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    return await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: AppConfig.imageQuality,
      minWidth: AppConfig.maxImageWidth,
      minHeight: AppConfig.maxImageHeight,
    );
  }

  Future<void> _updateReport() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ReportProvider>();

      final success = await provider.updateReport(
        reportId: widget.report!.id!,
        title: _titleController.text,
        type: _typeController.text,
        place: _placeController.text,
        date: _dateController.text,
        description: _descriptionController.text,
        images: provider.images,
        coordinatePoint: _coordinateController.text,
        target: _targetController.text,
        purpose: _purposeController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil diperbarui')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui laporan: ${provider.errorMessage}')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Layanan lokasi tidak aktif')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _coordinateController.text = '${position.latitude}, ${position.longitude}';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perbaiki Laporan'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFfbfcff)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Text(
                    'Perbaiki Laporan Kegiatan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 35),
                  _buildTextField(
                    controller: _titleController,
                    icon: Icons.library_books,
                    hint: 'Judul Kegiatan',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _placeController,
                    icon: Icons.location_on,
                    hint: 'Lokasi',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _coordinateController,
                    icon: Icons.map,
                    hint: 'Titik Koordinat',
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Titik koordinat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  _buildDateField(),
                  _buildTextField(
                    controller: _descriptionController,
                    hint: 'Deskripsi',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  Consumer<ReportProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          if (provider.images.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: provider.images.map((image) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 20),
                          provider.isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _updateReport,
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text("Kirim"),
                                ),
                        ],
                      );
                    },
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
    IconData? icon,
    int? maxLines,
    String? Function(String?)? validator,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        maxLines: maxLines ?? 1,
        validator: validator,
        readOnly: readOnly,
        textCapitalization: textCapitalization,
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          hintText: "Pilih tanggal",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tanggal tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
