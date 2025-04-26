import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Biến lưu cài đặt
  String _themeMode = 'light'; // Tùy chọn: 'light', 'dark', 'system'
  bool _isMetricSystem = true; // true = kg/cm, false = lbs/inch
  bool _notificationsEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  // Tải cài đặt từ SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getString('themeMode') ?? 'light';
      _isMetricSystem = prefs.getBool('isMetricSystem') ?? true;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }
  
  // Lưu cài đặt vào SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode);
    await prefs.setBool('isMetricSystem', _isMetricSystem);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt ứng dụng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Chế độ hiển thị
            Text(
              'Chế độ hiển thị',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Chế độ sáng'),
                    value: 'light',
                    groupValue: _themeMode,
                    onChanged: (value) async {
                      setState(() {
                        _themeMode = value!;
                      });
                      await _saveSettings();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã chuyển sang chế độ sáng'))
                      );
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Chế độ tối'),
                    value: 'dark',
                    groupValue: _themeMode,
                    onChanged: (value) async {
                      setState(() {
                        _themeMode = value!;
                      });
                      await _saveSettings();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã chuyển sang chế độ tối'))
                      );
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Tự động theo hệ thống'),
                    value: 'system',
                    groupValue: _themeMode,
                    onChanged: (value) async {
                      setState(() {
                        _themeMode = value!;
                      });
                      await _saveSettings();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã chuyển sang chế độ tự động'))
                      );
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 2. Đơn vị đo lường
            Text(
              'Đơn vị đo lường',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Card(
              child: SwitchListTile(
                title: Text(_isMetricSystem ? 'Hệ mét (kg, cm)' : 'Hệ đo lường Anh (lbs, inch)'),
                subtitle: Text('Nhấn để chuyển đổi hệ đo lường'),
                value: _isMetricSystem,
                onChanged: (value) async {
                  setState(() {
                    _isMetricSystem = value;
                  });
                  await _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                      _isMetricSystem 
                        ? 'Đã chuyển sang hệ mét (kg, cm)'
                        : 'Đã chuyển sang hệ đo lường Anh (lbs, inch)'
                    ))
                  );
                },
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 3. Cài đặt thông báo
            Text(
              'Thông báo',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Bật thông báo'),
                    subtitle: Text(_notificationsEnabled 
                      ? 'Bạn sẽ nhận được nhắc nhở về lịch tập luyện'
                      : 'Bạn sẽ không nhận được nhắc nhở'),
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      await _saveSettings();
                    },
                  ),
                  
                  // Hiển thị cài đặt thời gian thông báo khi đã bật thông báo
                  if (_notificationsEnabled)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                      child: OutlinedButton(
                        child: Text('Đặt thời gian nhắc nhở'),
                        onPressed: () {
                          _showNotificationTimeDialog(context);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Hộp thoại cài đặt thời gian thông báo
  void _showNotificationTimeDialog(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 0); // Mặc định 18:00
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn thời gian nhắc nhở'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chọn thời gian bạn muốn nhận thông báo hàng ngày:'),
              SizedBox(height: 16.h),
              ElevatedButton(
                child: Text('${selectedTime.format(context)}'),
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  
                  if (picked != null) {
                    selectedTime = picked;
                    // Cần setState cho dialog để cập nhật UI
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () async {
                // Lưu thời gian đã chọn
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('notificationHour', selectedTime.hour);
                await prefs.setInt('notificationMinute', selectedTime.minute);
                
                // Đặt lại thông báo (cần triển khai riêng)
                // _scheduleNotification(selectedTime);
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã đặt thời gian nhắc nhở: ${selectedTime.format(context)}'))
                );
              },
            ),
          ],
        );
      },
    );
  }
}