import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widgets/auth_provider.dart';
import '../../providers/authentic_provider.dart'; // Giả sử bạn có một provider cho xác thực

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPassController = TextEditingController();
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
          onSignUp: _signUp,
          onGoogleLogin: _googleLogin,
          isLoading: _isLoading,
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    // Giả sử bạn có một provider để đăng ký
    try {
      // Đăng ký người dùng bằng email và mật khẩu
      await Provider.of<AuthenticProvider>(
        context,
        listen: false,
      ).register(_emailController.text, _passwordController.text);
      // Sau khi đăng ký thành công, điều hướng người dùng
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _googleLogin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Đăng ký người dùng bằng email và mật khẩu
      await Provider.of<AuthenticProvider>(
        context,
        listen: false,
      ).loginWithGoogle();
      // Sau khi đăng ký thành công, điều hướng người dùng
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
