import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import '../../routes/app_routes.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPassController = TextEditingController();
  bool _isLoading = false;
  bool _isAccept = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _reEnterPassController.addListener(() => setState(() {}));
  }

  void _signUp(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final rePassword = _reEnterPassController.text.trim();

    if (!_isAccept) {
      _showErrorDialog("Bạn cần chấp nhận điều khoản trước khi tiếp tục.");
      return;
    }

    if (email.isEmpty || password.isEmpty || rePassword.isEmpty) {
      _showErrorDialog("Vui lòng điền đầy đủ thông tin.");
      return;
    }

    if (password != rePassword) {
      _showErrorDialog("Mật khẩu không khớp.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      bool success = await Provider.of<AuthenticProvider>(
        context,
        listen: false,
      ).register(email, password);

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        _showErrorDialog("Đăng ký thất bại! Vui lòng thử lại.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("Lỗi hệ thống: ${e.toString()}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Lỗi"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
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
                width: 150.w,
                height: 80.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "Hãy bắt đầu vì sức khỏe của bạn",
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                _emailController,
                "Email",
                false,
                TextInputType.emailAddress,
              ),
              SizedBox(height: 10.h),
              _buildTextField(_passwordController, "Mật khẩu", true),
              SizedBox(height: 10.h),
              _buildTextField(
                _reEnterPassController,
                "Nhập lại mật khẩu",
                true,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Checkbox(
                    value: _isAccept,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isAccept = newValue ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Đồng ý với Điều khoản Dịch vụ và Chính sách Quyền riêng tư của Fitness & Nutrition.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                    onTap: () => _signUp(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 110.w,
                        vertical: 12.h,
                      ),
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: 20.h),
              _buildOrDivider(),
              IconButton(
                icon: ClipOval(
                  child: Image.asset(
                    "assets/images/g-logo.png",
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
                onPressed: () async {
                  try {
                    bool success =
                        await Provider.of<AuthenticProvider>(
                          context,
                          listen: false,
                        ).loginWithGoogle();

                    if (success) {
                      final user =
                          Provider.of<AuthenticProvider>(
                            context,
                            listen: false,
                          ).user;
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
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
                  } catch (e) {
                    _showErrorDialog("Lỗi hệ thống: ${e.toString()}");
                  }
                },
              ),
              SizedBox(height: 120.h),
              Column(
                children: [
                  Text(
                    "Bạn đã có tài khoản, đăng nhập",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      "Đăng Nhập",
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isObscure, [
    TextInputType type = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1.h, color: Colors.black)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            "Hoặc đăng nhập với",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ),
        Expanded(child: Container(height: 1.h, color: Colors.black)),
      ],
    );
  }
}
