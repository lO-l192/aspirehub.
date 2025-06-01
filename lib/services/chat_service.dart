import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/chat_message.dart';

/// A service that manages chat data across the app.
/// This is a singleton class that can be accessed from anywhere in the app.
class ChatService extends ChangeNotifier {
  // Singleton instance
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal() {
    // Start with an empty chat list
  }

  // List of all chats
  final List<Chat> _chats = [];

  // Map of chat messages by chat ID
  final Map<String, List<ChatMessage>> _messages = {};

  // Getters
  List<Chat> get chats => List.unmodifiable(_chats);
  List<ChatMessage> getMessages(String chatId) =>
      List.unmodifiable(_messages[chatId] ?? []);

  // Add a new chat or get existing chat
  Chat getOrCreateChat(String userId, String userName, String userAvatar) {
    // Check if chat already exists
    final existingChat = _chats.where((chat) => chat.userId == userId).toList();
    if (existingChat.isNotEmpty) {
      return existingChat.first;
    }

    // Create a new chat
    final newChat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      lastMessageType: MessageType.text,
    );

    _chats.add(newChat);
    _messages[newChat.id] = [];
    notifyListeners();

    return newChat;
  }

  // Send a message
  void sendMessage(Chat chat, String content, MessageType type) {
    // Create a new message
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'company',
      receiverId: chat.userId,
      content: content,
      timestamp: DateTime.now(),
      type: type,
    );

    // Add message to chat
    final messages = _messages[chat.id] ?? [];
    messages.add(newMessage);
    _messages[chat.id] = messages;

    // Update chat with new last message
    final index = _chats.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      final updatedChat = Chat(
        id: chat.id,
        userId: chat.userId,
        userName: chat.userName,
        userAvatar: chat.userAvatar,
        lastMessage: content,
        lastMessageTime: DateTime.now(),
        isOnline: chat.isOnline,
        lastMessageType: type,
        isRead: false,
      );

      _chats[index] = updatedChat;

      // Move chat to top of list
      if (index > 0) {
        final movedChat = _chats.removeAt(index);
        _chats.insert(0, movedChat);
      }
    }

    notifyListeners();
  }

  // Simulate receiving a message
  void simulateReply(Chat chat, {int delaySeconds = 1}) {
    Future.delayed(Duration(seconds: delaySeconds), () {
      // Create a reply message
      final replyMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: chat.userId,
        receiverId: 'company',
        content: 'Thanks for your message. I\'ll get back to you soon!',
        timestamp: DateTime.now(),
        type: MessageType.text,
      );

      // Add message to chat
      final messages = _messages[chat.id] ?? [];
      messages.add(replyMessage);
      _messages[chat.id] = messages;

      // Update chat with new last message
      final index = _chats.indexWhere((c) => c.id == chat.id);
      if (index != -1) {
        final updatedChat = Chat(
          id: chat.id,
          userId: chat.userId,
          userName: chat.userName,
          userAvatar: chat.userAvatar,
          lastMessage: replyMessage.content,
          lastMessageTime: DateTime.now(),
          isOnline: chat.isOnline,
          lastMessageType: MessageType.text,
          isRead: false,
        );

        _chats[index] = updatedChat;

        // Move chat to top of list
        if (index > 0) {
          final movedChat = _chats.removeAt(index);
          _chats.insert(0, movedChat);
        }
      }

      // Notify listeners of the change to update UI
      notifyListeners();
    });
  }

  // Mark all messages in a chat as read
  void markChatAsRead(String chatId) {
    final messages = _messages[chatId] ?? [];
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].senderId != 'company') {
        messages[i] = ChatMessage(
          id: messages[i].id,
          senderId: messages[i].senderId,
          receiverId: messages[i].receiverId,
          content: messages[i].content,
          timestamp: messages[i].timestamp,
          type: messages[i].type,
          isRead: true,
        );
      }
    }

    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chats[index] = Chat(
        id: _chats[index].id,
        userId: _chats[index].userId,
        userName: _chats[index].userName,
        userAvatar: _chats[index].userAvatar,
        lastMessage: _chats[index].lastMessage,
        lastMessageTime: _chats[index].lastMessageTime,
        isOnline: _chats[index].isOnline,
        lastMessageType: _chats[index].lastMessageType,
        isRead: true,
      );
    }

    notifyListeners();
  }

  // Delete a chat
  void deleteChat(String chatId) {
    // Remove chat from list
    _chats.removeWhere((chat) => chat.id == chatId);

    // Remove messages for this chat
    _messages.remove(chatId);

    // Notify listeners of the change
    notifyListeners();
  }

  // Delete multiple chats
  void deleteChats(List<String> chatIds) {
    // Remove chats from list
    _chats.removeWhere((chat) => chatIds.contains(chat.id));

    // Remove messages for these chats
    for (final chatId in chatIds) {
      _messages.remove(chatId);
    }

    // Notify listeners of the change
    notifyListeners();
  }
}
