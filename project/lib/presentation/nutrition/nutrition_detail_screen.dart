import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/nutrition_model.dart';

class NutritionDetailScreen extends StatelessWidget {
  final NutritionModel nutritionModel;

  const NutritionDetailScreen({Key? key, required this.nutritionModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                    image: NetworkImage(nutritionModel.food_imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Hiệu ứng fade mờ dần dưới ảnh
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),
                ),
              ),
              // Icon back
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
              // Tên món ăn
              Positioned(
                bottom: 20.h,
                left: 15.w,
                child: Text(
                  nutritionModel.foodName,
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

          // Nội dung dinh dưỡng
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calories: ${nutritionModel.calories}',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Protein: ${nutritionModel.nutrients.protein}g',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Carbohydrates: ${nutritionModel.nutrients.carbohydrates.total}g',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Fat: ${nutritionModel.nutrients.fat.total}g',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
