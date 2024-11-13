final url = 'http://192.168.0.13:8000/api/';
// final url = 'http://192.168.131.116:8000/api/';
final addReport = url + 'reports';
final submitLogin = url + 'login';

// class ApiConstants {
//   static const String baseUrl = 'http://192.168.131.116:8000/';
//   static const String addReport = '$baseUrl/api/reports';
// }

class AppConfig {
  static const int maxImages = 5;
  static const int imageQuality = 60;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
}
