import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/nutrition_viewmodel.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../models/workout_model.dart';
import '../models/nutrition_model.dart';
import '../models/user_model.dart';
import 'widget/addNutrition.dart';
import 'widget/addWorkout.dart';
import 'learner_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile currentUser;

  const HomeScreen({super.key, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      Provider.of<WorkoutViewModel>(context, listen: false).fetchWorkouts();
      Provider.of<NutritionViewModel>(context, listen: false).fetchNutritionData();
    });
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Dễ':
        return Colors.green;
      case 'Trung bình':
        return Colors.orange;
      case 'Khó':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildWorkoutCard(WorkoutModel workout) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(workout.imageUrl),
          backgroundColor: Colors.black26,
        ),
        title: Text(
          workout.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Chip(
          label: Text(workout.level),
          backgroundColor: _getLevelColor(workout.level),
        ),
      ),
    );
  }

  Widget _buildNutritionCard(NutritionModel nutrition) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(nutrition.food_imageUrl),
          backgroundColor: Colors.black26,
        ),
        title: Text(
          nutrition.foodName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${nutrition.calories} kcal / 100 gram'),
      ),
    );
  }

  Widget _buildTabContent() {
    final workoutVM = Provider.of<WorkoutViewModel>(context);
    final nutritionVM = Provider.of<NutritionViewModel>(context);

    if (_tabController.index == 0) {
      if (workoutVM.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (workoutVM.errorMessage != null) {
        return Center(child: Text(workoutVM.errorMessage!));
      }
      if (workoutVM.myWorkouts.isEmpty) {
        return const Center(child: Text("Không có bài tập nào."));
      }
      return ListView(
        children: workoutVM.myWorkouts.map(_buildWorkoutCard).toList(),
      );
    } else {
      if (nutritionVM.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (nutritionVM.errorMessage != null) {
        return Center(child: Text(nutritionVM.errorMessage!));
      }
      if (nutritionVM.nutritionList.isEmpty) {
        return const Center(child: Text("Không có dữ liệu dinh dưỡng."));
      }
      return ListView(
        children: nutritionVM.nutritionList.map(_buildNutritionCard).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_image.png', height: 32),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (_) => setState(() {}),
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Bài tập luyện'),
                    Tab(text: 'Dinh dưỡng'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddWorkoutScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNutritionScreen()),
            );
          }
        },
      ),
      // Bạn có thể bật lại nếu cần:
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() => _selectedIndex = index);
      //     if (index == 1) {
      //       Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnerScreen()));
      //     } else if (index == 2) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (_) => ProfileScreen(user: widget.currentUser)),
      //       );
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Learner'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}
