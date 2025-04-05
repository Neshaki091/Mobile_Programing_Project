import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create:
          (_) =>
              AuthenticProvider()
                ..initializeAuth(), // Gọi phương thức khởi tạo để kiểm tra trạng thái đăng nhập
      child: Consumer<AuthenticProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: auth.isLoggedIn ? AppRoutes.home : AppRoutes.login,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
