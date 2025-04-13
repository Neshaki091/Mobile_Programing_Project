// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home_filled),
            color: currentIndex == 0 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(Icons.fitness_center),
            color: currentIndex == 1 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(1),
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            color: currentIndex == 2 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: Icon(Icons.emoji_events),
            color: currentIndex == 3 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(3),
          ),
          IconButton(
            icon: Icon(Icons.group),
            color: currentIndex == 4 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(4),
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: currentIndex == 4 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(4),
          ),
        ],
      ),
    );
  }
}
