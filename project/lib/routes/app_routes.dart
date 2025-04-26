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
import '../presentation/nutrition/nutrition_detail_screen.dart';
import '../data/models/nutrition_model.dart';
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
  static const String chat = '/chat'; // ✅ Thêm route mới
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
    // editProfile: (_) => EditProfile() // Thêm route cho màn hình EditProfile nếu cần
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case nutritionDetail:
        final map = settings.arguments as Map<String, dynamic>;
        final nutritionModel = NutritionModel.fromJson(map);
        return MaterialPageRoute(
          builder: (_) => NutritionDetailScreen(nutritionModel: nutritionModel),
        );
      case journey:
        // Kiểm tra và truyền route mà không cần truyền authRepo qua arguments
        if (settings.name == journey) {
          return MaterialPageRoute(
            builder: (_) => JourneyScreen(authRepo: AuthRepository()),
          );
        } // Không cần truyền authRepo ở đây

      case exerciseDetail:
        if (settings.arguments != null && settings.arguments is Workout) {
          final workout = settings.arguments as Workout;
          return MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(workout: workout),
          );
        } else {
          return _buildErrorRoute('Workout data is missing or invalid');
        }
      case profile:
        if (settings.name == profile) {
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(authRepo: AuthRepository()),
          );
        }

      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        final currentUser = args['currentUser'] as User;
        final friend = args['friend'] as UserProfile;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(currentUser: currentUser, friend: friend),
        );

      case home:
        return MaterialPageRoute(
          builder:
              (context) => WillPopScope(
                onWillPop: () async {
                  final shouldExit = await showDialog<bool>(
                    context: context,
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
                child: HomeScreen(authRepo: AuthRepository()),
              ),
        );

      default:
        final builder = _routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        return _buildErrorRoute('Route not found');
    }
  }

  static Route<dynamic> _buildErrorRoute(String errorMessage) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text(errorMessage)),
          ),
    );
  }
}
