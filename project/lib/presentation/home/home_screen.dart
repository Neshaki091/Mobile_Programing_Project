import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentic_provider.dart';
import '../../routes/app_routes.dart';
import '../../firebase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseService _firebaseService;
  late Future<List<Map<String, String>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _productsFuture = _firebaseService.getProducts(); // Gọi hàm getProducts
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthenticProvider authProvider,
  ) async {
    await authProvider.logout();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticProvider>(context);
    final user = authProvider.user;

    return Scaffold(
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
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        "assets/images/default-avatar.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
            ),
            Image.asset("assets/images/logo_image.png", width: 60, height: 40),
            PopupMenuButton<String>(
              icon: const Icon(Icons.list),
              onSelected: (value) {
                if (value == "2") {
                  _handleLogout(context, authProvider);
                } else if (value == "1") {}
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
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Lịch tập của bạn:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 100),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "Chỉnh Sửa",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Icon(
                              Icons.mode_edit_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(
                              width: 0.2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(60),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            buildScheduleRow('MON', ['Ngực']),
                            buildScheduleRow('TUE', ['Lưng']),
                            buildScheduleRow('WED', ['Chân']),
                            buildScheduleRow('THU', ['Vai']),
                            buildScheduleRow('FRI', ['Tay Trước', 'Cẳng Tay']),
                            buildScheduleRow('SAT', ['Tay Sau']),
                            buildScheduleRow('SUN', []),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Thực phẩm bổ sung',
                style: TextStyle(
                  fontSize: 20,
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
                    height: 180,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20,
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
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 60,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home_filled),
              onPressed: () {
                // Hành động cho Home
              },
            ),
            IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                // Hành động cho Search
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {
                // Hành động cho Notifications
              },
            ),
            IconButton(
              icon: Icon(Icons.emoji_events),
              onPressed: () {
                // Hành động cho Notifications
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Hành động cho Account
              },
            ),
          ],
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
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            decoration: BoxDecoration(
              color:
                  _isToday
                      ? const Color.fromARGB(255, 134, 204, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isWeekend ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          child:
              exercises.isNotEmpty
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _isToday ? Colors.blue : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          exercises.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: _isToday ? Colors.white : Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  int _dayIndex(String day) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days.indexOf(day) + 1;
  }
}
