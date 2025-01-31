import 'package:android_fe/firebase/firebase_api.dart';
import 'package:android_fe/auth/login_page.dart';
import 'package:android_fe/firebase_options.dart';
import 'package:android_fe/notification/notification_page.dart';
import 'package:android_fe/page/routers_page.dart';
import 'package:android_fe/profil/crud/dai_provider.dart';
import 'package:android_fe/report/crud/report_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      print("Firebase initialized successfully");
    }
    await FirebaseApi().initNotification().then((_) {
      print("Firebase notification initialization complete");
    }).catchError((error) {
      print("Firebase notification initialization error: $error");
    });
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isTokenValid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkTokenValidity();
  }

  Future<void> _checkTokenValidity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final expiredAtString = prefs.getString('token_expired');

      if (token == null || expiredAtString == null) {
        setState(() {
          _isTokenValid = false;
          _isLoading = false;
        });
        return;
      }

      // Convert timestamp to DateTime
      final expiredAt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(expiredAtString) * 1000 // Convert Unix timestamp to milliseconds
          );

      setState(() {
        _isTokenValid = expiredAt.isAfter(DateTime.now());
        _isLoading = false;
      });
    } catch (e) {
      print('Token validation error: $e');
      setState(() {
        _isTokenValid = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => DaiProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('id', 'ID'),
        ],
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          useMaterial3: false,
        ),
        home: _isLoading
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (_isTokenValid == true ? const RoutersPage() : const LoginPage()),
        navigatorKey: navigatorKey,
        routes: {
          '/notification_screen': (context) => const NotificationPage(),
        },
      ),
    );
  }
}
