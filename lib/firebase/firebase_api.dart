import 'package:android_fe/config/routing/ApiRoutes.dart';
import 'package:android_fe/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      final details = NotificationDetails(android: androidDetails);

      // Gunakan data atau notification
      final title = message.notification?.title ?? message.data['title'] ?? 'No Title';
      final body = message.notification?.body ?? message.data['body'] ?? 'No Body';

      await flutterLocalNotificationsPlugin.show(message.hashCode, title, body, details);
    } catch (e) {
      print("Notification show error: $e");
    }
  }

  Future<void> initNotification() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final FCMToken = await _firebaseMessaging.getToken();
        if (FCMToken != null) {
          print('FCM Token: $FCMToken');
          await saveTokenFCM(FCMToken);
        } else {
          print('Failed to get FCM token');
        }

        await initPushNotification();
      } else {
        print('User declined or has not accepted notification permissions');
      }
    } catch (e) {
      print('Error during notification initialization: $e');
    }
  }

  Future<void> saveTokenFCM(String fcmToken) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final authToken = prefs.getString('token');

        if (authToken == null) {
          print('No authentication token found');
          return;
        }

        final response = await http.post(
          Uri.parse('${ApiConstants.saveTokenFCM}'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
          body: '{"token": "$fcmToken"}',
        );

        if (response.statusCode == 200) {
          print('Token saved successfully!');
          return;
        } else {
          print('Failed to save token FCM: ${response.statusCode}');
        }
      } catch (e) {
        print('Error saving FCM token: $e');
      }

      retries--;
      await Future.delayed(Duration(seconds: 2));
    }

    print('Failed to save token after retries');
  }

  Future<void> initPushNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Full Message Data: ${message.data}");
      print("Notification Title: ${message.notification?.title}");
      print("Notification Body: ${message.notification?.body}");
      showLocalNotification(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Initial Message: ${message.data}");
        handleMessage(message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("FCM Token refreshed: $newToken");
      saveTokenFCM(newToken);
    });
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final route = message.data['route']; // Misal data notifikasi berisi key `route`
    if (route != null) {
      navigatorKey.currentState?.pushNamed(route, arguments: message);
    } else {
      navigatorKey.currentState?.pushNamed(
        '/notification_screen',
        arguments: message,
      );
    }
  }
}
