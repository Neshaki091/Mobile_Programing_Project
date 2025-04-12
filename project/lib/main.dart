import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/workout_provider.dart';

import 'routes/app_routes.dart';
import 'providers/authentic_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticProvider()..initializeAuth(),
        ),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: Consumer<AuthenticProvider>(
        builder: (context, auth, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute:
                    auth.isLoggedIn ? AppRoutes.home : AppRoutes.login,
                onGenerateRoute: AppRoutes.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
