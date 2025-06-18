import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'learner_screen.dart';
import 'profile_screen.dart';
import '../models/user_model.dart'; // bạn cần import file này

class MainScreen extends StatefulWidget {
  final UserProfile currentUser; // thêm dòng này

  const MainScreen({Key? key, required this.currentUser}) : super(key: key); // sửa constructor

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // truyền currentUser vào các màn hình cần
    final List<Widget> _screens = [
      HomeScreen(currentUser: widget.currentUser),
      const LearnerScreen(),
      ProfileScreen(user: widget.currentUser),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Học viên',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
