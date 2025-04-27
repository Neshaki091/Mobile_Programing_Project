import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import '../../data/models/message.dart';
import '../../data/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final UserProfile friend;

  const ChatScreen({
    required this.currentUser,
    required this.friend,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DatabaseReference _chatRef;
  late String chatRoomId;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    chatRoomId = _getChatRoomId(widget.currentUser.uid, widget.friend.uid);
    _chatRef = FirebaseDatabase.instance.ref('private_chats/$chatRoomId');
    _listenToMessages();

    // Firebase Messaging setup
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Khi có thông báo đến, bạn có thể làm gì đó (ví dụ cuộn xuống hoặc hiển thị thông báo)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.body ?? 'Có tin nhắn mới'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  String _getChatRoomId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }

  void _listenToMessages() {
    _chatRef.orderByChild('timestamp').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final List<Message> loaded = [];
        data.forEach((key, value) {
          final msgMap = Map<String, dynamic>.from(value);
          final message = Message.fromDatabase(msgMap);
          loaded.add(message);
        });
        loaded.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        setState(() => messages = loaded);
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final text = _controller.text.trim();
    _controller.clear();

    final message = {
      'text': text,
      'userId': widget.currentUser.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': widget.currentUser.displayName ?? 'Bạn',
      'avatarUrl': widget.currentUser.photoURL ?? '',
    };

    _chatRef.push().set(message);

    // Auto scroll
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMe = (String id) => id == widget.currentUser.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Chat với ${widget.friend.name}')),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? Center(child: Text('Hãy bắt đầu cuộc trò chuyện...'))
                    : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final mine = isMe(message.userId);
                        return Align(
                          alignment:
                              mine
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: mine ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mine ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: mine ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
