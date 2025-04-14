import 'package:flutter/material.dart';
import '..//workouts/workout_detail_screen.dart';

class EmptyPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;

  const EmptyPage({
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
  });

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  bool isFavorited = false; // State to track if the heart button has been pressed

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight / 3), // Height = 1/3 of the screen
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 16, bottom: 16),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: isFavorited ? Colors.red : Colors.white, // Change color based on state
              ),
              onPressed: () {
                setState(() {
                  isFavorited = !isFavorited; // Toggle state
                });
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nội dung của: ${widget.title}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              "Mô tả : Bài tập Gập người kéo tạ đòn là một bài tập "
              "phức hợp chủ yếu tác động vào các nhóm cơ ở lưng trên, "
              "đặc biệt là cơ xô, cơ cầu vai và cơ trám. "
              "Nó cũng kích hoạt cơ tay trước và cẳng tay như các nhóm cơ phụ. ",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
