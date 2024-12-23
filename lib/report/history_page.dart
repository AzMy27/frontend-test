import 'package:android_fe/model/report_model.dart';
import 'package:android_fe/report/crud/get_report.dart';
import 'package:android_fe/report/show_report.dart';
import 'package:android_fe/report/update_report.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Reports>>? futureReports;
  final getReports get_reports = getReports();
  String? _token;
  bool _isDescending = true; // Default sorting is descending

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      setState(() {
        _token = null;
      });
      return;
    }

    setState(() {
      _token = token;
      futureReports = _sortReports(get_reports.fetchReports(_token!));
    });
  }

  Future<List<Reports>> _sortReports(Future<List<Reports>> reportsFuture) async {
    List<Reports> reports = await reportsFuture;

    // Parse and sort reports by date
    reports.sort((a, b) {
      DateTime? dateA = DateTime.tryParse(a.date ?? '');
      DateTime? dateB = DateTime.tryParse(b.date ?? '');

      if (dateA == null || dateB == null) return 0;

      return _isDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });

    return reports;
  }

  Future<void> _refreshReports() async {
    if (_token != null) {
      setState(() {
        futureReports = _sortReports(get_reports.fetchReports(_token!));
      });
    }
  }

  void _toggleSorting() {
    setState(() {
      _isDescending = !_isDescending;
      futureReports = _sortReports(futureReports!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat'),
          actions: [
            IconButton(
              icon: Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
              tooltip: _isDescending ? 'Urutkan dari Terbaru ke Terlama' : 'Urutkan dari Terlama ke Terbaru',
              onPressed: _toggleSorting,
            ),
          ],
        ),
        body: _token == null
            ? const Center(
                child: Text(
                  'Token tidak ditemukan. Silakan login kembali.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshReports,
                child: FutureBuilder<List<Reports>>(
                  future: futureReports,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada laporan.'));
                    }

                    final reports = snapshot.data!;
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return _buildCard(report, context, _token, _refreshReports);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}

Color _getCardColor(String desaStatus, String kecamatanStatus) {
  if (desaStatus == 'ditolak' || kecamatanStatus == 'ditolak') {
    return Colors.red.shade100;
  } else if (desaStatus == 'diterima' && kecamatanStatus == 'diterima') {
    return Colors.green.shade100;
  } else if (desaStatus == 'diterima' || kecamatanStatus == 'ditolak') {
    return Colors.yellow.shade100;
  }
  return Colors.grey.shade100;
}

Widget _buildStatusIndicator(String desaStatus, String kecamatanStatus) {
  Color indicatorColor;

  if (desaStatus == 'ditolak' || kecamatanStatus == 'ditolak') {
    indicatorColor = Colors.red;
  } else if (desaStatus == 'diterima' && kecamatanStatus == 'diterima') {
    indicatorColor = Colors.green;
  } else if (desaStatus == 'diterima' || kecamatanStatus == 'ditolak') {
    indicatorColor = Colors.yellow;
  } else {
    indicatorColor = Colors.grey;
  }

  return Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(
      color: indicatorColor,
      shape: BoxShape.circle,
    ),
  );
}

Widget _buildCard(Reports report, BuildContext context, String? token, Function refreshReports) {
  return VxBox(
    child: VStack([
      HStack([
        _buildStatusIndicator(report.validasiDesa, report.validasiKecamatan),
        10.widthBox,
        VStack([
          report.title.text.bold.xl.make(),
          'Lokasi: ${report.place}'.text.sm.make(),
          'Tanggal: ${report.date}'.text.sm.make(),
          if (report.validasiDesa == 'ditolak' || report.validasiKecamatan == 'ditolak')
            'Status: Ditolak'.text.red500.bold.make()
          else if (report.validasiDesa == 'diterima' && report.validasiKecamatan == null)
            'Status: Diterima, Belum Divalidasi oleh Kecamatan'.text.orange500.bold.make()
          else if (report.validasiDesa == 'diterima' && report.validasiKecamatan == 'diterima')
            'Status: Diterima'.text.green500.bold.make()
          else if (report.validasiDesa == null && report.validasiKecamatan == null)
            'Status: Belum divalidasi'.text.gray500.bold.make(),
        ]).expand()
      ]),
      if (report.validasiDesa == 'ditolak' || report.validasiKecamatan == 'ditolak')
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.edit, color: Colors.black)
                .onInkTap(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateReport(report: report),
                    ),
                  ).then((_) => refreshReports());
                })
                .box
                .padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 1))
                .roundedSM
                .make()
          ],
        )
    ]),
  )
      .color(_getCardColor(report.validasiDesa, report.validasiKecamatan))
      .margin(Vx.m4)
      .padding(const EdgeInsets.all(12))
      .roundedSM
      .make()
      .onTap(() async {
    if (token == null || report.id == null) {
      VxToast.show(context, msg: "ID laporan tidak valid");
      return;
    }
    try {
      final reportDetail = await getReports().fetchReportsById(token, report.id!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailReportPage(report: reportDetail),
        ),
      );
    } catch (e) {
      VxToast.show(context, msg: "Gagal memuat detail laporan: $e");
    }
  });
}
