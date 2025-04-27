import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/authentic_provider.dart';
import 'providers/theme_provider.dart'; // Import ThemeProvider
import '../../core/theme.dart';
import 'routes/app_routes.dart'; // Import SplashScreen

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: Consumer2<AuthenticProvider, ThemeProvider>(
        builder: (context, auth, themeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,       // appTheme và lightTheme là giống nhau
                darkTheme: darkTheme,    // Sử dụng darkTheme cho chế độ tối
                themeMode: themeProvider.themeMode, // Lấy themeMode từ provider
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
