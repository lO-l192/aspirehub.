import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/pdf.screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _showControls = false;
  double _playbackSpeed = 1.0;
  Timer? _controlsTimer;

  // List of available playback speeds
  final List<double> _availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    // Clean up resources
    _controlsTimer?.cancel();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    super.dispose();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    try {
      // First try to load from assets
      final controller = VideoPlayerController.asset('assets/video/1.mp4');
      await controller.initialize();

      if (mounted) {
        setState(() {
          _videoPlayerController = controller;
          _isInitialized = true;
          _isLoading = false;
        });

        // Add listener to rebuild UI when video position changes
        _videoPlayerController!.addListener(_videoListener);

        // Start playing the video
        _videoPlayerController!.play();
      }
    } catch (assetError) {
      debugPrint('Error loading asset video: $assetError');

      // If asset fails, try network video
      try {
        if (!mounted) return;

        final networkController = VideoPlayerController.networkUrl(
          Uri.parse(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          ),
        );

        await networkController.initialize();

        if (mounted) {
          setState(() {
            _videoPlayerController = networkController;
            _isInitialized = true;
            _isLoading = false;
          });

          // Add listener to rebuild UI when video position changes
          _videoPlayerController!.addListener(_videoListener);

          // Start playing the video
          _videoPlayerController!.play();
        }
      } catch (networkError) {
        debugPrint('Error loading network video: $networkError');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _videoListener() {
    // This will rebuild the UI when the video position changes
    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }

  void _changePlaybackSpeed() {
    if (_videoPlayerController == null) return;

    // Find the next speed in the list
    int currentIndex = _availableSpeeds.indexOf(_playbackSpeed);
    int nextIndex = (currentIndex + 1) % _availableSpeeds.length;

    setState(() {
      _playbackSpeed = _availableSpeeds[nextIndex];
      _videoPlayerController!.setPlaybackSpeed(_playbackSpeed);
    });

    // Show a snackbar with the new speed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playback speed: ${_playbackSpeed}x'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _seekRelative(Duration duration) {
    if (_videoPlayerController == null) return;

    final currentPosition = _videoPlayerController!.value.position;
    final newPosition = currentPosition + duration;

    // Ensure we don't seek beyond the video duration
    final targetPosition =
        newPosition.inMilliseconds < 0
            ? Duration.zero
            : (newPosition > _videoPlayerController!.value.duration
                ? _videoPlayerController!.value.duration
                : newPosition);

    _videoPlayerController!.seekTo(targetPosition);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final accentColor =
        themeProvider.isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Dark blue for light mode

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              )
              : !_isInitialized || _videoPlayerController == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load video',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _initializeVideo();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video player with controls
                    Stack(
                      children: [
                        // Video player
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showControls = !_showControls;
                              if (_showControls) {
                                _startControlsTimer();
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 350,
                            color: Colors.black,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              ),
                            ),
                          ),
                        ),

                        // Video controls overlay
                        if (_showControls)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withAlpha(100),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Top controls - back button and speed
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 40.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton.icon(
                                          onPressed: _changePlaybackSpeed,
                                          icon: const Icon(
                                            Icons.speed,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            '${_playbackSpeed}x',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Middle controls - rewind, play/pause, forward
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        iconSize: 40,
                                        icon: const Icon(
                                          Icons.replay_10,
                                          color: Colors.white,
                                        ),
                                        onPressed:
                                            () => _seekRelative(
                                              const Duration(seconds: -10),
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_videoPlayerController!
                                                .value
                                                .isPlaying) {
                                              _videoPlayerController!.pause();
                                            } else {
                                              _videoPlayerController!.play();
                                              _startControlsTimer();
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(128),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _videoPlayerController!
                                                    .value
                                                    .isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        iconSize: 40,
                                        icon: const Icon(
                                          Icons.forward_10,
                                          color: Colors.white,
                                        ),
                                        onPressed:
                                            () => _seekRelative(
                                              const Duration(seconds: 10),
                                            ),
                                      ),
                                    ],
                                  ),

                                  // Bottom controls - progress bar and time
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        // Progress bar
                                        SliderTheme(
                                          data: SliderThemeData(
                                            trackHeight: 4,
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                  enabledThumbRadius: 6,
                                                ),
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                  overlayRadius: 12,
                                                ),
                                            activeTrackColor: accentColor,
                                            inactiveTrackColor: Colors.white
                                                .withAlpha(50),
                                            thumbColor: accentColor,
                                            overlayColor: accentColor.withAlpha(
                                              50,
                                            ),
                                          ),
                                          child: Slider(
                                            value:
                                                _videoPlayerController!
                                                    .value
                                                    .position
                                                    .inMilliseconds
                                                    .toDouble(),
                                            min: 0,
                                            max:
                                                _videoPlayerController!
                                                    .value
                                                    .duration
                                                    .inMilliseconds
                                                    .toDouble(),
                                            onChanged: (value) {
                                              _videoPlayerController!.seekTo(
                                                Duration(
                                                  milliseconds: value.toInt(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // Time indicators
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDuration(
                                                  _videoPlayerController!
                                                      .value
                                                      .position,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                _formatDuration(
                                                  _videoPlayerController!
                                                      .value
                                                      .duration,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Always visible back button when controls are hidden
                        if (!_showControls)
                          Positioned(
                            top: 40,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Content section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description text
                          const Text(
                            "Welcome to your journey toward becoming a Certified Public Accountant! "
                            "In this first lecture, we'll cover the basics you need to know to kickstart your CPA preparation. "
                            "Let's dive in and start learning!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // PDF download button
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PdfScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Click to download lecture summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.insert_drive_file_rounded, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Next Lecture section
                          Text(
                            'Next Lecture',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Next lecture card
                          InkWell(
                            onTap: () {
                              // Pause current video before navigating
                              if (_videoPlayerController != null &&
                                  _videoPlayerController!.value.isPlaying) {
                                _videoPlayerController!.pause();
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const VideoPlayerScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(36),
                                    offset: Offset(4.w, 4.h),
                                    blurRadius: 8.r,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Thumbnail image with fixed width
                                  SizedBox(
                                    width: 130.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/Rectangle 4.png',
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // Lecture details
                                  Expanded(
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      title: Text(
                                        'Lec 2',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.color,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Mohamed Workshop',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium?.color,
                                              fontFamily: 'Quick',
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '3 Hours',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium?.color,
                                              fontFamily: 'Quick',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
