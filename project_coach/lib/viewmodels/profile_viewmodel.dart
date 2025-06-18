import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 24),
            // Info section
            buildInfoRow('Chiều cao', '${user.height} cm'),
            buildInfoRow('Cân nặng', '${user.weight} kg'),
            if (user.age != null) buildInfoRow('Tuổi', '${user.age}'),
            buildInfoRow('Giới tính', user.isMale ? 'Nam' : 'Nữ'),

            const Divider(height: 32),

            // Lists
            buildInfoRow('Số bạn bè', '${user.friends.length}'),
            buildInfoRow('Bài tập yêu thích', '${user.favorites.length}'),
            buildInfoRow('Bài tập của tôi', '${user.myWorkouts.length}'),

            const Divider(height: 32),

            // Notification time
            Text(
              'Lịch thông báo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Buổi sáng: ${user.morningHour}h${user.morningMinute.toString().padLeft(2, '0')}'),
            Text('Buổi chiều: ${user.afternoonHour}h${user.afternoonMinute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
