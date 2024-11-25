import 'package:android_fe/model/report_model.dart';
import 'package:android_fe/report/get_report.dart';
import 'package:android_fe/report/show_report.dart';
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
      // Jika token tidak ditemukan, berikan feedback
      setState(() {
        _token = null;
      });
      return;
    }

    // Jika token valid, panggil fetchReports
    setState(() {
      _token = token;
      futureReports = get_reports.fetchReports(_token!);
    });
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
            : FutureBuilder<List<Reports>>(
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
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(
                            report.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lokasi: ${report.place}'),
                              Text('Tanggal: ${report.date}'),
                            ],
                          ),
                          onTap: () async {
                            // Navigasi ke detail laporan
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
    );
  }
}
