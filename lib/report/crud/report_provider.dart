import 'dart:io';
import 'package:android_fe/model/report_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportProvider extends ChangeNotifier {
  List<File> _images = [];
  bool _isLoading = false;
  bool _hasValidationError = false;
  String? _token;
  String? _errorMessage;
  List<Reports> _reports = [];
  List<Reports> get reports => _reports;

  List<File> get images => _images;
  bool get isLoading => _isLoading;
  bool get hasValidationError => _hasValidationError;
  String? get errorMessage => _errorMessage;

  ReportProvider() {
    _myToken();
  }

  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> getAllReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Token not found');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.getReport),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['data'];
        _reports = data.map((json) => Reports.fromJson(json)).toList();
        notifyListeners();
      } else {
        print('Failed to load reports: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _myToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  void addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(File image) {
    _images.remove(image);
    notifyListeners();
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  void setValidationError(bool value, [String? message]) {
    _hasValidationError = value;
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> submitReport({
    required String title,
    required String type,
    required String place,
    required String date,
    required String description,
    required List<File> images,
    required String coordinatePoint,
    required String target,
    required String purpose,
  }) async {
    // 1. Cek koneksi internet terlebih dahulu
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        setValidationError(true, 'Tidak ada koneksi internet');
        return false;
      }
    } catch (_) {
      setValidationError(true, 'Tidak ada koneksi internet');
      return false;
    }

    // 2. Refresh token
    await refreshToken();
    if (_token == null) {
      setValidationError(true, 'Silakan login kembali');
      return false;
    }

    // 3. Validasi images
    if (images.isEmpty) {
      setValidationError(true, 'Mohon tambahkan minimal satu gambar');
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.addReport),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      });

      request.fields.addAll({
        'title': title,
        'type': type,
        'place': place,
        'date': date,
        'description': description,
        'coordinate_point': coordinatePoint,
        'target': target,
        'purpose': purpose,
      });

      for (var i = 0; i < images.length; i++) {
        try {
          final file = await http.MultipartFile.fromPath(
            'images[]',
            images[i].path,
            filename: 'image_$i.jpg',
          );
          request.files.add(file);
        } catch (e) {
          throw Exception('Gagal memproses gambar ${i + 1}: ${e.toString()}');
        }
      }

      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Waktu request habis'),
          );

      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      // 4. Penanganan response yang lebih detail
      if (response.statusCode == 201) {
        clearImages();
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir, silakan login kembali');
      } else {
        throw Exception(responseData['message'] ?? 'Terjadi kesalahan pada server');
      }
    } catch (e) {
      setValidationError(true, e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateReport({
    required int reportId,
    required String title,
    required String type,
    required String place,
    required String date,
    required String description,
    required List<File> images,
    required String coordinatePoint,
    required String target,
    required String purpose,
  }) async {
    if (_token == null) {
      setValidationError(true, 'Authentication token not found');
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.updateReport}/$reportId'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      });

      request.fields.addAll({
        'title': title,
        'type': type,
        'place': place,
        'date': date,
        'description': description,
        'coordinate_point': coordinatePoint,
        'target': target,
        'purpose': purpose,
      });

      for (var i = 0; i < images.length; i++) {
        final file = await http.MultipartFile.fromPath(
          'images[]',
          images[i].path,
          filename: 'image_$i.jpg',
        );
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        clearImages();
        return true;
      } else {
        throw Exception(responseData['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      setValidationError(true, e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
