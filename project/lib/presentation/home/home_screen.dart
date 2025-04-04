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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // ✅ Tự động căn đều
          children: [
            IconButton(
              icon: Icon(Icons.people_outline, color: Colors.blue),
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            Image.asset("assets/images/logo_image.png", width: 60, height: 40),
            PopupMenuButton<String>(
              icon: Icon(Icons.list),
              onSelected: (value) async {
                if (value == "2") {
                  await authProvider.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: "1", child: Text("Trang cá nhân")),
                    PopupMenuItem(value: "2", child: Text("Đăng xuất")),
                  ],
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Thêm cuộn nếu nội dung dài
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ Tránh tràn màn hình
              children: [
                user != null && user.photoURL != null
                    ? Image.network(user.photoURL!, width: 50, height: 50)
                    : Image.asset(
                      "assets/images/default-avatar.png",
                      width: 50,
                      height: 50,
                    ),
                Text(
                  user != null
                      ? "Xin chào, ${user.email}"
                      : "Bạn chưa đăng nhập!",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20), // ✅ Thêm khoảng cách để tránh tràn
              ],
            ),
          ),
        ),
      ),
    );
  }
}
