// final url = 'http://192.168.0.13:8000/api/';
// final url = 'http://192.168.131.116:8000/api/';
// final addReport = url + 'reportsAPI';
// final loginSubmit = url + 'loginAPI';
// final logoutSubmit = url + 'logoutAPI';

class ApiConstants {
  // static const String baseUrl = 'http://192.168.131.116:8000/';
  static const String baseUrl = 'http://192.168.0.13:8000';
  static const String loginSubmit = '$baseUrl/api/loginAPI';
  static const String addReport = '$baseUrl/api/reportsAPI';
  static const String logoutSubmit = '$baseUrl/api/logoutAPI';
}

class AppConfig {
  static const int maxImages = 5;
  static const int imageQuality = 60;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
}
