import 'package:flutter/material.dart';
import 'package:android_fe/model/report_model.dart';

class DetailReportPage extends StatelessWidget {
  final Reports report;

  const DetailReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              report.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Lokasi: ${report.place}'),
            Text('Tanggal: ${report.date}'),
            const SizedBox(height: 16),
            Text('Deskripsi: ${report.description}'),
            const SizedBox(height: 16),
            Text('Validasi Desa: ${report.validasiDesa}'),
            Text('Koreksi Desa: ${report.koreksiDesa}'),
            Text('Validasi Kecamatan: ${report.validasiKecamatan}'),
            Text('Koreksi Kecamatan: ${report.koreksiKecamatan}'),
            const SizedBox(height: 16),
            const Text(
              'Gambar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            report.images.isEmpty
                ? const Text('Tidak ada gambar.')
                : Column(
                    children: report.images.map((image) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.network(image),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
