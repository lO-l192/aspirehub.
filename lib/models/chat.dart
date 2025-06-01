import 'chat_message.dart';

class Chat {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isOnline;
  final MessageType lastMessageType;
  final bool isRead;

  Chat({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isOnline = false,
    required this.lastMessageType,
    this.isRead = false,
  });
}
