import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../providers/authentic_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../routes/app_routes.dart';
import '../../firebase_service.dart';
import 'editScheduleScreen.dart';
import '../../widgets/appBar_widget.dart'; // Đã sửa import nếu cần
// ✅ Import thêm nếu chưa có

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseService _firebaseService;
  late Future<List<Map<String, String>>> _productsFuture;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _productsFuture = _firebaseService.getProducts();
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthenticProvider authProvider,
  ) async {
    await authProvider.signOut();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  void onTap(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        // Ở Home rồi
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticProvider>(context);
    final user = authProvider.user;

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          return true;
        } else {
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child:
                    user?.photoURL != null
                        ? Image.network(
                          user!.photoURL!,
                          width: 30.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          "assets/images/default-avatar.png",
                          width: 30.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
              ),
              Image.asset(
                "assets/images/logo_image.png",
                width: 60.w,
                height: 40.h,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.list),
                onSelected: (value) {
                  if (value == "2") {
                    _handleLogout(context, authProvider);
                  } else if (value == "1") {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.profile,
                      arguments: authProvider.authRepo,
                    );
                  }
                },
                itemBuilder:
                    (context) => const [
                      PopupMenuItem(value: "1", child: Text("Trang cá nhân")),
                      PopupMenuItem(value: "2", child: Text("Đăng xuất")),
                    ],
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 245, 245, 245),
          child: SafeArea(
            child: Column(
              children: [
                InkWell(
                  onTap:
                      () => Navigator.pushNamed(context, AppRoutes.nutrition),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 20.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 179, 221, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Dinh Dưỡng",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Lịch tập của bạn:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditScheduleScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      "Chỉnh Sửa",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.mode_edit_outlined,
                                      color: Colors.grey,
                                      size: 20.w,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Consumer<WorkoutProvider>(
                            builder: (context, workoutProvider, _) {
                              return Table(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(
                                    width: 0.2.w,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                columnWidths: {
                                  0: FixedColumnWidth(60.w),
                                  1: FlexColumnWidth(),
                                },
                                children:
                                    workoutProvider.schedule
                                        .map(
                                          (item) => buildScheduleRow(
                                            item.day,
                                            item.exercises,
                                          ),
                                        )
                                        .toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Thực phẩm bổ sung',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                FutureBuilder<List<Map<String, String>>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có sản phẩm'));
                    }

                    final products = snapshot.data!;

                    return Container(
                      height: 180.h,
                      child: ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 20.h,
                            ),
                            elevation: 3,
                            child: ListTile(
                              leading: Image.network(product['imageUrl']!),
                              title: Text(product['name']!),
                              subtitle: Text(
                                product['description'] ?? 'Không có mô tả',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  TableRow buildScheduleRow(String day, List<String> exercises) {
    final bool _isToday = DateTime.now().weekday == _dayIndex(day);
    final isWeekend = (day == 'SAT' || day == 'SUN');

    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 4.h),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 2.h),
            decoration: BoxDecoration(
              color:
                  _isToday
                      ? const Color.fromARGB(255, 134, 204, 255)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isWeekend ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
          child:
              exercises.isNotEmpty
                  ? Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: _isToday ? Colors.blue : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 10.w,
                      children:
                          exercises.map((e) {
                            return Text(
                              e,
                              style: TextStyle(
                                color: _isToday ? Colors.white : Colors.black,
                                fontSize: 13.sp,
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : SizedBox.shrink(),
        ),
      ],
    );
  }

  int _dayIndex(String day) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days.indexOf(day) + 1;
  }
}
