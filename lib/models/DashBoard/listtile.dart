import 'dart:io';
import 'package:aspirehub3/models/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashListtile extends StatelessWidget {
  const DashListtile({super.key, this.title, this.subtitle, this.image});

  final String? title;
  final String? subtitle;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile>(
      valueListenable: ProfileController.profileNotifier,
      builder: (context, userProfile, _) {
        return ValueListenableBuilder<File?>(
          valueListenable: ProfileController.imageNotifier,
          builder: (context, imageFile, _) {
            return ListTile(
              leading: CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.transparent,
                child:
                    imageFile != null
                        ? ClipOval(
                          child: Image.file(
                            imageFile,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                          ),
                        )
                        : SvgPicture.asset(
                          'assets/images/Default_pfp.svg',
                          width: 60.w,
                          height: 60.h,
                        ),
              ),
              title: Text(
                'Hi, ${userProfile.name}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish',
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              subtitle: Text(
                subtitle ??
                    (userProfile.personalityType != null
                        ? 'Your personality: ${userProfile.personalityType} - ${userProfile.careerSuggestion ?? ""}'
                        : 'Your job: Auditor'),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(77), // 0.3 opacity
                        spreadRadius: 1.r,
                        blurRadius: 5.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : const Color(0xFFF6F6F6),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).iconTheme.color,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
