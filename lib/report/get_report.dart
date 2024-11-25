import 'dart:convert';
import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:http/http.dart' as http;
import 'package:android_fe/model/report_model.dart';

class getReports {
  Future<List<Reports>> fetchReports(String token) async {
    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getReport),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validasi apakah `data['data']` adalah daftar
        if (data['data'] == null || data['data'] is! List) {
          throw Exception('Format response tidak valid');
        }

        List<dynamic> reportsJson = data['data'];
        return reportsJson.map((json) => Reports.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau kadaluarsa');
      } else {
        throw Exception('Gagal menampilkan laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data: $e');
    }
  }

  Future<Reports> fetchReportsById(String token, int reportId) async {
    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.showReportId}/$reportId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] == null) {
          throw Exception('Detail Laporan tidak ditemukan.');
        }
        return Reports.fromJson(data['data']);
      } else if (response.statusCode == 400) {
        throw Exception('Token tidak valid');
      } else {
        throw Exception('Gagal menampilkan detail laporan : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menampilkan detail laporan: $e');
    }
  }
}
