import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({super.key});

  @override
  State<CircularProgress> createState() => _CircularprogressState();
}

class _CircularprogressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, right: 50.w),
      child: CircularPercentIndicator(
        radius: 45.r,
        animation: true,
        animationDuration: 1200,
        lineWidth: 10.0,
        percent: 0.5,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor:
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                : const Color(0xFF1C1259), // Original color for light mode
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade700
                : const Color(0xFFA6A6A6),
        center: Text(
          '50%',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
