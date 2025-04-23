import 'package:flutter/material.dart';
import '../../data/models/workout_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Workout workout;

  const ExerciseDetailScreen({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Thêm nền tối cho dễ nhìn
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(workout.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 15.w,
                child: Text(
                  workout.name,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Nội dung chi tiết bài tập
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Độ khó: ${workout.level}",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                SingleChildScrollView(  // Cho phép cuộn nếu mô tả dài
                  child: Text(
                    workout.mota,
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    maxLines: 5, // Giới hạn số dòng nếu cần
                    overflow: TextOverflow.ellipsis, // Hiển thị dấu "..." nếu văn bản quá dài
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
