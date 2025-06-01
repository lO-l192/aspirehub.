class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum MessageType {
  text,
  image,
  voice,
}
