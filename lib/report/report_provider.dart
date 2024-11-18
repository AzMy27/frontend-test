import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_fe/config/routing/ApiRoutes.dart';

class ReportProvider extends ChangeNotifier {
  List<File> _images = [];
  bool _isLoading = false;
  bool _hasValidationError = false;

  List<File> get images => _images;
  bool get isLoading => _isLoading;
  bool get hasValidationError => _hasValidationError;

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

  void setValidationError(bool value) {
    _hasValidationError = value;
    notifyListeners();
  }

  Future<bool> submitReport({
    required String title,
    required String place,
    required String date,
    required String description,
    required List<File> images,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.addReport),
      );

      // Add text fields
      request.fields['title'] = title;
      request.fields['place'] = place;
      request.fields['date'] = date;
      request.fields['description'] = description;

      // Add images
      for (var i = 0; i < images.length; i++) {
        var pic = await http.MultipartFile.fromPath(
          'images[]', // Make sure this matches your backend expectation
          images[i].path,
        );
        request.files.add(pic);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var jsonData = json.decode(responseString);

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('Error: ${jsonData['message']}');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
