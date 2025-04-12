import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/nutrition/nutrition_screen.dart';
import '../presentation/auth/profile_screen.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/home/editScheduleScreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String nutrition = '/nutrition';
  static const String profile = '/profile';
  static const String editSchedule = '/editSchedule';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case nutrition:
        return MaterialPageRoute(builder: (_) => NutritionScreen());
      case editSchedule:
        return MaterialPageRoute(builder: (_) => EditScheduleScreen());
      case AppRoutes.profile:
        final authRepo = settings.arguments as AuthRepository?;
        if (authRepo != null) {
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(authRepo: authRepo),
          );
        } else {
          return MaterialPageRoute(
            builder:
                (_) => Scaffold(
                  appBar: AppBar(title: Text('Error')),
                  body: Center(child: Text('Thiếu AuthRepository')),
                ),
          );
        }
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(title: Text('404 - Not Found')),
                body: Center(child: Text('Trang không tồn tại')),
              ),
        );
    }
  }
}
