import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/data/repositories/auth_repository.dart';
import 'package:project/presentation/exercises/exercise_detail_screen.dart';
import 'package:project/presentation/profile/EditProfileScreen.dart';
import 'package:project/presentation/profile/feedback_screen.dart';
import 'package:project/presentation/profile/support_screen.dart';
import 'package:project/widgets/appBar_widget.dart';
import 'package:project/widgets/journey_provider.dart';

import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepo; // Thêm authRepo

  ProfileScreen({Key? key, required this.authRepo}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 0;
  bool _isLoading = true; // Biến theo dõi trạng thái loading

  // Biến lưu thông tin người dùng
  String _name = 'Đang tải...';
  String _email = 'Đang tải...';
  String _photoUrl = '';
  double _weight = 0;
  double _height = 0;
  int? _age;
  bool _isMale = true; // Thêm biến giới tính

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Gọi hàm tải dữ liệu khi khởi tạo màn hình
  }

  // Hàm tải dữ liệu người dùng
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true; // Bắt đầu loading
    });

    try {
      final uid = widget.authRepo.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Lấy dữ liệu từ Firestore
      final profile = await widget.authRepo.getUserProfile(uid);

      // Cập nhật state với dữ liệu từ profile
      setState(() {
        if (profile != null) {
          _name = profile.name;
          _email = profile.email;
          _weight = profile.weight;
          _height = profile.height;
          _age = profile.age;
          _isMale = profile.isMale; // Cập nhật giới tính
        }

        // Lấy photoURL từ Firebase Auth
        _photoUrl = widget.authRepo.currentUser?.photoURL ?? '';

        _isLoading = false; // Kết thúc loading
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void onTap(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.exercise);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.workout);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.journey);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.community);
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator()) // Hiển thị loading
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage:
                                _photoUrl.isNotEmpty
                                    ? NetworkImage(_photoUrl)
                                    : AssetImage(
                                          'assets/images/profile_placeholder.png',
                                        )
                                        as ImageProvider,
                          ),
                          SizedBox(width: 16.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _name, // Sử dụng dữ liệu động
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "@$_email", // Sử dụng dữ liệu động
                                  style: TextStyle(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                InfoCard(
                                  icon: Icons.flag_outlined,
                                  text: 'tăng cơ',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween, // Cải thiện cách phân bố không gian
                      children: [
                        Expanded(
                          child: InfoCard(
                            icon: Icons.monitor_weight_outlined,
                            text:
                                '${_weight.toStringAsFixed(1)} kg', // Format để hiển thị gọn hơn
                          ),
                        ),
                        SizedBox(width: 8.w), // Giảm width từ 10 xuống 8
                        Expanded(
                          child: InfoCard(
                            icon: Icons.boy,
                            text:
                                '${_height.toStringAsFixed(0)} cm', // Format để hiển thị gọn hơn
                          ),
                        ),
                        SizedBox(width: 8.w), // Giảm width từ 10 xuống 8
                        Expanded(
                          child: InfoCard(
                            icon: _isMale ? Icons.male : Icons.female,
                            text:
                                _age != null
                                    ? '$_age tuổi'
                                    : 'N/A', // Rút gọn "tuổi" thành "t" nếu cần
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cài đặt',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SettingsTile(
                            icon: Icons.edit,
                            title: 'Chỉnh sửa thông tin',
                            onTap: () async {
                              // Thêm async để có thể await
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditProfileScreen(
                                        authRepo: widget.authRepo,
                                      ),
                                ),
                              );

                              // Sau khi quay lại từ trang EditProfileScreen, tải lại dữ liệu
                              _loadUserData();
                            },
                          ),
                          SizedBox(height: 16.h),
                          SettingsTile(
                            icon: Icons.person_outline,
                            title: 'Cài đặt tài khoản',
                            onTap: () {},
                          ),
                          SizedBox(height: 16.h),
                          SettingsTile(
                            icon: Icons.settings,
                            title: 'Cài đặt ứng dụng',
                            onTap: () {},
                          ),
                          SizedBox(height: 16.h),
                          SettingsTile(
                            icon: Icons.feedback_outlined,
                            title: 'Nhận xét',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          SettingsTile(
                            icon: Icons.help_outline,
                            title: 'Hỗ trợ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SupportScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          SettingsTile(
                            icon: Icons.logout,
                            title: 'Đăng xuất',
                            onTap: () async {
                              await widget.authRepo.signOut();
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đăng xuất thành công!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
