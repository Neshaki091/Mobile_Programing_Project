import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme.dart';
import '../../data/models/body_measurement.dart';
import 'package:project/data/models/user_model.dart';

// 1. Widget thông tin cơ bản
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
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }
}

// 2. Widget cài đặt
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 15.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: Colors.black),
            SizedBox(width: 10.w),
            Text(title, style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}

// 3. Widget chỉ số BMI
class BMICard extends StatelessWidget {
  final double bmi;
  final UserProfile? profile;
  final VoidCallback onEditProfile;

  BMICard({
    required this.bmi,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final weight = profile?.weight.toInt() ?? 0;
    final height = profile?.height.toInt() ?? 0;
    final age = profile?.age ?? 0;
    final gender = profile?.isMale == true ? "Male" : "Female";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text("Your BMI: ", style: TextStyle(fontSize: 16)),
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onEditProfile,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    bmi < 18.5
                        ? Colors.yellow
                        : bmi < 24.9
                        ? Colors.green
                        : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bmi < 18.5
                    ? "Underweight"
                    : bmi < 24.9
                    ? "Normal weight"
                    : bmi < 29.9
                    ? "Overweight"
                    : "Obesity",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoColumn("$weight kg", "Weight"),
                _infoColumn("$height cm", "Height"),
                _infoColumn("$age", "Age"),
                _infoColumn(gender, "Gender"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Widget đo cơ thể
class BodyMeasurementsCard extends StatelessWidget {
  final List<BodyMeasurement> bodyMeasurements;
  final VoidCallback onEditMeasurement;

  BodyMeasurementsCard({
    required this.bodyMeasurements,
    required this.onEditMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.straighten_outlined),
                SizedBox(width: 8),
                Text(
                  "Body Measurements",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onEditMeasurement,
                  child: Row(
                    children: [
                      Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.edit, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            bodyMeasurements.isEmpty
                ? Text(
                  "No body measurements yet",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
                : Column(
                  children:
                      bodyMeasurements.map((measurement) {
                        return _buildBodyMeasurementTile(measurement);
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyMeasurementTile(BodyMeasurement measurement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Body Measurement",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    measurement.date,
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMeasurementColumn('Chest', '${measurement.bust} cm'),
                _buildMeasurementColumn('Waist', '${measurement.waist} cm'),
                _buildMeasurementColumn('Hip', '${measurement.hip} cm'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
