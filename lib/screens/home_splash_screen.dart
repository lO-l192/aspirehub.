import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSplashScreen extends StatefulWidget {
  final VoidCallback onLoadingComplete;
  final Duration splashDuration;

  const HomeSplashScreen({
    super.key,
    required this.onLoadingComplete,
    this.splashDuration = const Duration(seconds: 2),
  });

  @override
  State<HomeSplashScreen> createState() => _HomeSplashScreenState();
}

class _HomeSplashScreenState extends State<HomeSplashScreen> {
  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  Future<void> _startLoading() async {
    // Simulate loading time
    await Future.delayed(widget.splashDuration);

    // Call the callback when loading is complete
    if (mounted) {
      widget.onLoadingComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF1A1053)),
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}
