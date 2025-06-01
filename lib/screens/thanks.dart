import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/personality_question.dart';
import 'personality_result_screen.dart';

class ThanksScreen extends StatelessWidget {
  final PersonalityResult result;

  const ThanksScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top decoration - curved shape
          Positioned(
            top: 0,
            left: -16,
            child: SvgPicture.asset(
              'assets/images/app_images/up.svg',
              width: 391,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main illustration - centered
                Center(
                  child: SvgPicture.asset(
                    'assets/images/app_images/bro.svg',
                    width: 220.w,
                    height: 220.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // Thank you text
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Thank you for answering!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1053),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Show Results button using ElevatedButton
                SizedBox(
                  width: 200.w,
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withAlpha(40),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PersonalityResultScreen(result: result),
                        ),
                      );
                    },
                    child: Text(
                      'Show Results',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1053),
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom decoration - curved shape
          Positioned(
            bottom: 0,
            right: 130,
            child: SvgPicture.asset(
              'assets/images/app_images/down.svg',
              color: Color(0xFFCACAEA),
              width: 391,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
