import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/page_transitions.dart';
import '../services/preferences_service.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

import 'company_start_screen.dart';
import 'student_onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle login success and navigate to the appropriate dashboard
  void _handleLoginSuccess(BuildContext context) {
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

                  SizedBox(height: 80.h),

                  // Welcome text
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "sign in to access your account",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h),

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
                        fontFamily: 'Mulish',
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

                  SizedBox(height: 16.h),

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
                        fontFamily: 'Mulish',
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

                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen with smooth transition
                        context.slideToPage(
                          const ForgotPasswordScreen(),
                          direction: SlideDirection.up,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50.w, 30.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform login
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login successful!'),
                              backgroundColor: Color(0xFF1A1053),
                            ),
                          );

                          // Handle navigation after login
                          _handleLoginSuccess(context);
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
                        "Log In",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Sign up link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to signup screen with smooth transition
                            context.scaleToPage(const SignupScreen());
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontFamily: 'Mulish',
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
