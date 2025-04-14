import '../data/repositories/community_repository.dart';
import '../data/models/message.dart';
import '../data/models/user_model.dart';

class ChatService {
  final CommunityRepository _communityRepo = CommunityRepository();

  // Gửi tin nhắn
  Future<void> sendMessage(String text, String userId) async {
    await _communityRepo.sendMessage(text, userId);
  }

  // Lấy tất cả tin nhắn
  Stream<List<Message>> getMessages() {
    return _communityRepo.getMessages();
  }
}
