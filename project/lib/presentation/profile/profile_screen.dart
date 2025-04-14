import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import 'package:project/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepo;

  const ProfileScreen({Key? key, required this.authRepo}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  bool _isLoading = true;
  late String avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = widget.authRepo.currentUser?.uid;
    if (uid == null) return;

    final profile = await widget.authRepo.getUserProfile(uid);
    if (profile != null) {
      _nameController.text = profile.name;
      _weightController.text = profile.weight.toString();
      _heightController.text = profile.height.toString();
      avatarUrl =
          widget.authRepo.currentUser?.photoURL ??
          ''; // Lấy URL ảnh từ Firebase Auth

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', profile.name);
      await prefs.setDouble('weight', profile.weight);
      await prefs.setDouble('height', profile.height);
      await prefs.setString('email', profile.email);
      await prefs.setString(
        'avatarUrl',
        avatarUrl,
      ); // Lưu avatarUrl vào SharedPreferences
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final uid = widget.authRepo.currentUser?.uid;
    if (uid == null) return;

    final profile = UserProfile(
      uid: uid,
      name: _nameController.text,
      email: widget.authRepo.currentUser?.email ?? '',
      weight: double.tryParse(_weightController.text) ?? 0,
      height:
          double.tryParse(_heightController.text) ??
          0, // Giữ avatarUrl cũ từ Firebase Auth
    );

    await widget.authRepo.updateUserProfile(profile);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', profile.name);
    await prefs.setDouble('weight', profile.weight);
    await prefs.setDouble('height', profile.height);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Thông tin đã được lưu!")));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticProvider>(context);
    final user = authProvider.user;

    if (_isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ người dùng', style: TextStyle(color: Colors.blue)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.blue),
            onPressed:
                () => Navigator.pushReplacementNamed(context, AppRoutes.home),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child:
                    user?.photoURL != null && user?.photoURL!.isNotEmpty == true
                        ? Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: Image.network(
                              user!.photoURL!,
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        : Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/default-avatar.png",
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
              ),

              // Hiển thị ảnh đại diện
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Họ tên'),
                cursorColor: Colors.blue,
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Chiều cao (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: TextEditingController(
                  text: widget.authRepo.currentUser?.email,
                ),
                decoration: InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProfile, child: Text("Lưu")),
            ],
          ),
        ),
      ),
    );
  }
}
