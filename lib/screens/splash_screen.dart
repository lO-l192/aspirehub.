import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/preferences_service.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Add a small delay to show the splash screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Check if this is the first launch
    bool isFirstLaunch = await PreferencesService.isFirstLaunch();

    if (!mounted) return;

    if (isFirstLaunch) {
      // If it's the first launch, navigate to the onboarding screen
      _navigateToOnboardingScreen();
    } else {
      // Otherwise, navigate to the login screen
      _navigateToLoginScreen();
    }
  }

  void _navigateToOnboardingScreen() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  void _navigateToLoginScreen() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo container
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1053),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Icon(Icons.school, color: Colors.white, size: 60.sp),
              ),
            ),
            SizedBox(height: 24.h),

            // App name
            Text(
              "Career",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1053),
              ),
            ),
            SizedBox(height: 8.h),

            // Tagline
            Text(
              "Find your path, build your future",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: 40.h),

            // Loading indicator
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1053)),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
