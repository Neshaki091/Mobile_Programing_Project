import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/message.dart';
import '../../data/models/user_model.dart';
import 'package:http/http.dart' as http;

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DatabaseReference _chatRef;
  late String chatRoomId;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    chatRoomId = _getChatRoomId(widget.currentUser.uid, widget.friend.uid);
    print("friendId: ${widget.friend.uid}");
    _chatRef = FirebaseDatabase.instance.ref('private_chats/$chatRoomId');
    _listenToMessages();
  }

  String _getChatRoomId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }

  Future<String?> _getFriendFcmToken(String friendId) async {
    try {
      final doc = await _firestore.collection('users').doc(friendId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['fcmToken'];
        print("FCM token của bạn bè: ${data?['fcmToken']}");
      }
    } catch (e) {
      print('Lỗi khi lấy FCM token của bạn bè: $e');
    }
    return null;
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

        if (mounted) {
          setState(() => messages = loaded);
        }
      }
    });
  }

  Future<void> _sendMessage() async {
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

    await _sendPushNotification(message);

    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String> getServerUrl() async {
    final doc = await _firestore.collection('config').doc('server').get();
    if (doc.exists) {
      final data = doc.data();
      return data?['url'];
    }
    final serverUrl = doc.data()?['url'];
    print("Server URL: $serverUrl");
    return serverUrl;
  }

  Future<void> _sendPushNotification(Map<String, dynamic> message) async {
    try {
      final String? friendFcmToken = await _getFriendFcmToken(
        widget.friend.uid,
      );

      final String title =
          'Tin nhắn mới từ ${widget.currentUser.displayName ?? 'Bạn'}';
      final String bodyText = message['text'];
      final serverUrl = await getServerUrl();
      final bodyData = {
        "fcmToken": friendFcmToken,
        "title": title,
        "body": bodyText,
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "chat_room_id": chatRoomId,
        },
      };

      final response = await http.post(
        Uri.parse('$serverUrl/send-notification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        print("Thông báo đã gửi thành công");
      } else {
        print("Lỗi gửi FCM: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi gửi push notification: $e");
    }
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
