import 'package:android_fe/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isNotValidate = false;
  List<File> _images = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isNotValidate => _isNotValidate;
  List<File> get images => _images;
  String? get errorMessage => _errorMessage;

  void addImage(File image) {
    if (_images.length < AppConfig.maxImages) {
      _images.add(image);
      notifyListeners();
    }
  }

  void removeImage(File image) {
    _images.remove(image);
    notifyListeners();
  }

  void setValidationError(bool value) {
    _isNotValidate = value;
    notifyListeners();
  }

  Future<bool> submitReport({
    required String title,
    required String place,
    required String date,
    required String description,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (!await _checkInternetConnection()) {
        throw Exception('No internet connection');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(addReport),
      );

      request.fields['title'] = title;
      request.fields['place'] = place;
      request.fields['date'] = date;
      request.fields['description'] = description;

      for (var image in _images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          image.path,
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        clearImages();
        return true;
      } else {
        var jsonResponse = json.decode(responseData.body);
        throw Exception(jsonResponse['message'] ?? 'Failed to submit report');
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
