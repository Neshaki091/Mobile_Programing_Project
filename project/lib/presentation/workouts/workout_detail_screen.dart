import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async'; // Import cho Timer

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
  bool _workoutCompleted = false;
  bool _workoutInProgress = false;
  
  // Các biến cho timer
  late Timer _timer;
  int _timerSeconds = 0;
  int _totalSeconds = 0;
  String _timerDisplay = '00:00';

  @override
  void initState() {
    super.initState();
    // Chuyển đổi workoutTime từ chuỗi sang số giây
    _convertWorkoutTimeToSeconds();
  }

  @override
  void dispose() {
    // Hủy timer khi widget bị hủy để tránh memory leak
    if (_workoutInProgress) {
      _timer.cancel();
    }
    super.dispose();
  }

  // Chuyển đổi workoutTime sang số giây
  void _convertWorkoutTimeToSeconds() {
    try {
      String timeStr = widget.workoutTime.trim();
      
      // Nếu rỗng hoặc null, sử dụng mặc định
      if (timeStr.isEmpty) {
        _totalSeconds = 15 * 60; // 15 phút mặc định
        return;
      }
      
      // Kiểm tra định dạng "mm:ss"
      if (timeStr.contains(':')) {
        List<String> timeParts = timeStr.split(':');
        int minutes = int.parse(timeParts[0].trim());
        int seconds = int.parse(timeParts[1].trim());
        _totalSeconds = minutes * 60 + seconds;
      } 
      // Kiểm tra nếu có chữ "phút" hoặc "min"
      else if (timeStr.contains('phút') || timeStr.contains('min')) {
        // Loại bỏ các ký tự không phải số
        String numStr = timeStr.replaceAll(RegExp(r'[^0-9]'), '');
        _totalSeconds = int.parse(numStr) * 60;
      }
      // Giả sử chỉ là số phút
      else {
        _totalSeconds = int.parse(timeStr) * 60;
      }
      
      // Đặt giới hạn hợp lý
      if (_totalSeconds <= 0) {
        _totalSeconds = 15 * 60; // 15 phút nếu giá trị không hợp lệ
      }
      
      print('Đã chuyển đổi "$timeStr" thành $_totalSeconds giây');
    } catch (e) {
      // Sử dụng thời gian mặc định
      _totalSeconds = 15 * 60; // 15 phút
      print('Lỗi khi chuyển đổi thời gian: $e, sử dụng mặc định 15 phút');
    }
    
    // Cập nhật hiển thị ngay sau khi chuyển đổi
    _timerSeconds = _totalSeconds;
    _updateTimerDisplay();
  }

  // Bắt đầu timer đếm ngược
  void _startTimer() {
    setState(() {
      _workoutInProgress = true;
      _timerSeconds = _totalSeconds;
      _updateTimerDisplay();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
          _updateTimerDisplay();
        } else {
          _timer.cancel();
          _workoutInProgress = false;
          _workoutCompleted = true;
          _showWorkoutCompletedDialog();
        }
      });
    });
  }

  // Cập nhật hiển thị bộ đếm thời gian
  void _updateTimerDisplay() {
    int minutes = _timerSeconds ~/ 60;
    int seconds = _timerSeconds % 60;
    _timerDisplay = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Dừng timer
  void _stopTimer() {
    if (_workoutInProgress) {
      _timer.cancel();
      setState(() {
        _workoutInProgress = false;
      });
    }
  }

  // Hiển thị thông báo khi bài tập hoàn thành
  void _showWorkoutCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chúc mừng!'),
          content: Text('Bạn đã hoàn thành bài tập.'),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            if (_workoutInProgress) _buildTimerDisplay(),
            SizedBox(height: 20.h),
            _buildExerciseList(),
            SizedBox(height: 30.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị timer khi đang tập
  Widget _buildTimerDisplay() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Thời gian còn lại',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _timerDisplay,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _workoutInProgress ? _stopTimer : _startTimer,
                icon: Icon(_workoutInProgress ? Icons.pause : Icons.play_arrow),
                label: Text(_workoutInProgress ? 'Tạm dừng' : 'Tiếp tục'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
              ),
              SizedBox(width: 16.w),
              OutlinedButton.icon(
                onPressed: () {
                  _stopTimer();
                  setState(() {
                    _timerSeconds = _totalSeconds;
                    _updateTimerDisplay();
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text('Đặt lại'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
              ),
            ],
          ),
        ],
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
        if (!_workoutInProgress && !_workoutCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: _startTimer, // Sử dụng _startTimer thay vì _completeWorkout
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
            onPressed: _workoutCompleted || _workoutInProgress ? null : _completeWorkout,
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
    if (_workoutInProgress) {
      _stopTimer();
    }
    
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
    if (_workoutInProgress) {
      _stopTimer();
    }
    
    setState(() {
      _workoutInProgress = false;
      _workoutCompleted = false;
      _timerSeconds = _totalSeconds;
      _updateTimerDisplay();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• Chọn mức tạ phù hợp với khả năng"),
            SizedBox(height: 4.h),
            Text("• Tập trung vào form đúng hơn là tạ nặng"),
            SizedBox(height: 4.h),
            Text("• Nghỉ đủ 1-2 phút giữa các set"),
            SizedBox(height: 4.h),
            Text("• Uống nước đầy đủ trong quá trình tập"),
            SizedBox(height: 4.h),
            Text("• Lắng nghe cơ thể và điều chỉnh khi cần thiết"),
          ],
        ),
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