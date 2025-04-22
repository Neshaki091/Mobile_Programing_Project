import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/workout_widget.dart';
import '../../widgets/appBar_widget.dart';
import '../../routes/app_routes.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 2;
  void onTap(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.workout);
        break;
      case 3:
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.community);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    Provider.of<WorkoutProvider>(context, listen: false).loadMyWorkouts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final myWorkouts =
        workoutProvider.myWorkouts; // Lấy danh sách "Bài tập của tôi"

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài tập'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả bài tập'),
            Tab(text: 'Bài tập yêu thích'),
            Tab(text: 'Bài tập của tôi'),
          ],
        ),
      ),
      body:
          workouts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Tab Tất cả bài tập
                  ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutItemWidget(
                        workout: workouts[index],
                        onAddToMyWorkouts: () {
                          // Thêm bài tập vào "Bài tập của tôi"
                          workoutProvider.addToMyWorkouts(workouts[index]);
                        },
                      );
                    },
                  ),
                  // Tab Bài tập yêu thích
                  ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutItemWidget(workout: workouts[index]);
                    },
                  ),
                  // Tab Bài tập của tôi
                  ListView.builder(
                    itemCount: myWorkouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutItemWidget(
                        workout: myWorkouts[index],
                        onRemoveFromMyWorkouts: () {
                          // Xóa bài tập khỏi "Bài tập của tôi"
                          workoutProvider.removeFromMyWorkouts(
                            myWorkouts[index],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
