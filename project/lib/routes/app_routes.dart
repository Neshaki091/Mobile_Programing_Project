import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/nutrition/nutrition_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/home/editScheduleScreen.dart';
import '../presentation/splashScreen.dart';
import '../presentation/community/community.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String nutrition = '/nutrition';
  static const String profile = '/profile';
  static const String editSchedule = '/editSchedule';
  static const String community = '/community';
  static final Map<String, WidgetBuilder> _routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    signup: (_) => SignUpScreen(),
    nutrition: (_) => NutritionScreen(),
    editSchedule: (_) => EditScheduleScreen(),
    community: (_) => Community(FirebaseAuth.instance.currentUser!),
    // Không cần định nghĩa profile route ở đây vì đã xử lý riêng trong generateRoute
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == profile) {
      return MaterialPageRoute(
        builder: (_) => ProfileScreen(authRepo: AuthRepository()), // Truyền AuthRepository vào đây
      );
    }

    if (settings.name == home) {
      return MaterialPageRoute(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text('Thoát ứng dụng'),
                content: Text('Bạn có chắc chắn muốn thoát không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text('Không'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text('Có'),
                  ),
                ],
              ),
            );
            return shouldExit ?? false;
          },
          child: HomeScreen(),
        ),
      );
    }

    final builder = _routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return null; // Không cần default nếu đã handle rõ ràng
  }
}
