import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class for responsive design and preventing overflow
class ResponsiveUtils {
  /// Returns a responsive width based on screen size
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Returns a responsive height based on screen size
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  /// Returns a responsive font size that scales with screen size
  static double getResponsiveFontSize(BuildContext context, double fontSize) {
    // Base this on the smaller dimension to ensure text fits on narrow devices
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final smallerDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
    
    // Scale factor based on design size (375)
    final scaleFactor = smallerDimension / 375;
    
    // Limit the scaling to prevent text from becoming too large or too small
    final limitedScaleFactor = scaleFactor.clamp(0.8, 1.2);
    
    return fontSize * limitedScaleFactor;
  }

  /// Creates a text widget that automatically handles overflow
  static Widget createResponsiveText({
    required String text,
    required TextStyle style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a container with responsive padding
  static Widget responsivePadding({
    required Widget child,
    double horizontal = 16.0,
    double vertical = 8.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal.w,
        vertical: vertical.h,
      ),
      child: child,
    );
  }

  /// Creates a container with responsive margin
  static Widget responsiveMargin({
    required Widget child,
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal.w,
        vertical: vertical.h,
      ),
      child: child,
    );
  }

  /// Creates a flexible row that prevents overflow
  static Widget flexibleRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) => Flexible(
        fit: FlexFit.loose,
        child: child,
      )).toList(),
    );
  }

  /// Creates a card with responsive sizing
  static Widget responsiveCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderRadius = 12.0,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin ?? EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
