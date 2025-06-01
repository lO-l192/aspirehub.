import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;
  final Function(Chat, ChatMessage)? onMessageSent;

  const ChatDetailScreen({super.key, required this.chat, this.onMessageSent});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Voice recording state
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;

  // Voice playback state
  String? _playingMessageId;
  Timer? _playbackTimer;
  double _playbackProgress = 0.0;
  int _totalPlaybackDuration = 0;

  // Chat service
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    // Load messages from chat service
    _loadMessages();

    // Mark chat as read
    _chatService.markChatAsRead(widget.chat.id);
  }

  void _loadMessages() {
    setState(() {
      _messages = _chatService.getMessages(widget.chat.id).toList();
    });

    // Scroll to bottom after loading messages
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage({String? content, MessageType type = MessageType.text}) {
    // Get content from parameter or text field
    final messageContent = content ?? _messageController.text.trim();
    if (messageContent.isEmpty) return;

    // Send message using chat service
    _chatService.sendMessage(widget.chat, messageContent, type);

    // Reload messages from chat service
    setState(() {
      _messages = _chatService.getMessages(widget.chat.id).toList();
    });

    // Notify parent about the new message if callback exists
    if (widget.onMessageSent != null) {
      // Get the updated chat from the service
      final updatedChat = _chatService.chats.firstWhere(
        (chat) => chat.id == widget.chat.id,
        orElse: () => widget.chat,
      );

      // Get the last message
      final lastMessage = _messages.isNotEmpty ? _messages.last : null;

      if (lastMessage != null) {
        widget.onMessageSent!(updatedChat, lastMessage);
      }
    }

    // Clear text field if it was a text message
    if (type == MessageType.text) {
      _messageController.clear();
    }

    // Scroll to bottom after sending message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate a reply after 1-2 seconds
    _chatService.simulateReply(widget.chat, delaySeconds: 2);

    // Ensure the chat appears in the chat list
    if (widget.onMessageSent != null) {
      // Get the updated chat from the service
      final updatedChat = _chatService.chats.firstWhere(
        (chat) => chat.id == widget.chat.id,
        orElse: () => widget.chat,
      );

      // Get the last message
      final lastMessage = _messages.isNotEmpty ? _messages.last : null;

      if (lastMessage != null) {
        widget.onMessageSent!(updatedChat, lastMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.chat.userAvatar),
              radius: 18.r,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.userName,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color:
                            widget.chat.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.chat.isOnline ? 'active now' : 'offline',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withAlpha(179),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message.senderId != widget.chat.userId;

                // Show timestamp for first message or if there's a significant time gap
                bool showTimestamp =
                    index == 0 ||
                    _messages[index].timestamp
                            .difference(_messages[index - 1].timestamp)
                            .inHours >=
                        1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showTimestamp)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Center(
                          child: Text(
                            _formatTimestamp(message.timestamp),
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withAlpha(179),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    _buildMessageBubble(message, isMe),
                  ],
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child:
                _isRecording
                    ? _buildRecordingUI()
                    : Row(
                      children: [
                        // Message input field
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color:
                                  themeProvider.isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      hintText: 'Type a message...',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Mulish',
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withAlpha(179),
                                        fontSize: 14.sp,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14.sp,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.mic,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withAlpha(179),
                                    size: 20.sp,
                                  ),
                                  onPressed: _startRecording,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Send button
                        CircleAvatar(
                          backgroundColor:
                              themeProvider.isDarkMode
                                  ? const Color(0xFF6A5ACD)
                                  : const Color(0xFF1A1053),
                          radius: 24.r,
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            onPressed: () => _sendMessage(),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: AssetImage(widget.chat.userAvatar),
            radius: 16.r,
          ),
        if (!isMe) SizedBox(width: 8.w),

        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              bottom: 8.h,
              left: isMe ? 50.w : 0,
              right: isMe ? 0 : 50.w,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? (themeProvider.isDarkMode
                          ? const Color(0xFF1A3B4D)
                          : const Color(0xFFE1F5FE))
                      : (themeProvider.isDarkMode
                          ? Colors.grey.shade800
                          : const Color(0xFFF5F5F5)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child:
                message.type == MessageType.voice
                    ? _buildVoiceMessageContent(message, isMe)
                    : Text(
                      message.content,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14.sp,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return 'Today ${_formatTime(timestamp)}';
    } else if (messageDate == yesterday) {
      return 'Yesterday ${_formatTime(timestamp)}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${_formatTime(timestamp)}';
    }
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Start voice recording
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    // Start a timer to track recording duration
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });

    // In a real app, you would start actual audio recording here
    // using a plugin like flutter_sound or record
  }

  // Stop voice recording and send the message
  void _stopRecording() {
    // Cancel the timer
    _recordingTimer?.cancel();

    // In a real app, you would stop the actual recording here
    // and get the audio file path

    // For demo purposes, we'll just send a message with the duration
    final duration = _formatRecordingDuration();

    // Send voice message
    _sendMessage(content: duration, type: MessageType.voice);

    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
    });
  }

  // Format recording duration as mm:ss
  String _formatRecordingDuration() {
    final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Toggle voice message playback
  void _togglePlayback(ChatMessage message) {
    final isPlaying = _playingMessageId == message.id;

    // Add haptic feedback for better user experience
    HapticFeedback.mediumImpact();

    // If this message is already playing, stop it
    if (isPlaying) {
      _stopPlayback();
      return;
    }

    // Stop any currently playing message
    if (_playingMessageId != null) {
      _stopPlayback();
    }

    // Start playing this message
    _startPlayback(message);
  }

  // Start playing a voice message
  void _startPlayback(ChatMessage message) {
    // Parse the duration from the message content (format: "00:00")
    final parts = message.content.split(':');
    if (parts.length != 2) return;

    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    _totalPlaybackDuration = (minutes * 60) + seconds;

    if (_totalPlaybackDuration <= 0) return;

    setState(() {
      _playingMessageId = message.id;
      _playbackProgress = 0.0;
    });

    // Play a short sound to simulate starting playback
    SystemSound.play(SystemSoundType.click);

    // Start a timer to update the playback progress more smoothly (10 updates per second)
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        // Increment by 0.1 seconds for smoother animation
        _playbackProgress += 0.1;

        // Stop when we reach the end
        if (_playbackProgress >= _totalPlaybackDuration) {
          _stopPlayback();
          // Play a sound to indicate playback finished
          SystemSound.play(SystemSoundType.click);
        }
      });
    });
  }

  // Stop playing a voice message
  void _stopPlayback() {
    _playbackTimer?.cancel();
    setState(() {
      _playingMessageId = null;
      _playbackProgress = 0.0;
    });
  }

  // Format playback progress
  String _formatPlaybackProgress(double seconds) {
    final totalSeconds = seconds.floor();
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  // Build voice message content
  Widget _buildVoiceMessageContent(ChatMessage message, bool isMe) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isPlaying = _playingMessageId == message.id;
    final playbackColor =
        isMe
            ? (themeProvider.isDarkMode ? const Color(0xFF64B5F6) : Colors.blue)
            : Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(179) ??
                Colors.grey;

    // Calculate playback progress percentage (clamped between 0.0 and 1.0)
    double progressPercent = 0.0;
    if (isPlaying && _totalPlaybackDuration > 0) {
      progressPercent = (_playbackProgress / _totalPlaybackDuration).clamp(
        0.0,
        1.0,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/pause button
        GestureDetector(
          onTap: () => _togglePlayback(message),
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: playbackColor.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: playbackColor,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // Audio waveform with progress
        SizedBox(
          width: 80.w,
          height: 20.h,
          child: Stack(
            children: [
              // Background waveform
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  8,
                  (index) => Container(
                    width: 3.w,
                    height: (index % 3 + 1) * 5.h,
                    decoration: BoxDecoration(
                      color: playbackColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),

              // Progress overlay
              if (isPlaying)
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: progressPercent,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        8,
                        (index) => Container(
                          width: 3.w,
                          height: (index % 3 + 1) * 5.h,
                          decoration: BoxDecoration(
                            color: playbackColor,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 8.w),

        // Duration / progress
        Text(
          isPlaying
              ? '${_formatPlaybackProgress(_playbackProgress)} / ${message.content}'
              : message.content,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  // Build the recording UI
  Widget _buildRecordingUI() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Row(
      children: [
        // Recording indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:
                themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            children: [
              // Pulsating recording icon
              Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withAlpha(100),
                      blurRadius: 5.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Recording duration
              Text(
                _formatRecordingDuration(),
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Cancel button
        IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withAlpha(179),
            size: 24.sp,
          ),
          onPressed: () {
            setState(() {
              _isRecording = false;
              _recordingSeconds = 0;
              _recordingTimer?.cancel();
            });
          },
        ),
        // Stop recording button
        CircleAvatar(
          backgroundColor: const Color(0xFFE53935),
          radius: 24.r,
          child: IconButton(
            icon: Icon(Icons.stop, color: Colors.white, size: 20.sp),
            onPressed: _stopRecording,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    super.dispose();
  }
}
