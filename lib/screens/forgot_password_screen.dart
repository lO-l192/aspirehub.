import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

                  SizedBox(height: 40.h),

                  // Forgot password text
                  Text(
                    "Forgot password",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Please enter your email address then you will receive a link to create a new password via email.",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: 40.h),

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

                  // Helper text
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 8.h),
                    child: Text(
                      "Should be your@email.com",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  SizedBox(height: 120.h),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Send password reset email
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password reset link sent to ${_emailController.text}',
                                style: const TextStyle(fontFamily: 'Mulish'),
                              ),
                              backgroundColor: const Color(0xFF1A1053),
                            ),
                          );

                          // Show success message without auto-navigation
                          // User can navigate back manually
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
                        "send",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
