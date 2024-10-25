import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _titleForm = TextEditingController();
  TextEditingController _placeForm = TextEditingController();
  TextEditingController _dateForm = TextEditingController();
  TextEditingController _descriptionForm = TextEditingController();

  bool _isNotValidate = false;

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
                // Judul
                TextField(
                  controller: _titleForm,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.library_books),
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Masukkan Judul" : null,
                      hintText: 'Judul Kegiatan',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px24(),
                // Place
                TextField(
                  controller: _placeForm,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Masukkan Lokasi" : null,
                      hintText: 'Lokasi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px24(),
                // tanggal
                TextField(
                  controller: _dateForm,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Pilih tanggal" : null,
                      hintText: "Pilih tanggal",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        _dateForm.text = formattedDate;
                      });
                    } else {}
                  },
                ).p4().p24(),
                // Description
                TextField(
                  controller: _descriptionForm,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Masukkan Deskripsi" : null,
                      hintText: 'Deskripsi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px24(),
                // Kamera
              ],
            ),
          ),
        ),
      )),
    );
  }
}
