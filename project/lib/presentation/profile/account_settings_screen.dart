import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isVerifying = false;

  Future<void> _sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy người dùng")),
      );
      return;
    }

    if (user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email đã được xác minh")),
      );
      return;
    }

    try {
      setState(() {
        _isVerifying = true;
      });

      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email xác minh đã được gửi")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi gửi email xác minh: $e")),
      );
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt tài khoản"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email: ${user?.email ?? 'Không có email'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  user?.emailVerified == true
                      ? "Trạng thái: Đã xác minh"
                      : "Trạng thái: Chưa xác minh",
                  style: TextStyle(
                    fontSize: 16,
                    color: user?.emailVerified == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                if (user?.emailVerified == false)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      await user?.reload();
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (user?.emailVerified == false)
              ElevatedButton(
                onPressed: _isVerifying ? null : _sendEmailVerification,
                child: _isVerifying
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Gửi email xác minh"),
              ),
          ],
        ),
      ),
    );
  }
}