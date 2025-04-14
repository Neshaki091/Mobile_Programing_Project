import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/presentation/profile/EditProfileScreen.dart';
import 'package:project/widgets/info_card.dart';

final user = FirebaseAuth.instance.currentUser;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
                        user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : AssetImage(
                                  '../../../assets/images/profile_placeholder.png',
                                )
                                as ImageProvider,
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'John Doe',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "@${user?.email ?? 'johndoe@example.com'}",
                          style: TextStyle(fontSize: 14.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        InfoCard(icon: Icons.flag_outlined, text: 'tăng cơ'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: InfoCard(icon: Icons.flag_outlined, text: '60kg'),
                ),
                SizedBox(width: 10.w),
                Expanded(child: InfoCard(icon: Icons.boy, text: '165cm')),
                SizedBox(width: 10.w),
                Expanded(child: InfoCard(icon: Icons.male, text: '21 tuổi')),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cài đặt',
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  SettingsTile(
                    icon: Icons.edit,
                    title: 'Chỉnh sửa thông tin',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      );
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
                    onTap: () {},
                  ),
                  SizedBox(height: 16.h),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Hỗ trợ',
                    onTap: () {},
                  ),
                  SizedBox(height: 16.h),
                  SettingsTile(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      // Navigate to login screen or home screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}