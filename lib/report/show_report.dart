import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:android_fe/model/report_model.dart';

class DetailReportPage extends StatelessWidget {
  final Reports report;

  const DetailReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Detail Laporan'.text.make(),
      ),
      body: VStack([
        'Detail Laporan'.text.xl.bold.make().box.p16.margin(const EdgeInsets.only(bottom: 8)).make(),
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
              ),
            ),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Judul Kegiatan')),
              DataCell(Text(report.title)),
            ]),
            DataRow(cells: [
              const DataCell(Text('Tipe Kegiatan')),
              DataCell(Text(report.type)),
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
              const DataCell(Text('Target')),
              DataCell(Text(report.target)),
            ]),
            DataRow(cells: [
              const DataCell(Text('Tujuan')),
              DataCell(Text(report.purpose)),
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
        ).box.p16.margin(const EdgeInsets.only(bottom: 16)).make(),
        'Gambar'.text.xl.bold.make(),
        const SizedBox(height: 8),
        report.images.isEmpty
            ? 'Tidak ada gambar.'.text.make()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: report.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenGallery(
                              images: report.images,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Image.network(report.images[index]),
                    ),
                  );
                },
              ),
      ]).p16().scrollVertical(),
    );
  }
}

class FullScreenGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
