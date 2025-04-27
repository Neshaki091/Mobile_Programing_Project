import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'dart:io' as io;
import 'providers/schedule_provider.dart';
import 'providers/authentic_provider.dart';
import '../../core/theme.dart';
import 'routes/app_routes.dart';
import 'providers/workout_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Cấu hình Firebase Cloud Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Khi người dùng nhấn vào thông báo, mở ứng dụng và chuyển đến màn hình chat
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
    // Điều hướng đến ChatScreen khi thông báo được nhấn
    if (message.data.containsKey('chat_room_id')) {
      String chatRoomId = message.data['chat_room_id'];
      // Bạn có thể điều hướng tới màn hình chat tại đây
    }
  });

  // Lấy FCM Token để có thể sử dụng sau
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  runApp(const MyApp());
}

// Phương thức xử lý thông báo khi ứng dụng ở chế độ nền hoặc đã bị đóng
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Received a background message: ${message.messageId}');
  // Bạn có thể xử lý thông báo ở đây, ví dụ như lưu thông báo vào cơ sở dữ liệu hoặc ghi log
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
        ChangeNotifierProvider(
          create:
              (_) => ScheduleProvider(), // Provider đã có local notification
        ),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: Consumer<AuthenticProvider>(
        builder: (context, auth, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: appTheme,
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.generateRoute,
                // Đảm bảo là có xử lý thông báo khi ứng dụng được mở từ thông báo
              );
            },
          );
        },
      ),
    );
  }
}
