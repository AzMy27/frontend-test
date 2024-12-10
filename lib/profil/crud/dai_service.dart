import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/model/dai_model.dart';

class DaiService {
  Future<Dai> fetchDaiDetails(String token) async {
    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.showDai),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] == null) {
          throw Exception('Detail DAI tidak ditemukan.');
        }
        return Dai.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau kadaluarsa');
      } else {
        throw Exception('Gagal menampilkan detail DAI: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail DAI: $e');
    }
  }
}
