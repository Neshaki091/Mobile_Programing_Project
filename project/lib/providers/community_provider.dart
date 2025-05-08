import '../data/repositories/community_repository.dart';
import '../data/models/message.dart'; // Import NotificationService
class ChatService {
  final CommunityRepository _communityRepo =
      CommunityRepository(); // Khởi tạo NotificationService
  // Gửi tin nhắn
  Future<void> sendMessage(String text, String userId) async {
    await _communityRepo.sendMessage(text, userId);
  }

  // Lấy tất cả tin nhắn và lắng nghe tin nhắn mới
  Stream<List<Message>> getMessages() {
    return _communityRepo.getMessages();
  }
}
