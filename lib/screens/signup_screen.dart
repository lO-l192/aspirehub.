import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/preferences_service.dart';

import 'company_start_screen.dart';
import 'student_onboarding_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle signup success and navigate to the appropriate dashboard
  void _handleSignupSuccess() {
    // Get the user type from preferences and navigate
    _getUserTypeAndNavigate();
  }

  // Helper method to get user type and navigate to the appropriate screen
  Future<void> _getUserTypeAndNavigate() async {
    // Get the user type from preferences
    String? userType = await PreferencesService.getUserType();

    if (!mounted) return;

    // Navigate to the appropriate dashboard based on user type
    if (userType == 'job_seeker') {
      // Navigate to student dashboard
      _navigateToStudentDashboard();
    } else {
      // Navigate to company dashboard
      _navigateToCompanyDashboard();
    }
  }

  // Navigate to student onboarding screen
  void _navigateToStudentDashboard() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StudentOnboardingScreen()),
    );
  }

  // Navigate to company start screen
  void _navigateToCompanyDashboard() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CompanyStartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1053)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Career logo
                  Row(
                    children: [
                      Container(
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
                      SizedBox(width: 8.w),
                      Text(
                        "Career",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1053),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  // Welcome text
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Enter your Untitled account details.",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: 50.h),

                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.black87,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "user name",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 45.h),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.black87,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 45.h),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.black87,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 45.h),

                  // Confirm Password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.black87,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "confirm your password",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform sign up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign up successful!'),
                              backgroundColor: Color(0xFF1A1053),
                            ),
                          );

                          // Handle navigation after signup
                          _handleSignupSuccess();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1053),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Login link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a user? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1053),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
