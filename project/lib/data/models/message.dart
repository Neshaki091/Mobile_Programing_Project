class Message {
  final String text;
  final String userId;
  final int timestamp;
  final String name;
  final String avatarUrl; // Thêm trường imageUrl nếu cần thiết
  Message({
    required this.text,
    required this.userId,
    required this.timestamp,
    this.name = '',
    required this.avatarUrl, // Khởi tạo trường name với giá trị mặc định
  });

  factory Message.fromDatabase(Map<String, dynamic> data) {
    print("Message từ DB: $data");
    return Message(
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? 0,
      name: data['name'] ?? 'N/A',
      avatarUrl: data['avatarUrl'], // Lấy giá trị từ trường name trong dữ liệu
    );
  }
}
