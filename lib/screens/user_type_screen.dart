import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/page_transitions.dart';
import '../services/preferences_service.dart';
import 'login_screen.dart';

enum UserType { jobSeeker, company, none }

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  UserType _selectedType = UserType.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),

              // Career logo with Hero animation
              Row(
                children: [
                  Hero(
                    tag: 'logo-icon',
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1053),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Hero(
                    tag: 'logo-text',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "Career",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1053),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // Who are you? text
              Text(
                "Who are you ?",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Choose your path to get started.",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: 40.h),

              // Job Seeker option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = UserType.jobSeeker;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _selectedType == UserType.jobSeeker
                            ? const Color(0xFFEEEBF9)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color:
                          _selectedType == UserType.jobSeeker
                              ? const Color(0xFF1A1053)
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "I'm a Job Seeker : Looking to discover my path and get hired.",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Company option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = UserType.company;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _selectedType == UserType.company
                            ? const Color(0xFFEEEBF9)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color:
                          _selectedType == UserType.company
                              ? const Color(0xFF1A1053)
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "I'm a Company : Searching for top talents that truly fit our roles.",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed:
                      _selectedType == UserType.none
                          ? null
                          : () {
                            // Save user type preference
                            _saveUserTypeAndNavigate();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1053),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUserTypeAndNavigate() async {
    // Save the user type to shared preferences
    String userTypeString =
        _selectedType == UserType.jobSeeker ? 'job_seeker' : 'company';
    await PreferencesService.saveUserType(userTypeString);

    // Mark that the app has been launched before
    await PreferencesService.setAppLaunched();

    // Navigate to login screen with a smooth transition
    if (mounted) {
      context.fadeToReplacementPage(const LoginScreen());
    }
  }
}
