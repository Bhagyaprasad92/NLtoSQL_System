import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return '/api';
    }
    return 'http://3.87.119.190:8080/api';
  }

  static String get loginUrl => '$baseUrl/auth/login';
  static String get registerUrl => '$baseUrl/auth/register';
  static String get dashboardApiUrl => '$baseUrl/students/dashboard';
  static String get nl2SqlApiUrl => '$baseUrl/nl2sql/query';
  static String get studentDetailsApiUrl => '$baseUrl/students';
  static String get forgotPasswordUrl => '$baseUrl/auth/forgot-password';
  static String get resetPasswordUrl => '$baseUrl/auth/reset-password';

  static String getImageUrl(String originalUrl) {
    if (kReleaseMode) {
      // Production (EC2)
      return "$baseUrl/image?url=${Uri.encodeComponent(originalUrl)}";
    } else {
      return originalUrl;
    }
  }
}
