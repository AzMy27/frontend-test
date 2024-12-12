import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/model/dai_model.dart';

class DaiProvider extends ChangeNotifier {
  Dai? _daiProfile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  bool _isTokenLoad = false;

  // Getters
  Dai? get daiProfile => _daiProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DaiProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isTokenLoad = true;
    notifyListeners();
  }

  Future<void> fetchDaiProfile() async {
    if (!_isTokenLoad) {
      await _loadToken();
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token == null) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('token');
      }

      final response = await http.get(
        Uri.parse(ApiConstants.showDai),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          _daiProfile = Dai.fromJson(responseData['data']);
        } else {
          throw Exception('No profile data found');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load Dai profile');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _daiProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateDaiProfile({
    required String nama,
    required String noHp,
    required String alamat,
    required String tempatLahir,
    required String tanggalLahir,
    required String pendidikanAkhir,
    required String statusKawin,
    File? fotoDai,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token == null) {
        throw Exception('Authentication token not found');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.updateDai}'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      });

      // Only include fields that can be updated
      request.fields.addAll({
        'nama': nama,
        'no_hp': noHp,
        'alamat': alamat,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'pendidikan_akhir': pendidikanAkhir,
        'status_kawin': statusKawin,
      });

      if (fotoDai != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_dai',
            fotoDai.path,
            filename: 'profile_image.jpg',
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['data'] != null) {
          _daiProfile = Dai.fromJson(responseData['data']);
          final prefs = await SharedPreferences.getInstance();
          if (_daiProfile?.fotoDai != null) {
            await prefs.setString('foto_dai', _daiProfile!.fotoDai!);
          }
        }
        return true;
      } else {
        throw Exception(responseData['message'] ?? 'Update failed');
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
