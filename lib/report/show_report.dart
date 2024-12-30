import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:android_fe/model/report_model.dart';

// Constants
class ReportValidationStatus {
  static const String accepted = 'diterima';
  static const String rejected = 'ditolak';
  static const String pending = 'pending';
}

class DetailReportPage extends StatelessWidget {
  final Reports report;

  const DetailReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Detail Laporan'.text.make(),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share),
        //     onPressed: () => _shareReport(context),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshReport(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: VStack([
            _buildHeader(),
            _buildDataTable(context),
            _buildImageSection(context),
          ]).p16(),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: _getStatusColor(),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          'Detail Laporan'.text.xl.bold.make(),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusText(),
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('Judul Kegiatan', report.title),
            _buildTableRow('Tipe Kegiatan', report.type),
            _buildTableRow('Tanggal', report.date),
            _buildTableRow('Lokasi', report.place),
            _buildTableRow('Titik Koordinat', report.coordinatePoint ?? 'Tidak ada titik koordinat'),
            _buildTableRow('Target', report.target),
            _buildTableRow('Tujuan', report.purpose),
            _buildTableRow('Deskripsi', report.description),
            _buildTableRow('Validasi Desa', report.validasiDesa),
            if (report.validasiDesa != 'diterima') _buildTableRow('Koreksi Desa', report.koreksiDesa),
            _buildTableRow('Validasi Kecamatan', report.validasiKecamatan),
            if (report.validasiKecamatan != 'diterima') _buildTableRow('Koreksi Kecamatan', report.koreksiKecamatan),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow> _buildDataRows() {
    final List<DataRow> rows = [
      _buildDataRow('Judul Kegiatan', report.title),
      _buildDataRow('Tipe Kegiatan', report.type),
      _buildDataRow('Tanggal', report.date),
      _buildDataRow('Lokasi', report.place),
      _buildDataRow('Titik Koordinat', report.coordinatePoint ?? 'Tidak ada titik koordinat'),
      _buildDataRow('Target', report.target),
      _buildDataRow('Tujuan', report.purpose),
      _buildDataRow('Deskripsi', report.description),
      _buildDataRow('Validasi Desa', _getValidationStatusText(report.validasiDesa)),
    ];

    if (report.validasiDesa != ReportValidationStatus.accepted) {
      rows.add(_buildDataRow('Koreksi Desa', report.koreksiDesa));
    }

    rows.add(_buildDataRow('Validasi Kecamatan', _getValidationStatusText(report.validasiKecamatan)));

    if (report.validasiKecamatan != ReportValidationStatus.accepted) {
      rows.add(_buildDataRow('Koreksi Kecamatan', report.koreksiKecamatan));
    }

    return rows;
  }

  DataRow _buildDataRow(String label, String value) {
    return DataRow(cells: [
      DataCell(Text(label)),
      DataCell(
        Text(
          value,
          style: const TextStyle(height: 1.5),
        ),
      ),
    ]);
  }

  Widget _buildImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            'Gambar'.text.xl.bold.make(),
            const SizedBox(width: 8),
            '(${report.images.length})'.text.gray600.make(),
          ],
        ),
        const SizedBox(height: 8),
        if (report.images.isEmpty) 'Tidak ada gambar.'.text.make() else _buildImageGrid(context),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: report.images.length,
      itemBuilder: (context, index) {
        return _buildImageTile(context, index);
      },
    );
  }

  Widget _buildImageTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _openGallery(context, index),
      child: Hero(
        tag: 'image_$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            report.images[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenGallery(
          images: report.images,
          initialIndex: index,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (report.validasiDesa == ReportValidationStatus.rejected) {
      return Colors.red;
    }
    final status = report.validasiKecamatan.toLowerCase();
    switch (status) {
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    if (report.validasiDesa == ReportValidationStatus.rejected) {
      return 'Ditolak oleh desa';
    }
    final status = report.validasiKecamatan.toLowerCase();
    switch (status) {
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  String _getValidationStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  Future<void> _refreshReport(BuildContext context) async {
    // Implement refresh logic here
  }

  void _shareReport(BuildContext context) {
    // Implement share logic here
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
