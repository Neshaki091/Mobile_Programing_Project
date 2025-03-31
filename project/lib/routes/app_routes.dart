import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/home/home_screen.dart';

class AppRoutes {
  static const String login = "/login";
  static const String home = "/home";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("Không tìm thấy trang!"))),
        );
    }
  }

  // Hàm giúp điều hướng đến màn hình đăng nhập sau khi đăng xuất
  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }
}
