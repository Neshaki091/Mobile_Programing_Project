import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/presentation/workouts/workouts_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/nutrition/nutrition_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/home/editScheduleScreen.dart';
import '../presentation/splashScreen.dart';
import '../presentation/community/community.dart';
import '../presentation/nutrition/nutrition_detail_screen.dart';
import '../data/models/nutrition_model.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String nutrition = '/nutrition';
  static const String profile = '/profile';
  static const String editSchedule = '/editSchedule';
  static const String community = '/community';
  static const String nutritionDetail = '/nutritionDetail';
  static const String exercises = '/exercises';
  static const String workout = '/workout';
  static final Map<String, WidgetBuilder> _routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    signup: (_) => SignUpScreen(),
    nutrition: (_) => NutritionScreen(),
    editSchedule: (_) => EditScheduleScreen(),
    community: (_) => Community(FirebaseAuth.instance.currentUser!),
    workout: (_) => WorkoutScreen(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == nutritionDetail) {
      final map = settings.arguments as Map<String, dynamic>;
      final nutritionModel = NutritionModel.fromJson(map);
      return MaterialPageRoute(
        builder: (_) => NutritionDetailScreen(nutritionModel: nutritionModel),
      );
    }
    if (settings.name == profile) {
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
    }

    if (settings.name == home) {
      return MaterialPageRoute(
        builder:
            (context) => WillPopScope(
              onWillPop: () async {
                final shouldExit = await showDialog<bool>(
                  context: context, // ✅ Sửa ở đây
                  builder:
                      (dialogContext) => AlertDialog(
                        title: Text('Thoát ứng dụng'),
                        content: Text('Bạn có chắc chắn muốn thoát không?'),
                        actions: [
                          TextButton(
                            onPressed:
                                () => Navigator.of(dialogContext).pop(false),
                            child: Text('Không'),
                          ),
                          TextButton(
                            onPressed:
                                () => Navigator.of(dialogContext).pop(true),
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
