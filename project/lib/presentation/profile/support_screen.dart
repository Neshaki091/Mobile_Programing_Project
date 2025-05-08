import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỗ trợ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: ListView( // Sử dụng ListView để dễ dàng thêm nội dung
          children: [
            Text(
              'Liên hệ với chúng tôi',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('Email hỗ trợ'),
              subtitle: Text('support@fitnessapp.com'), // Thay bằng email thật
              onTap: () {
                
              },
            ),
            ListTile(
              leading: Icon(Icons.phone_outlined),
              title: Text('Hotline'),
              subtitle: Text('0123 456 789'), // Thay bằng số điện thoại thật
              onTap: () {
                
              },
            ),
            Divider(height: 30.h),
            Text(
              'Câu hỏi thường gặp (FAQs)',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: Icon(Icons.help_center_outlined),
              title: Text('Truy cập trang FAQs'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                // TODO: Implement opening FAQs link
              },
            ),
            
          ],
        ),
      ),
    );
  }
}