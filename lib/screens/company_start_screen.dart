import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'new_company_dashboard.dart';

class CompanyStartScreen extends StatelessWidget {
  const CompanyStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),

              // Logo and app name
              SizedBox(height: 60.h),

              // Main image
              Image.asset(
                'assets/images/company_start.png',
                height: 250.h,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 40.h),

              // Title
              Text(
                "Find the Perfect Talent for Your Team",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Description
              Text(
                "Join us and connect with top candidates ready to make an impact in your company",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16.sp,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withAlpha(179),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Start button
              SizedBox(
                width: 295,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompanyDashboard(),
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
                    "Start",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}
