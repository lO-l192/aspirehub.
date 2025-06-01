import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Chat service
  final ChatService _chatService = ChatService();

  // Edit mode state
  bool _isEditMode = false;
  final Set<String> _selectedChats = {};

  @override
  void initState() {
    super.initState();
    // Listen for changes to the chat service
    _chatService.addListener(_onChatServiceChanged);
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    _chatService.removeListener(_onChatServiceChanged);
    super.dispose();
  }

  // Called when chat service changes
  void _onChatServiceChanged() {
    if (mounted) {
      setState(() {
        // This will trigger a rebuild with the latest data
        // Clear selected chats if they no longer exist
        _selectedChats.removeWhere(
          (chatId) => !_chatService.chats.any((chat) => chat.id == chatId),
        );

        // Force a rebuild to show the latest chats
        // This ensures new chats appear in the list
      });
    }
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      // Clear selections when exiting edit mode
      if (!_isEditMode) {
        _selectedChats.clear();
      }
    });
  }

  // Delete selected chats
  void _deleteSelectedChats() {
    if (_selectedChats.isEmpty) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogThemeProvider = Provider.of<ThemeProvider>(
          dialogContext,
          listen: false,
        );
        return AlertDialog(
          title: Text(
            'Delete Chats',
            style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedChats.length} chat${_selectedChats.length > 1 ? 's' : ''}?',
            style: TextStyle(fontFamily: 'Mulish'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  color:
                      dialogThemeProvider.isDarkMode
                          ? Colors.white.withAlpha(179)
                          : Colors.black.withAlpha(179),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Delete the selected chats
                _chatService.deleteChats(_selectedChats.toList());

                // Exit edit mode
                setState(() {
                  _isEditMode = false;
                  _selectedChats.clear();
                });

                // Close the dialog
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Update chat with new message
  void _updateChat(Chat updatedChat, ChatMessage message) {
    // This is now handled by the ChatService
    // We keep this method for backward compatibility
  }

  // Build empty state widget
  Widget _buildEmptyState() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color:
                themeProvider.isDarkMode
                    ? Colors.white.withAlpha(128)
                    : Colors.black.withAlpha(128),
          ),
          SizedBox(height: 16.h),
          Text(
            'No messages yet',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a conversation with a candidate\nfrom the Candidates screen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14.sp,
              color:
                  themeProvider.isDarkMode
                      ? Colors.white.withAlpha(179)
                      : Colors.black.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor:
            themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
            fontFamily: 'Mulish',
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: _toggleEditMode,
          child: Text(
            _isEditMode ? 'Done' : 'Edit',
            style: TextStyle(
              fontFamily: 'Mulish',
              color:
                  themeProvider.isDarkMode
                      ? const Color(0xFF6A5ACD)
                      : const Color(0xFF1A1053),
            ),
          ),
        ),
        actions:
            _isEditMode && _selectedChats.isNotEmpty
                ? [
                  // Delete button
                  TextButton(
                    onPressed: _deleteSelectedChats,
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
                : null,
      ),
      body:
          _chatService.chats.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                itemCount: _chatService.chats.length,
                itemBuilder: (context, index) {
                  final chat = _chatService.chats[index];
                  return _buildChatItem(chat);
                },
              ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isSelected = _selectedChats.contains(chat.id);

    return Dismissible(
      key: Key('chat-${chat.id}'),
      background: Container(
        color: const Color(0xFFE53935),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(Icons.delete, color: Colors.white, size: 30.sp),
      ),
      direction:
          _isEditMode ? DismissDirection.none : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog(
          context: context,
          builder: (dialogContext) {
            final dialogThemeProvider = Provider.of<ThemeProvider>(
              dialogContext,
              listen: false,
            );
            return AlertDialog(
              title: Text(
                'Delete Chat',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Are you sure you want to delete this chat with ${chat.userName}?',
                style: TextStyle(fontFamily: 'Mulish'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color:
                          dialogThemeProvider.isDarkMode
                              ? Colors.white.withAlpha(179)
                              : Colors.black.withAlpha(179),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: const Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Delete the chat
        _chatService.deleteChat(chat.id);
      },
      child: InkWell(
        onTap: () {
          if (_isEditMode) {
            // In edit mode, tap to select/deselect - use post-frame callback
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  if (_selectedChats.contains(chat.id)) {
                    _selectedChats.remove(chat.id);
                  } else {
                    _selectedChats.add(chat.id);
                  }
                });
              }
            });
          } else {
            // Normal mode, navigate to chat
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChatDetailScreen(
                      chat: chat,
                      onMessageSent: _updateChat,
                    ),
              ),
            );
          }
        },
        // Long press to enter edit mode and select this chat
        onLongPress: () {
          if (!_isEditMode) {
            // Use post-frame callback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isEditMode = true;
                _selectedChats.add(chat.id);
              });
            });
          }
        },
        child: Container(
          color:
              isSelected
                  ? (themeProvider.isDarkMode
                      ? const Color(0xFF6A5ACD).withAlpha(25)
                      : const Color(0xFF1A1053).withAlpha(25))
                  : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // Selection indicator or avatar
                if (_isEditMode)
                  Container(
                    margin: EdgeInsets.only(right: 12.w),
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected
                                ? (themeProvider.isDarkMode
                                    ? const Color(0xFF6A5ACD)
                                    : const Color(0xFF1A1053))
                                : (themeProvider.isDarkMode
                                    ? Colors.white.withAlpha(179)
                                    : Colors.black.withAlpha(179)),
                        width: 2,
                      ),
                      color:
                          isSelected
                              ? (themeProvider.isDarkMode
                                  ? const Color(0xFF6A5ACD)
                                  : const Color(0xFF1A1053))
                              : Colors.transparent,
                    ),
                    child:
                        isSelected
                            ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16.sp,
                            )
                            : null,
                  ),

                // Avatar
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: AssetImage(chat.userAvatar),
                ),
                SizedBox(width: 12.w),

                // Chat info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.userName,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (chat.lastMessageType == MessageType.text &&
                              chat.isRead)
                            Icon(
                              Icons.done_all,
                              color:
                                  themeProvider.isDarkMode
                                      ? const Color(0xFF6A5ACD)
                                      : const Color(0xFF1A1053),
                              size: 16.sp,
                            ),
                          if (chat.lastMessageType == MessageType.voice)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.mic,
                                  color: const Color(0xFF4CAF50),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  chat.lastMessage,
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14.sp,
                                    color:
                                        themeProvider.isDarkMode
                                            ? Colors.white.withAlpha(179)
                                            : Colors.black.withAlpha(179),
                                  ),
                                ),
                              ],
                            ),
                          if (chat.lastMessageType == MessageType.image)
                            Icon(
                              Icons.photo_camera,
                              color:
                                  themeProvider.isDarkMode
                                      ? Colors.white.withAlpha(179)
                                      : Colors.black.withAlpha(179),
                              size: 16.sp,
                            ),
                          SizedBox(width: 4.w),
                          if (chat.lastMessageType != MessageType.voice)
                            Expanded(
                              child: Text(
                                chat.lastMessage,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14.sp,
                                  color:
                                      themeProvider.isDarkMode
                                          ? Colors.white.withAlpha(179)
                                          : Colors.black.withAlpha(179),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chevron icon or swipe to delete hint
                if (!_isEditMode)
                  Icon(
                    Icons.chevron_right,
                    color:
                        themeProvider.isDarkMode
                            ? Colors.white.withAlpha(179)
                            : Colors.black.withAlpha(179),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
