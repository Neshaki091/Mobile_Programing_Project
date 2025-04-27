import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutName;
  final String workoutTime;
  final List<Exercise> exercises;

  const WorkoutDetailScreen({
    Key? key,
    required this.workoutName,
    required this.workoutTime,
    required this.exercises,
  }) : super(key: key);

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  int _currentExerciseIndex = 0;
  bool _workoutCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết bài tập"),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showWorkoutTips,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkoutHeader(),
            SizedBox(height: 20.h),
            _buildExerciseList(),
            SizedBox(height: 30.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.workoutTime,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Chi tiết bài tập",
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          widget.workoutName,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.timer, size: 16.sp, color: Colors.grey),
            SizedBox(width: 4.w),
            Text(
              "Trung bình ${_calculateTotalTime()} phút",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    return Column(
      children: [
        Text(
          "Exercises (${widget.exercises.length})",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        ...widget.exercises.map((exercise) => _buildExerciseCard(exercise)).toList(),
      ],
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: exercise.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      exercise.isCompleted = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "${exercise.sets} sets x ${exercise.reps} reps",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            if (exercise.notes != null) ...[
              SizedBox(height: 8.h),
              Text(
                exercise.notes!,
                style: TextStyle(fontSize: 14.sp, color: Colors.blue),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_workoutCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: _completeWorkout,
              child: Text(
                "Bắt Đầu",
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _resetWorkout,
            child: Text(
              "Bắt Đầu Lại",
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _workoutCompleted ? null : _completeWorkout,
            child: Text(
              "Hoàn Thành",
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
      ],
    );
  }

  String _calculateTotalTime() {
    // Giả sử mỗi bài tập mất 3 phút
    return (widget.exercises.length * 3).toString();
  }

  void _completeWorkout() {
    setState(() {
      _workoutCompleted = true;
      for (var exercise in widget.exercises) {
        exercise.isCompleted = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Chúc mừng! Bạn đã hoàn thành bài tập")),
    );
  }

  void _resetWorkout() {
    setState(() {
      _workoutCompleted = false;
      for (var exercise in widget.exercises) {
        exercise.isCompleted = false;
      }
    });
  }

  void _showWorkoutTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Mẹo tập luyện"),
        content: Text("Chọn mức tạ phù hợp với khả năng. Lắng nghe cơ thể và điều chỉnh khi cần thiết."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }
}

class Exercise {
  String name;
  int sets;
  int reps;
  bool isCompleted;
  String? notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.isCompleted = false,
    this.notes,
  });
}

// Cách sử dụng:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => WorkoutDetailScreen(
//       workoutName: "Bài tập ngực",
//       workoutTime: "9:30",
//       exercises: [
//         Exercise(name: "Machine Chest Fly", sets: 3, reps: 12),
//         Exercise(name: "Barbell Bench Press", sets: 3, reps: 8),
//         Exercise(name: "Incline Dumbbell Press", sets: 3, reps: 10),
//         Exercise(name: "Dips", sets: 3, reps: 10),
//       ],
//     ),
//   ),
// );