import 'package:flutter/material.dart';

Widget createWidget(String tile, String content) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Thêm viền ngoài
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
      backgroundColor: Color.fromARGB(255, 205, 229, 255),
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/logo_image.png",
            height: 60,
            width: 80,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), // Độ cao của viền
          child: Container(
            color: Color.fromARGB(255, 172, 172, 172), // Màu viền
            height: 1, // Độ dày viền
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Căn giữa theo chiều dọc
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context, MaterialPageRoute(builder: (context) =>,)
                          // )
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 80,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 205, 255, 255),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text("Dinh Dưỡng"),
                        ),
                      ),
                      SizedBox(width: 30),
                      Icon(Icons.workspace_premium),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              createWidget("Thứ 2", "ngày 18/03"),
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
