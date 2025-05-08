import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/theme_provider.dart';
import 'package:project/providers/schedule_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Cài đặt ứng dụng'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        children: [
          _buildSectionTitle('Giao diện'),
          Card(
            child: Column(
              children: [
                _buildThemeRadio(
                  themeProvider,
                  ThemeMode.light,
                  'Sáng',
                  Icons.wb_sunny_outlined,
                ),
                _buildThemeRadio(
                  themeProvider,
                  ThemeMode.dark,
                  'Tối',
                  Icons.nightlight_outlined,
                ),
                _buildThemeRadio(
                  themeProvider,
                  ThemeMode.system,
                  'Theo hệ thống',
                  Icons.settings_brightness_outlined,
                ),
              ],
            ),
          ),

          _buildSectionTitle('Cài đặt Thông báo'),
          FutureBuilder(
            future: _getNotificationTimes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final times = snapshot.data as Map<String, int>;
              final morningHour = times['morningHour'] ?? 7;
              final morningMinute = times['morningMinute'] ?? 0;
              final afternoonHour = times['afternoonHour'] ?? 14;
              final afternoonMinute = times['afternoonMinute'] ?? 0;

              return Card(
                child: Column(
                  children: [
                    _buildTimePicker(
                      label: 'Giờ sáng',
                      initialHour: morningHour,
                      initialMinute: morningMinute,
                      onTimeChanged: (hour, minute) async {
                        await _saveNotificationTime('morningHour', hour);
                        await _saveNotificationTime('morningMinute', minute);
                        await scheduleProvider
                            .initialize(); // cập nhật lại thông báo
                      },
                    ),
                    _buildTimePicker(
                      label: 'Giờ chiều',
                      initialHour: afternoonHour,
                      initialMinute: afternoonMinute,
                      onTimeChanged: (hour, minute) async {
                        await _saveNotificationTime('afternoonHour', hour);
                        await _saveNotificationTime('afternoonMinute', minute);
                        await scheduleProvider
                            .initialize(); // cập nhật lại thông báo
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeRadio(
    ThemeProvider provider,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: provider.themeMode,
      onChanged: (ThemeMode? value) {
        if (value != null) {
          provider.setThemeMode(value);
        }
      },
      secondary: Icon(icon),
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

  Widget _buildTimePicker({
    required String label,
    required int initialHour,
    required int initialMinute,
    required Function(int, int) onTimeChanged,
  }) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        '${initialHour.toString().padLeft(2, '0')}:${initialMinute.toString().padLeft(2, '0')}',
      ),
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
        );
        if (newTime != null) {
          onTimeChanged(newTime.hour, newTime.minute);
        }
      },
    );
  }

  Future<void> _saveNotificationTime(String key, int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notification_schedule')
            .doc('schedule')
            .set(
              {key: value},
              SetOptions(merge: true),
            ); // merge true để không ghi đè các trường khác
      } catch (e) {
        debugPrint('Error saving notification time to Firestore: $e');
      }
    }
  }

  Future<Map<String, int>> _getNotificationTimes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('notification_schedule')
                .doc('schedule')
                .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          return {
            'morningHour': data['morningHour'] ?? 7,
            'morningMinute': data['morningMinute'] ?? 0,
            'afternoonHour': data['afternoonHour'] ?? 14,
            'afternoonMinute': data['afternoonMinute'] ?? 0,
          };
        } else {
          return {
            'morningHour': 7,
            'morningMinute': 0,
            'afternoonHour': 14,
            'afternoonMinute': 0,
          };
        }
      } catch (e) {
        debugPrint('Error fetching notification times from Firestore: $e');
        return {
          'morningHour': 7,
          'morningMinute': 0,
          'afternoonHour': 14,
          'afternoonMinute': 0,
        };
      }
    } else {
      return {
        'morningHour': 7,
        'morningMinute': 0,
        'afternoonHour': 14,
        'afternoonMinute': 0,
      };
    }
  }
}
