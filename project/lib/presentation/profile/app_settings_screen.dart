import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/theme_provider.dart';

class AppSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt ứng dụng'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        children: [
          _buildSectionTitle('Giao diện'),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text('Sáng'),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                  secondary: Icon(Icons.wb_sunny_outlined),
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Tối'),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                  secondary: Icon(Icons.nightlight_outlined),
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Theo hệ thống'),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                  secondary: Icon(Icons.settings_brightness_outlined),
                ),
              ],
            ),
          ),
          // Các cài đặt khác nếu cần
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}