import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../login_screen.dart';

class SignUpWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController reEnterPassController;
  final TextEditingController nameController;
  final VoidCallback onSignUp;
  final VoidCallback onGoogleLogin;
  final bool isLoading;

  const SignUpWidget({
    required this.emailController,
    required this.passwordController,
    required this.reEnterPassController,
    required this.nameController,
    required this.onSignUp,
    required this.onGoogleLogin,
    required this.isLoading,
    super.key,
  });

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool _isAccept = false;

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
                widget.emailController,
                "Email",
                false,
                TextInputType.emailAddress,
              ),
              SizedBox(height: 10.h),
              _buildTextField(widget.passwordController, "Mật khẩu", true),
              SizedBox(height: 10.h),
              _buildTextField(
                widget.reEnterPassController,
                "Nhập lại mật khẩu",
                true,
              ),

              SizedBox(height: 10.h),
              Row(
                children: [
                  Checkbox(
                    value: _isAccept,
                    onChanged:
                        (value) => setState(() => _isAccept = value ?? false),
                  ),
                  Expanded(
                    child: Text(
                      "Đồng ý với Điều khoản Dịch vụ và Chính sách Quyền riêng tư.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              widget.isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                    onTap: () {
                      if (!_isAccept) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Bạn phải chấp nhận điều khoản trước.",
                            ),
                          ),
                        );
                        return;
                      }

                      if (widget.passwordController.text !=
                          widget.reEnterPassController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Mật khẩu không khớp.")),
                        );
                        return;
                      }

                      widget.onSignUp();
                    },
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
                onPressed: widget.isLoading ? null : widget.onGoogleLogin,
              ),

              SizedBox(height: 100.h),
              Text(
                "Bạn đã có tài khoản?",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              InkWell(
                onTap:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
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

class LoginWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final bool isLoading;

  const LoginWidget({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Mật khẩu",
            border: OutlineInputBorder(),
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
        isLoading
            ? CircularProgressIndicator()
            : InkWell(
              onTap: onLogin,
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
          onPressed: isLoading ? null : onGoogleLogin,
        ),
      ],
    );
  }
}
