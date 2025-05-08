import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá ứng dụng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 100.sp,
              ),
              SizedBox(height: 20.h),
              Text(
                'Hãy đánh giá chúng tôi 5 sao!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Sự ủng hộ của bạn là động lực lớn để chúng tôi phát triển.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              // Optional: Add actual rating buttons or link to store
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement link to App Store/Google Play if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
                  );
                  Navigator.pop(context); // Quay lại màn hình trước
                },
                icon: Icon(Icons.thumb_up_alt_outlined),
                label: Text('Đánh giá ngay'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}