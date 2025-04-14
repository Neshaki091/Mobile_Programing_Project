import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/message.dart';
import '../repositories/auth_repository.dart';

class CommunityRepository {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref(
    'messages',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepo = AuthRepository();

  /// Gửi tin nhắn mới
  Future<void> sendMessage(String text, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newMessageRef = _messagesRef.push();

      // Lấy thông tin người dùng
      final userProfile = await _authRepo.getUserProfile(
        userId,
      ); // Đảm bảo lấy thông tin người dùng đúng cách
      final currentUser = _auth.currentUser;

      // Tạo tin nhắn
      final message = {
        'text': text.trim(),
        'userId': userId,
        'timestamp': timestamp,
        'name': userProfile?.name ?? currentUser?.displayName ?? 'Người dùng',
        'avatarUrl': currentUser?.photoURL ?? userProfile?.avatarUrl ?? '',
      };

      // Lưu tin nhắn vào Firebase
      await newMessageRef.set(message);
    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }

  /// Lấy danh sách tin nhắn theo thời gian thực (Stream)
  Stream<List<Message>> getMessages() {
    return _messagesRef.orderByChild('timestamp').onValue.map((event) {
      final messages = <Message>[];

      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final rawMap = Map<String, dynamic>.from(data);
        rawMap.forEach((key, value) {
          try {
            final messageMap = Map<String, dynamic>.from(value);
            final message = Message.fromDatabase(messageMap);
            messages.add(message);
          } catch (e) {
            print("Lỗi khi chuyển đổi dữ liệu tin nhắn: $e");
          }
        });

        // Sắp xếp từ mới nhất đến cũ nhất
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return messages;
    });
  }
}
