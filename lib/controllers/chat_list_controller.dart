import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';

/// Controller for the chat list screen.
/// This separates the business logic from the UI.
class ChatListController extends ChangeNotifier {
  // Chat service
  final ChatService _chatService = ChatService();
  
  // Edit mode state
  bool _isEditMode = false;
  final Set<String> _selectedChats = {};
  
  // Getters
  bool get isEditMode => _isEditMode;
  Set<String> get selectedChats => Set.unmodifiable(_selectedChats);
  List<Chat> get chats => _chatService.chats;
  bool get hasSelectedChats => _selectedChats.isNotEmpty;
  
  // Constructor
  ChatListController() {
    // Listen for changes to the chat service
    _chatService.addListener(_onChatServiceChanged);
  }
  
  // Dispose
  @override
  void dispose() {
    // Remove listener when controller is disposed
    _chatService.removeListener(_onChatServiceChanged);
    super.dispose();
  }
  
  // Called when chat service changes
  void _onChatServiceChanged() {
    // Clear selected chats if they no longer exist
    _selectedChats.removeWhere(
      (chatId) => !_chatService.chats.any((chat) => chat.id == chatId)
    );
    
    // Notify listeners of the change
    notifyListeners();
  }
  
  // Toggle edit mode
  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    
    // Clear selections when exiting edit mode
    if (!_isEditMode) {
      _selectedChats.clear();
    }
    
    notifyListeners();
  }
  
  // Toggle chat selection
  void toggleChatSelection(String chatId) {
    if (_selectedChats.contains(chatId)) {
      _selectedChats.remove(chatId);
    } else {
      _selectedChats.add(chatId);
    }
    
    notifyListeners();
  }
  
  // Check if a chat is selected
  bool isChatSelected(String chatId) {
    return _selectedChats.contains(chatId);
  }
  
  // Delete selected chats
  void deleteSelectedChats() {
    if (_selectedChats.isEmpty) return;
    
    // Delete the selected chats
    _chatService.deleteChats(_selectedChats.toList());
    
    // Exit edit mode
    _isEditMode = false;
    _selectedChats.clear();
    
    notifyListeners();
  }
  
  // Delete a single chat
  void deleteChat(String chatId) {
    _chatService.deleteChat(chatId);
    
    // Remove from selected chats if it was selected
    _selectedChats.remove(chatId);
    
    notifyListeners();
  }
  
  // Enter edit mode and select a chat
  void enterEditModeAndSelectChat(String chatId) {
    _isEditMode = true;
    _selectedChats.add(chatId);
    
    notifyListeners();
  }
}
