import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String text;
  final VoidCallback onTap;
  final Color buttontext;
  final int borderRadius;

  const CustomButton({
    super.key,
    required this.buttontext,
    required this.width,
    required this.height,
    required this.color,
    required this.text,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: buttontext,
              fontWeight: FontWeight.bold,
              fontFamily: 'Mulish',
            ),
          ),
        ),
      ),
    );
  }
}
