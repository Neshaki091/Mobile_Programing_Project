import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme.dart';

// widget info card
class InfoCard extends StatelessWidget {
  final IconData? icon;
  final String text;

  const InfoCard({super.key, this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.infoCard,
        borderRadius: BorderRadius.circular(12).r,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child:
            icon != null
                ? Row(
                  children: [
                    Icon(icon, size: 24.sp, color: Colors.black),
                    SizedBox(width: 10.w),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,  
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }
}

// widget settings
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy màu từ theme hiện tại
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.darkCardColor : Colors.white;
    final textColor = isDarkMode ? AppColors.light : Colors.black;
    final iconColor = isDarkMode ? AppColors.light : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 15.r),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          // Thêm đường viền mỏng trong dark mode để tạo contrast
          border: isDarkMode 
              ? Border.all(color: Colors.grey[700]!, width: 0.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: iconColor),
            SizedBox(width: 10.w),
            Text(
              title, 
              style: TextStyle(
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}