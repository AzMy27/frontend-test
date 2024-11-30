import 'package:flutter/material.dart';
import 'package:android_fe/model/report_model.dart';

class DetailReportPage extends StatelessWidget {
  final Reports report;

  const DetailReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Laporan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'Kategori',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Detail',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Judul Kegiatan')),
                  DataCell(Text(report.title)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Tanggal')),
                  DataCell(Text(report.date)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Lokasi')),
                  DataCell(Text(report.place)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Titik Koordinat')),
                  DataCell(Text(report.coordinatePoint ?? 'Tidak ada titik koordinat')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Deskripsi')),
                  DataCell(Text(report.description)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Validasi Desa')),
                  DataCell(Text(report.validasiDesa)),
                ]),
                if (report.validasiDesa != 'diterima')
                  DataRow(cells: [
                    const DataCell(Text('Koreksi Desa')),
                    DataCell(Text(report.koreksiDesa)),
                  ]),
                DataRow(cells: [
                  const DataCell(Text('Validasi Kecamatan')),
                  DataCell(Text(report.validasiKecamatan)),
                ]),
                if (report.validasiKecamatan != 'diterima')
                  DataRow(cells: [
                    const DataCell(Text('Koreksi Kecamatan')),
                    DataCell(Text(report.koreksiKecamatan)),
                  ]),
              ],
            ),

            const SizedBox(height: 16),

            // Image Section
            const Text(
              'Gambar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            report.images.isEmpty
                ? const Text('Tidak ada gambar.')
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: report.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.network(report.images[index]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
