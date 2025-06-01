import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavIcons {
  static const String _homeIconPath = 'assets/images/Vector.svg';
  static const String _lightbulbIconPath = 'assets/images/Icon.svg';
  static const String _personIconPath = 'assets/images/Group.svg';
  static const String _settingsIconPath = 'assets/images/Vector (1).svg';

  static Widget home({
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    double? size,
  }) {
    return SvgPicture.asset(
      _homeIconPath,
      width: size ?? 32.sp,
      height: size ?? 32.sp,
      color: isSelected ? selectedColor : unselectedColor,
    );
  }

  static Widget lightbulb({
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    double? size,
  }) {
    return SvgPicture.asset(
      _lightbulbIconPath,
      width: size ?? 32.sp,
      height: size ?? 32.sp,
      color: isSelected ? selectedColor : unselectedColor,
    );
  }

  static Widget person({
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    double? size,
  }) {
    return SvgPicture.asset(
      _personIconPath,
      width: size ?? 32.sp,
      height: size ?? 32.sp,
      color: isSelected ? selectedColor : unselectedColor,
    );
  }

  static Widget settings({
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    double? size,
  }) {
    return SvgPicture.asset(
      _settingsIconPath,
      width: size ?? 32.sp,
      height: size ?? 32.sp,
      color: isSelected ? selectedColor : unselectedColor,
    );
  }
}
