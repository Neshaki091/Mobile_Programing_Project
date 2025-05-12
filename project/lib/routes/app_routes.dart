import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/data/models/workout_model.dart';
import 'package:project/presentation/exercises/exercises_screen.dart';
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
import '../presentation/community/chat_screen.dart';
import '../data/models/user_model.dart';
import '../presentation/exercises/exercise_detail_screen.dart';
import '../presentation/journey/journey_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String nutrition = '/nutrition';
  static const String profile = '/profile';
  static const String editSchedule = '/editSchedule';
  static const String community = '/community';
  static const String chat = '/chat';
  static const String nutritionDetail = '/nutritionDetail';
  static const String exercises = '/exercises';
  static const String workout = '/workout';
  static const String exercise = 'exercise';
  static const String editProfile = '/editProfile';
  static const String exerciseDetail = '/exerciseDetail';
  static const String journey = '/journey';

  static final Map<String, WidgetBuilder> _routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    signup: (_) => SignUpScreen(),
    nutrition: (_) => NutritionScreen(),
    editSchedule: (_) => EditScheduleScreen(),
    workout: (_) => WorkoutScreen(),
    exercise: (_) => ExerciseScreen(),
    community: (_) => CommunityScreen(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case journey:
          return MaterialPageRoute(
            builder: (_) => JourneyScreen(authRepo: AuthRepository()),
          );

        case exerciseDetail:
          if (settings.arguments is Workout) {
            final workout = settings.arguments as Workout;
            return MaterialPageRoute(
              builder: (_) => ExerciseDetailScreen(workout: workout),
            );
          } else {
            throw Exception('Invalid arguments for exerciseDetail');
          }

        case profile:
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(authRepo: AuthRepository()),
          );

        case chat:
          if (settings.arguments is Map<String, dynamic>) {
            final args = settings.arguments as Map<String, dynamic>;
            final currentUser = args['currentUser'] as User;
            final friend = args['friend'] as UserProfile;
            return MaterialPageRoute(
              builder:
                  (_) => ChatScreen(currentUser: currentUser, friend: friend),
            );
          } else {
            throw Exception('Invalid arguments for chat');
          }

        case home:
          return MaterialPageRoute(
            builder:
                (context) => WillPopScope(
                  onWillPop: () async {
                    // Hiển thị hộp thoại xác nhận thoát ứng dụng
                    final shouldExit = await showDialog<bool>(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            title: Text('Thoát ứng dụng'),
                            content: Text('Bạn có chắc chắn muốn thoát không?'),
                            actions: [
                              TextButton(
                                onPressed:
                                    () =>
                                        Navigator.of(dialogContext).pop(false),
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
                  child: HomeScreen(authRepo: AuthRepository()),
                ),
          );

        default:
          final builder = _routes[settings.name];
          if (builder != null) {
            return MaterialPageRoute(builder: builder);
          } else {
            throw Exception('Route "${settings.name}" không được định nghĩa.');
          }
      }
    } catch (e, stack) {
      debugPrint('⚠ Lỗi điều hướng: $e\n$stack');
      return _buildErrorRoute('Lỗi khi điều hướng: $e');
    }
  }

  static Route<dynamic> _buildErrorRoute(String errorMessage) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: Text('Lỗi')),
            body: Center(
              child: Text(errorMessage, textAlign: TextAlign.center),
            ),
          ),
    );
  }
}
