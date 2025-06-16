import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart'; // Dùng AuthViewModel
import '../views/widget/auth_widget.dart';
import 'login_screen.dart'; // Cần thay thế đúng path

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPassController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
        child: SignUpWidget(
          emailController: _emailController,
          passwordController: _passwordController,
          reEnterPassController: _reEnterPassController,
          nameController: _nameController,
          onSignUp: _signUp,
          onGoogleLogin: () {}, // Nếu chưa có loginWithGoogle thì để trống
          isLoading: _isLoading,
        ),
      ),
    );
  }

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final rePassword = _reEnterPassController.text.trim();
    final name = _nameController.text.trim();

    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    bool success = await authVM.signUp(email, password, name);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authVM.errorMessage ?? 'Đăng ký thất bại')),
      );
    }
  }
}
