import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart' as local_auth;
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<local_auth.AuthProvider>(context);
    final User? user = authProvider.user; // Lấy user từ provider

    return Scaffold(
      appBar: AppBar(
        title: Text("Trang Chủ"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          user != null ? "Xin chào, ${user.email}" : "Bạn chưa đăng nhập!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
