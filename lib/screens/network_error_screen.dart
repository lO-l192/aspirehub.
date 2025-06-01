import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error illustration
              SvgPicture.asset(
                'assets/images/app_images/speech-bubble.svg',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 32.h),

              // Error message
              Text(
                'No courses available',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1053),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              // Optional error description
              Text(
                'Please check your internet connection and try again',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48.h),

              // Try Again button
              SizedBox(
                width: 163.w,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6E6FA),
                    foregroundColor: const Color(0xFF1A1053),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withAlpha(25),
                  ),
                  onPressed: onRetry,
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
