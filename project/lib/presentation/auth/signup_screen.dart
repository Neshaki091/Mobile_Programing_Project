import 'package:flutter/material.dart';
import 'package:project/presentation/auth/login_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
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
  bool _isAccepst = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _reEnterPassController.addListener(() => setState(() {}));
  }

  void _signUp(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      bool success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).register(_emailController.text.trim(), _passwordController.text.trim());

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
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
    bool passwordsMatch =
        _passwordController.text == _reEnterPassController.text;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset(
                "assets/images/logo_image.png",
                width: 150,
                height: 80,
              ),
              SizedBox(height: 20),
              Text(
                "Hãy bắt đầu vì sức khỏe của bạn",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _reEnterPassController,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),

              SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                    onTap: () {
                      if (!_isAccepst) {
                        _showErrorDialog(
                          "Bạn cần chấp nhận điều khoản trước khi tiếp tục.",
                        );
                        return;
                      }

                      if (passwordsMatch && _emailController.text.isNotEmpty) {
                        _signUp(context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 128,
                        vertical: 12,
                      ),
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isAccepst,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isAccepst = newValue!;
                        });
                      },
                    ),
                    // Để văn bản tự động xuống dòng nếu quá dài
                    Expanded(
                      child: Text(
                        "Đồng ý với Điều khoản Dịch vụ và Chính sách Quyền riêng tư của Fitness & Nutrition.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    height: 1,
                    width: 100,
                    child: Container(
                      width: 50, // Độ dài gạch ngang
                      height: 4, // Độ dày gạch
                      color: Colors.black, // Màu sắc
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Hoặc đăng nhập với",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 1,
                    width: 100,
                    child: Container(
                      width: 50, // Độ dài gạch ngang
                      height: 4, // Độ dày gạch
                      color: Colors.black, // Màu sắc
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: ClipOval(
                  child: Image.asset(
                    "assets/images/g-logo.png",
                    width: 40,
                    height: 40,
                  ),
                ),
                onPressed: () async {
                  try {
                    bool success =
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).loginWithGoogle();
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      _showErrorDialog("Đăng nhập Google thất bại!");
                    }
                  } catch (e) {
                    _showErrorDialog("Lỗi hệ thống: ${e.toString()}");
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        "Bạn đã có tài khoản, đăng nhập",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Đăng Nhập",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
