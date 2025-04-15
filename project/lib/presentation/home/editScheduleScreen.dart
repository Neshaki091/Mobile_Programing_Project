import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/authentic_provider.dart';
import '../../routes/app_routes.dart'; // Ensure AppRoutes is imported
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditScheduleScreen extends StatelessWidget {
  final List<String> allExercises = [
    'Ngực',
    'Lưng',
    'Chân',
    'Vai',
    'Tay Trước',
    'Tay Sau',
    'Cẳng Tay',
    'Bụng',
  ];

  Future<void> _saveSchedule(BuildContext context) async {
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthenticProvider>(context, listen: false);
    final uid = authProvider.user?.uid;

    if (uid != null) {
      await workoutProvider.saveToFirestore(uid);
    }

    await workoutProvider.saveToLocal();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu lịch tập thành công!')),
    );
  }

  void _threaten(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("lời khuyên"),
          content: Text(
            "Bạn chỉ nên tập 3 đến 4 nhóm cơ một ngày để tránh sự mệt mỏi và quá tải lên cơ bắp của bạn",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),

              child: Text('Vâng tôi đã hiểu'),
            ),
          ],
        );
      },
    );
  } // Nếu đã chọn 4 nhóm cơ, không cho phép chọn thêm

  void _editExercises(BuildContext context, String day, List<String> selected) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelected = List.from(selected);

        return AlertDialog(
          title: Text('Chọn bài tập cho $day'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children:
                      allExercises.map((exercise) {
                        final isChecked = tempSelected.contains(exercise);
                        return CheckboxListTile(
                          value: isChecked,
                          title: Text(exercise),
                          onChanged: (value) {
                            setState(() {
                              if (value == true && tempSelected.length < 4) {
                                if (!tempSelected.contains(exercise)) {
                                  tempSelected.add(exercise);
                                }
                              } else if (value == false) {
                                tempSelected.remove(exercise);
                              } else {
                                _threaten(context);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WorkoutProvider>(
                  context,
                  listen: false,
                ).updateExercises(day, tempSelected);
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final schedule = workoutProvider.schedule;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                _saveSchedule(context);
                Navigator.pushNamed(context, AppRoutes.home);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.blue,
              ), // Replace 'icon' with a valid Icon widget
            ),
            SizedBox(width: 50.w),
            const Text(
              'Chỉnh sửa lịch tập',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final daySchedule = schedule[index];
          final isWeekend =
              daySchedule.day == 'SAT' || daySchedule.day == 'SUN';
          final isToday = DateTime.now().weekday == (index + 1);

          return InkWell(
            onTap:
                () => _editExercises(
                  context,
                  daySchedule.day,
                  daySchedule.exercises,
                ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      width: 50.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: Text(
                        daySchedule.day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isWeekend ? Colors.red : Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    if (daySchedule.exercises.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children:
                              daySchedule.exercises.map((ex) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isToday
                                            ? Colors.blue.shade700
                                            : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ex,
                                    style: TextStyle(
                                      color:
                                          isToday
                                              ? Colors.white
                                              : Colors.blue.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    if (daySchedule.exercises.isEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            'Tap to add or edit',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
