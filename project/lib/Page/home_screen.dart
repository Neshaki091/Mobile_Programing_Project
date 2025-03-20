import 'package:flutter/material.dart';

Widget createWidget(String tile, String content) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Thêm viền ngoài
    ),
    child: Row(
      children: [
        // Phần "THU" với đường viền phải
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey, width: 1), // Viền phải
            ),
          ),
          child: Text(
            tile,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(width: 12), // Khoảng cách giữa 2 phần
        // Phần "Vai" với viền bo góc
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(12), // Viền xanh xung quanh
          ),
          child: Text(content, style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            "assets/images/logo_image.png",
            height: 30,
            width: 40,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Căn giữa theo chiều dọc
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: EdgeInsets.all(20),
                    ),
                    child: Text("Dinh Dưỡng"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              createWidget("Thứ 2", "ngày 18/03"),
              createWidget("Thứ 3", "ngày 19/03"),
              createWidget("Thứ 4", "ngày 20/03"),
              createWidget("Thứ 5", "ngày 21/03"),
              createWidget("Thứ 6", "ngày 22/03"),
            ],
          ),
        ),
      ),
    );
  }
}
