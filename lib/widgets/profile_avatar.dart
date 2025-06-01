import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/Models/controller/profile_controller.dart';

/// A reusable widget that displays the user's profile avatar consistently across the app.
/// It automatically updates when the profile image changes.
class ProfileAvatar extends StatelessWidget {
  /// The radius of the avatar.
  final double radius;
  
  /// Whether to show a border around the avatar.
  final bool showBorder;
  
  /// The color of the border, if shown.
  final Color? borderColor;
  
  /// The width of the border, if shown.
  final double borderWidth;
  
  /// Whether to show a shadow around the avatar.
  final bool showShadow;
  
  /// Optional callback when the avatar is tapped.
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.radius = 40,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
    this.showShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: ProfileController.imageNotifier,
      builder: (context, imageFile, _) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? Theme.of(context).primaryColor,
                      width: borderWidth,
                    )
                  : null,
              boxShadow: showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: CircleAvatar(
              radius: radius.r,
              backgroundColor: Colors.transparent,
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile,
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/Default_pfp.svg',
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
