class ApiConstants {
  // static const String baseUrl = 'http://192.168.131.116:8000';
  // static const String baseUrl = 'http://192.168.137.254:8000';
  static const String baseUrl = 'http://192.168.0.13:8000';
  static const String loginSubmit = '$baseUrl/api/loginAPI';
  static const String logoutSubmit = '$baseUrl/api/logoutAPI';
  static const String addReport = '$baseUrl/api/reportPost';
  static const String getReport = '$baseUrl/api/reportGet';
  static const String showReportId = '$baseUrl/api/reportShow';
  static const String updateReport = '$baseUrl/api/reportPut';
  static const String getDai = '$baseUrl/api/daiAPI';
}

class AppConfig {
  static const int maxImages = 5;
  static const int imageQuality = 60;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
}
