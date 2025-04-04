import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'signup_screen.dart';
import '../home/home_screen.dart';

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
    bool success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đăng nhập thất bại!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: SingleChildScrollView(
          // Thêm ScrollView để tránh tràn màn hình
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset(
                "assets/images/logo_image.png",
                width: 200,
                height: 120,
              ),
              SizedBox(height: 30),
              Text("Fitness & Nutrition", style: TextStyle(fontSize: 24)),
              Text("Thể hình và dinh dưỡng", style: TextStyle(fontSize: 24)),
              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Quên mật khẩu?",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                    onTap: () => _login(context),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 117,
                        vertical: 12,
                      ),

                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đăng nhập Google thất bại!")),
                    );
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
                        "Bạn chưa có tài khoản",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Đăng Ký",
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
