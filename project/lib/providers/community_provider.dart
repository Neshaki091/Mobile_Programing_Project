import 'package:firebase_auth/firebase_auth.dart';
import '../providers/authentic_provider.dart';
import '../data/repositories/community_repository.dart';
import '../data/models/message.dart';

class ChatService {
  final CommunityRepository _communityRepo = CommunityRepository();
  final AuthenticProvider _authenticProvider = AuthenticProvider();
  // Gửi tin nhắn
  Future<void> sendMessage(String text, String receiverId) async {
    // Gửi tin nhắn đến người nhận
    final currentUserId =
        FirebaseAuth
            .instance
            .currentUser!
            .uid; // Giả sử bạn có phương thức để lấy ID người dùng hiện tại
    await _communityRepo.sendMessage(text, receiverId, currentUserId);
  }

  // Lấy tất cả tin nhắn
  Stream<List<Message>> getMessages(String userId) {
    // Lấy tất cả tin nhắn theo userId
    return _communityRepo.getMessages(userId);
  }
}
