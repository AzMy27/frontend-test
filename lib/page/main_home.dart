import 'dart:async';
import 'dart:convert';

import 'package:android_fe/model/report_model.dart';
import 'package:android_fe/report/crud/get_report.dart';
import 'package:flutter/material.dart';
import 'package:android_fe/config/constants/colors.dart' as color;
import 'package:android_fe/report/history_page.dart';
import 'package:android_fe/report/report_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List info = [];
  _initData() async {
    String data = await DefaultAssetBundle.of(context).loadString('json/info.json');
    setState(() {
      info = json.decode(data);
    });
  }

  String _currentDate = '';
  String _currentTime = '';
  Timer? _timer;
  String _username = '';
  Reports? _latestReport;
  final getReports _getReports = getReports();

  @override
  void initState() {
    super.initState();
    _initData();
    _startClock();
    _loadUserName();
  }

  Future<void> _fetchLatestReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        final reports = await _getReports.fetchReports(token);
        if (reports.isNotEmpty) {
          setState(() {
            // Sort reports by date and get the most recent one
            _latestReport = reports.reduce(
                (current, next) => DateTime.parse(current.date).isAfter(DateTime.parse(next.date)) ? current : next);
          });
        }
      } catch (e) {
        print('Error fetching latest report: $e');
      }
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
    });
  }

  void _startClock() {
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _updateDateTime();
      });
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    _currentDate = '${now.day}-${now.month}-${now.year}';
    _currentTime = '${_formatDigit(now.hour)}:${_formatDigit(now.minute)}:${_formatDigit(now.second)}';
  }

  String _formatDigit(int value) {
    return value < 10 ? '0$value' : value.toString();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Beranda',
                      style: TextStyle(
                        fontSize: 30,
                        color: color.AppColor.homePageTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Selamat Datang $_username',
                  style: TextStyle(
                    fontSize: 20,
                    color: color.AppColor.homePageSubtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.AppColor.gradientFirst.withOpacity(0.8),
                        color.AppColor.gradientSecond.withOpacity(0.9),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20,
                        color: color.AppColor.gradientSecond.withOpacity(0.2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hari/Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          color: color.AppColor.homePageContainerTextSmall,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _currentDate,
                        style: TextStyle(
                          fontSize: 24,
                          color: color.AppColor.homePageContainerTextSmall,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Waktu',
                        style: TextStyle(
                          fontSize: 16,
                          color: color.AppColor.homePageContainerTextSmall,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _currentTime,
                        style: TextStyle(
                          fontSize: 24,
                          color: color.AppColor.homePageContainerTextSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 40,
                            offset: Offset(8, 10),
                            color: color.AppColor.gradientSecond.withOpacity(0.3),
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-1, -5),
                            color: color.AppColor.gradientSecond.withOpacity(0.3),
                          ),
                        ],
                      ),
                      height: 120,
                    ),
                    Positioned(
                      left: 10,
                      top: 0,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage('images/book.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 170,
                      top: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Laporan Hari Ini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color.AppColor.homePageTitle,
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              text: 'Status: ',
                              style: TextStyle(
                                fontSize: 16,
                                color: color.AppColor.homePagePlanColor,
                              ),
                              children: [
                                TextSpan(
                                  text: _getStatusText(),
                                  style: TextStyle(
                                    color: _getStatusColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Laporkan Kegiatan',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color.AppColor.homePageTitle,
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (info.length.toDouble() / 2).toInt(),
                  itemBuilder: (_, index) {
                    int buttonA = 2 * index;
                    int buttonB = 2 * index + 1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(info[buttonA]),
                        _buildInfoCard(info[buttonB]),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () {
        if (data['title'] == 'Buat Laporan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportPage()),
          );
        } else if (data['title'] == 'Riwayat Laporan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryPage()),
          );
        }
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 90) / 2,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(5, 5),
              color: color.AppColor.gradientSecond.withOpacity(0.2),
            ),
            BoxShadow(
              blurRadius: 3,
              offset: Offset(-5, -5),
              color: color.AppColor.gradientSecond.withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              data['img'],
              height: 100,
            ),
            SizedBox(height: 5),
            Text(
              data['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color.AppColor.homePageDetail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    if (_latestReport == null) {
      return 'Tidak ada';
    }

    if (_latestReport!.validasiDesa == 'ditolak' || _latestReport!.validasiKecamatan == 'ditolak') {
      return 'Ditolak';
    } else if (_latestReport!.validasiDesa == 'diterima' && _latestReport!.validasiKecamatan == 'diterima') {
      return 'Diterima';
    } else if (_latestReport!.validasiDesa == 'diterima' && _latestReport!.validasiKecamatan == null) {
      return 'Diterima (Menunggu Validasi Kecamatan)';
    } else {
      return 'Sedang Diproses';
    }
  }

  Color _getStatusColor() {
    if (_latestReport == null) {
      return Color(0xFF123456);
    }

    if (_latestReport!.validasiDesa == 'ditolak' || _latestReport!.validasiKecamatan == 'ditolak') {
      return Colors.red;
    } else if (_latestReport!.validasiDesa == 'diterima' && _latestReport!.validasiKecamatan == 'diterima') {
      return Colors.green;
    } else if (_latestReport!.validasiDesa == 'diterima' && _latestReport!.validasiKecamatan == null) {
      return Colors.orange;
    } else {
      return Colors.yellow;
    }
  }
}
