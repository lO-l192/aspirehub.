import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'student_quiz_screen.dart';
import 'network_error_screen.dart';
import 'home_splash_screen.dart';

class StudentOnboardingScreen extends StatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  State<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen> {
  bool _isLoading = true;
  bool _hasNetworkError = false;

  @override
  void initState() {
    super.initState();
    _checkNetworkAndLoadData();
  }

  Future<void> _checkNetworkAndLoadData() async {
    setState(() {
      _isLoading = true;
      _hasNetworkError = false;
    });

    // The network check happens in the background while the splash screen is shown
    // For testing purposes, you can toggle between these two methods:
    // 1. Real network check:
    // bool hasNetwork = await _checkInternetConnection();
    // 2. Simulated network success (always succeeds):
    bool hasNetwork = true; // Set to true to bypass network error screen

    // When the splash screen completes, it will set _isLoading to false
    // Then we'll update the _hasNetworkError flag based on our network check
    if (!mounted) return;

    setState(() {
      _hasNetworkError = !hasNetwork;
    });
  }

  // This method is kept for production use
  // To use it, replace the call to _simulateNetworkError() with this method
  // in the _checkNetworkAndLoadData() method
  Future<bool> _checkInternetConnection() async {
    try {
      // Try to reach Google's DNS server
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } on SocketException catch (_) {
      // No internet connection
      return false;
    } on TimeoutException catch (_) {
      // Connection timeout
      return false;
    } catch (_) {
      // Any other error
      return false;
    }
  }

  // For testing purposes, you can toggle this method to simulate network errors
  Future<bool> _simulateNetworkError() async {
    await Future.delayed(const Duration(seconds: 1));
    return false; // Always return false to simulate network error
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show the Home splash screen
      return HomeSplashScreen(
        onLoadingComplete: () {
          // When loading is complete, check network and update state
          setState(() {
            _isLoading = false;
          });
        },
      );
    }

    if (_hasNetworkError) {
      // Show network error screen
      return NetworkErrorScreen(onRetry: _checkNetworkAndLoadData);
    }

    // Show normal onboarding screen
    return Scaffold(
      backgroundColor: const Color(0xFF201B39),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, right: 16.w),
                child: TextButton(
                  onPressed: () {
                    // Skip to quiz screen
                    _navigateToDashboard(context);
                  },
                  child: Text(
                    "Skip to Test",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),

            // Spacer to push content down
            SizedBox(height: 40.h),

            // Main illustration
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Image.asset(
                  'assets/images/app_images/first_image.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom white container with text and button
            Container(
              height: 433,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Main text
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Discover Your Career Path",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2F394B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Take the personality test to find your perfect career match",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Start button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to quiz screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StudentQuizScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1053),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Start Personality Test",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 35.h),

                    // Previous test link
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,

                        children: [
                          Text(
                            "Have you taken the test before? ",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "view previous recommendation",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StudentQuizScreen()),
    );
  }
}
