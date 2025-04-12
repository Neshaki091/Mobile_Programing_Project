import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import '../../routes/app_routes.dart'; // Ensure this file contains the AppRoutes definition
import '../../providers/workout_provider.dart';

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
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );

    bool success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      final user = Provider.of<AuthenticProvider>(context, listen: false).user;
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
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                    onTap: () => _login(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100.w,
                        vertical: 12.h,
                      ),
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 50.w, height: 2.h, color: Colors.black),
                  SizedBox(width: 10.w),
                  Text(
                    "Hoặc đăng nhập với",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(width: 10.w),
                  Container(width: 50.w, height: 2.h, color: Colors.black),
                ],
              ),
              SizedBox(height: 10.h),
              IconButton(
                icon: ClipOval(
                  child: Image.asset(
                    "assets/images/g-logo.png",
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
                onPressed: () async {
                  setState(() => _isLoading = true);

                  final authProvider = Provider.of<AuthenticProvider>(
                    context,
                    listen: false,
                  );
                  final workoutProvider = Provider.of<WorkoutProvider>(
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
                          content: Text(
                            "Không lấy được thông tin người dùng từ Google!",
                          ),
                        ),
                      );
                    }
                  }
                },
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
