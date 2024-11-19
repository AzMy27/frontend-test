import 'dart:async';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _initData();
    _startClock();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna'; // Default ke 'Pengguna' jika null
    });
  }

  void _startClock() {
    _updateDateTime(); // Initial update
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
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: <Widget>[
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
                Expanded(child: Container()),
                Icon(
                  Icons.person,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Selamat Datang $_username',
                  style: TextStyle(
                    fontSize: 20,
                    color: color.AppColor.homePageSubtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
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
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
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
                    SizedBox(
                      height: 10,
                    ),
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
                    SizedBox(
                      height: 10,
                    ),
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
            ),
            SizedBox(height: 15),
            // Status Laporan
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // image: DecorationImage(
                      //   image: AssetImage('images/bengkalis-bermasa.png'),
                      //   fit: BoxFit.fill,
                      // ),
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
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(right: 240, bottom: 30),
                    decoration: BoxDecoration(
                      // color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage('images/polbeng.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    // color: Colors.redAccent.withOpacity(0.2),
                    margin: const EdgeInsets.only(
                      left: 170,
                      top: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Laporan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.homePageTitle,
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Laporan sedang diperiksa\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: color.AppColor.homePagePlanColor,
                            ),
                            children: [
                              TextSpan(text: 'status: '),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'Laporkan Kegiatan',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color.AppColor.homePageTitle,
                  ),
                ),
              ],
            ),
            Expanded(
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    // itemCount: info.length,
                    itemCount: (info.length.toDouble() / 2).toInt(),
                    itemBuilder: (_, index) {
                      int buttonA = 2 * index;
                      int buttonB = 2 * index + 1;
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportPage()),
                              );
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 90) / 2,
                              height: 170,
                              margin: EdgeInsets.only(left: 30, bottom: 15, top: 15),
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(info[buttonA]['img']),
                                ),
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
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    info[buttonA]['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: color.AppColor.homePageDetail,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HistoryPage()),
                              );
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 90) / 2,
                              height: 170,
                              margin: EdgeInsets.only(left: 30, bottom: 15, top: 15),
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(info[buttonB]['img']),
                                ),
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
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    info[buttonB]['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: color.AppColor.homePageDetail,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
