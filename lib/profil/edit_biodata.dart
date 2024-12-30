import 'dart:io';
import 'package:android_fe/profil/crud/dai_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({Key? key}) : super(key: key);

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _pendidikanAkhirController = TextEditingController();
  final TextEditingController _statusKawinController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final daiProvider = Provider.of<DaiProvider>(context, listen: false);
      await daiProvider.fetchDaiProfile();
    });
  }

  void _updateControllers(dai) {
    _namaController.text = dai.nama;
    _noHpController.text = dai.noHp;
    _alamatController.text = dai.alamat;
    _tempatLahirController.text = dai.tempatLahir;
    _tanggalLahirController.text = dai.tanggalLahir;
    _pendidikanAkhirController.text = dai.pendidikanAkhir;
    _statusKawinController.text = dai.statusKawin;
  }

  bool _isUploadingImage = false;
  Future<void> _pickImage() async {
    setState(() => _isUploadingImage = true);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _simpanSubmit() async {
    if (_formKey.currentState!.validate()) {
      final daiProvider = Provider.of<DaiProvider>(context, listen: false);

      bool success = await daiProvider.updateDaiProfile(
        nama: _namaController.text,
        noHp: _noHpController.text,
        alamat: _alamatController.text,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        pendidikanAkhir: _pendidikanAkhirController.text,
        statusKawin: _statusKawinController.text,
        fotoDai: _selectedImage,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Consumer<DaiProvider>(
        builder: (context, daiProvider, child) {
          if (daiProvider.isLoading == 'Unauthenticated') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Session Expired. Please Login Again'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text('Go to Login'),
                  )
                ],
              ),
            );
          }
          if (daiProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final dai = daiProvider.daiProfile;
          if (dai != null) {
            _updateControllers(dai);
          }

          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
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
              child: Form(
                key: _formKey,
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
                                : (dai?.fotoDai != null
                                    ? Image.network(
                                        dai!.fotoDai!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, StackTrace) {
                                          return Image.asset('images/polbeng.png', fit: BoxFit.cover);
                                        },
                                      )
                                    : Image.asset('images/polbeng.png')),
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
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _namaController,
                      icon: Icons.person,
                      hint: 'Nama',
                      validator: (value) => value == null || value.isEmpty ? "Nama tidak boleh kosong" : null,
                    ),
                    _buildTextField(
                      controller: _noHpController,
                      icon: Icons.phone,
                      hint: 'No Hp',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "No HP tidak boleh kosong";
                        if (!RegExp(r'^\d{10,13}$').hasMatch(value)) return "Format No HP tidak valid";
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _tempatLahirController,
                      icon: Icons.location_city_rounded,
                      hint: 'Tempat Lahir',
                      validator: (value) => value == null || value.isEmpty ? "Tempat Lahir tidak boleh kosong" : null,
                    ),
                    _buildDateField(),
                    _buildTextField(
                      controller: _alamatController,
                      icon: Icons.location_on,
                      hint: 'Alamat',
                      validator: (value) => value == null || value.isEmpty ? "Alamat tidak boleh kosong" : null,
                    ),
                    _buildTextField(
                      controller: _pendidikanAkhirController,
                      icon: Icons.school,
                      hint: 'Pendidikan Akhir',
                      validator: (value) =>
                          value == null || value.isEmpty ? "Pendidikan Akhir tidak boleh kosong" : null,
                    ),
                    _buildTextField(
                      controller: _statusKawinController,
                      icon: Icons.person,
                      hint: 'Status Kawin',
                      validator: (value) => value == null || value.isEmpty ? "Status Kawin tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _simpanSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? Function(String?)? validator,
    int? maxLines = 1,
    TextInputType? keyboardType,
    readOnly,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ).p4().px24(),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: _tanggalLahirController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          hintText: "Tanggal Lahir",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        readOnly: true,
        validator: (value) => value == null || value.isEmpty ? "Tanggal Lahir tidak boleh kosong" : null,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
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

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _pendidikanAkhirController.dispose();
    _statusKawinController.dispose();
    super.dispose();
  }
}
