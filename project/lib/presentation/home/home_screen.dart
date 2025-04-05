import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(
    BuildContext context,
    AuthenticProvider authProvider, // Sửa lại đây
  ) async {
    await authProvider.logout();

    // Xóa toàn bộ route stack và quay về màn hình đăng nhập
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticProvider>(context); // Sửa lại đây
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.people_outline, color: Colors.blue),
              onPressed: () => _handleLogout(context, authProvider),
            ),
            Image.asset("assets/images/logo_image.png", width: 60, height: 40),
            PopupMenuButton<String>(
              icon: const Icon(Icons.list),
              onSelected: (value) {
                if (value == "2") {
                  _handleLogout(context, authProvider);
                } else if (value == "1") {
                  // TODO: chuyển đến màn hình hồ sơ cá nhân
                  // Navigator.pushNamed(context, AppRoutes.profile);
                }
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: "1", child: Text("Trang cá nhân")),
                    PopupMenuItem(value: "2", child: Text("Đăng xuất")),
                  ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                ClipOval(
                  child:
                      user?.photoURL != null
                          ? Image.network(
                            user!.photoURL!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            "assets/images/default-avatar.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Xin chào, ${user?.email ?? 'Người dùng'}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
