import 'package:android_fe/model/report_model.dart';
import 'package:android_fe/report/crud/get_all_report.dart';
import 'package:android_fe/report/show_report.dart';
import 'package:android_fe/report/update_report.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Reports>>? futureReports;
  final getReports get_reports = getReports();
  String? _token;

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

    // If the token is valid, call fetchReports
    setState(() {
      _token = token;
      futureReports = get_reports.fetchReports(_token!);
    });
  }

  Future<void> _refreshReports() async {
    if (_token != null) {
      setState(() {
        futureReports = get_reports.fetchReports(_token!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat'),
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
                        debugPrint(
                            'validasiDesa: ${report.validasiDesa}, validasiKecamatan: ${report.validasiKecamatan}');

                        return Card(
                          color: _getCardColor(report.validasiDesa, report.validasiKecamatan),
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: _buildStatusIndicator(report.validasiDesa, report.validasiKecamatan),
                            title: Text(
                              report.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lokasi: ${report.place}'),
                                Text('Tanggal: ${report.date}'),
                                if (report.validasiDesa == 'ditolak' || report.validasiKecamatan == 'ditolak')
                                  const Text(
                                    'Status: Ditolak',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  )
                                else if (report.validasiDesa == 'diterima' && report.validasiKecamatan == null)
                                  const Text(
                                    'Status: Diterima, Belum Divalidasi oleh Kecamatan',
                                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                  )
                                else if (report.validasiDesa == 'diterima' && report.validasiKecamatan == 'diterima')
                                  const Text(
                                    'Status: Diterima',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  )
                                else if (report.validasiDesa == null && report.validasiKecamatan == null)
                                  Text(
                                    'Status: Belum divalidasi',
                                    style: TextStyle(color: Colors.grey.shade100, fontWeight: FontWeight.bold),
                                  )
                              ],
                            ),
                            trailing: (report.validasiDesa == 'ditolak' || report.validasiKecamatan == 'ditolak')
                                ? IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.black),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateReport(report: report),
                                        ),
                                      ).then((_) {
                                        // Refresh the reports after returning from the update page
                                        _refreshReports();
                                      });
                                    },
                                  )
                                : null,
                            onTap: () async {
                              // Navigate to report detail
                              if (_token == null || report.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ID laporan tidak valid')),
                                );
                                return;
                              }
                              try {
                                final reportDetail = await get_reports.fetchReportsById(_token!, report.id!);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailReportPage(report: reportDetail),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal memuat detail laporan: $e')),
                                );
                              }
                            },
                          ),
                        );
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
    return Colors.red.shade100; // Light red for rejected
  } else if (desaStatus == 'diterima' && kecamatanStatus == 'diterima') {
    return Colors.green.shade100; // Light green for fully approved
  } else if (desaStatus == 'diterima' || kecamatanStatus == 'ditolak') {
    return Colors.yellow.shade100; // Light yellow for partial approval
  }
  return Colors.grey.shade100; // Light grey for unvalidated
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
