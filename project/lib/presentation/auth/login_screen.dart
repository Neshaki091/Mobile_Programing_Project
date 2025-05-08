import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login(BuildContext context) async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthenticProvider>(context, listen: false);
    final workoutProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      final user = authProvider.user;
      if (user != null) {
        workoutProvider.clearSchedule();
        await workoutProvider.loadFromFirestore(user.uid);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không lấy được thông tin người dùng!")),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đăng nhập không thành công!")));
    }
  }

  void _loginWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthenticProvider>(context, listen: false);
    final workoutProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );

    bool success = await authProvider.loginWithGoogle();
    setState(() => _isLoading = false);

    if (success) {
      final user = authProvider.user;
      if (user != null) {
        workoutProvider.clearSchedule();
        await workoutProvider.loadFromFirestore(user.uid);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Không lấy được thông tin người dùng từ Google!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.h),
              Image.asset(
                "assets/images/logo_image.png",
                width: 200.w,
                height: 120.h,
              ),
              SizedBox(height: 30.h),
              Text("Fitness & Nutrition", style: TextStyle(fontSize: 24.sp)),
              Text("Thể hình và dinh dưỡng", style: TextStyle(fontSize: 24.sp)),
              SizedBox(height: 30.h),
              LoginWidget(
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                onLogin: () => _login(context),
                onGoogleLogin: () => _loginWithGoogle(context),
              ),
              SizedBox(height: 100.h),
              Column(
                children: [
                  Text(
                    "Bạn chưa có tài khoản?",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signup);
                    },
                    child: Text(
                      "Đăng Ký",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
