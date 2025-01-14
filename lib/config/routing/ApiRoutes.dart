class ApiConstants {
  // static const String baseUrl = 'http://192.168.0.9:8000';
  static const String baseUrl = 'https://daibermasa.my.id';
  static const String loginSubmit = '$baseUrl/api/loginAPI';
  static const String logoutSubmit = '$baseUrl/api/logoutAPI';
  static const String addReport = '$baseUrl/api/reportPost';
  static const String getReport = '$baseUrl/api/reportGet';
  static const String showReportId = '$baseUrl/api/reportShow';
  static const String updateReport = '$baseUrl/api/reportPut';
  static const String showDai = '$baseUrl/api/daiShow';
  static const String updateDai = '$baseUrl/api/daiUpdate';
  static const String saveTokenFCM = '$baseUrl/api/saveToken';
  static const String changePassword = '$baseUrl/api/changePassword';
  static const String forgotPassword = '$baseUrl/api/forgotPassword';
  static const String resetPassword = '$baseUrl/api/resetPassword';
}

class AppConfig {
  static const int maxImages = 5;
  static const int imageQuality = 60;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
}
