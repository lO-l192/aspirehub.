import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../models/controller/profile_controller.dart';
import '../models/personality_question.dart';
import 'student_quiz_screen.dart';
import 'dash_board_screen.dart';
import 'home_splash_screen.dart';

class PersonalityResultScreen extends StatelessWidget {
  final PersonalityResult result;

  const PersonalityResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // Get career suggestion based on personality type
    final String careerSuggestion = _getCareerSuggestion(
      result.personalityType,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top wave decoration
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
          Positioned(
            bottom: -50,
            right: 130,
            child: SvgPicture.asset(
              'assets/images/app_images/down.svg',
              color: Color(0xFFCACAEA),
              width: 391,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),

          // Bottom wave decoration

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),

                  // Personality type circle
                  Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6FA),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          result.personalityType,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          careerSuggestion,
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

                  // Personality description
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'More Detail : The ${result.personalityType} personality is practical, organized, and rule-oriented. They pay great attention to detail, are reliable, and prefer structured environments. ${result.personalityType}s are responsible, methodical, and focused on completing tasks accurately and efficiently.',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 60.h),

                  // New Test button
                  _buildButton(
                    text: 'New Test',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StudentQuizScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Go to Home button
                  _buildButton(
                    text: 'Go to Home',
                    onTap: () async {
                      // Get career suggestion based on personality type
                      final String careerSuggestion = _getCareerSuggestion(
                        result.personalityType,
                      );

                      // Save the personality type and career suggestion to the user profile
                      await ProfileController.savePersonalityResult(
                        personalityType: result.personalityType,
                        careerSuggestion: careerSuggestion,
                      );

                      if (!context.mounted) return;

                      // Show the home splash screen first
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeSplashScreen(
                                onLoadingComplete: () {
                                  // Navigate to the dashboard screen after loading
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const DashBoardScreen(),
                                    ),
                                  );
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6FA),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  String _getCareerSuggestion(String personalityType) {
    final Map<String, String> careerSuggestions = {
      'ISTJ': 'Accountant or Auditor',
      'ISFJ': 'Nurse or Teacher',
      'INFJ': 'Counselor or Writer',
      'INTJ': 'Scientist or Engineer',
      'ISTP': 'Mechanic or Pilot',
      'ISFP': 'Artist or Designer',
      'INFP': 'Writer or Therapist',
      'INTP': 'Scientist or Programmer',
      'ESTP': 'Entrepreneur or Salesperson',
      'ESFP': 'Entertainer or Event Planner',
      'ENFP': 'Journalist or Consultant',
      'ENTP': 'Entrepreneur or Lawyer',
      'ESTJ': 'Manager or Administrator',
      'ESFJ': 'Teacher or Social Worker',
      'ENFJ': 'Counselor or HR Manager',
      'ENTJ': 'Executive or Lawyer',
    };

    return careerSuggestions[personalityType] ?? 'Career Advisor';
  }
}
