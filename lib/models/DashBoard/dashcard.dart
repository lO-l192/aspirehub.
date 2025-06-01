import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final double progress;
  final String cardext;
  final Widget targetPage;

  const ProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.cardext,
    required this.targetPage,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 132;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => widget.targetPage,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withAlpha(150),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Percentage label positioned outside the progress bar
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w, bottom: 4.h),
                        child: Text(
                          '${(widget.progress * 100).toInt()}%',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(
                                      0xFF6A5ACD,
                                    ) // Slateblue for dark mode
                                    : const Color(
                                      0xFF1C1259,
                                    ), // Original color for light mode
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Progress bar
                    LinearPercentIndicator(
                      width: width,
                      lineHeight: 14.0,
                      animation: true,
                      animationDuration: 800,
                      percent: widget.progress,
                      progressColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(
                                0xFF6A5ACD,
                              ) // Slateblue for dark mode
                              : const Color(
                                0xFF1C1259,
                              ), // Original color for light mode
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                      barRadius: Radius.circular(16.r),
                    ),
                    if (_isExpanded) ...[
                      SizedBox(height: 8.h),
                      Text(
                        widget.cardext,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _isExpanded ? 'Show Less' : 'Show More',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mulish',
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
