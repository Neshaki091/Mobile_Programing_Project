class Message {
  final String text;
  final String userId;
  final int timestamp;
  final String name;
  final String avatarUrl;

  Message({
    required this.text,
    required this.userId,
    required this.timestamp,
    this.name = '', // Mặc định giá trị name là rỗng
    this.avatarUrl = '', // Mặc định giá trị avatarUrl là rỗng nếu không có
  });

  // Factory constructor để tạo Message từ dữ liệu từ database
  factory Message.fromDatabase(Map<String, dynamic> data) {
    print("Message từ DB: $data");
    return Message(
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? 0,
      name: data['name'] ?? 'N/A',
      avatarUrl:
          data['avatarUrl'] ?? '', // Đảm bảo avatarUrl có giá trị mặc định
    );
  }

  // Chuyển đối tượng Message thành Map để lưu vào database
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'timestamp': timestamp,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}
