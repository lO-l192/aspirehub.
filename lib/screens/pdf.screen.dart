import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PdfScreen extends StatelessWidget {
  const PdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: -15,
        title: Text(
          'close',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView for scrollability
        child: Column(
          children: [
            Center(
              heightFactor: 2,
              child: Text(
                'Certified Public Accountant',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Container(
              padding: EdgeInsets.all(16.sp),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26), // 0.1 opacity
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Text(
                'Here\'s a long summary for the first lecture on Certified Public Accountant (CPA) preparation: '
                'Certified Public Accountant (CPA) Lecture 1: Introduction to the CPA Journey. '
                'The first lecture in the CPA course serves as a foundation for understanding what it takes to become '
                'a Certified Public Accountant. It introduces key concepts, requirements, and the scope of the CPA profession. '
                'Below is a breakdown of the lecture. '
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum. Curabitur '
                'lectus nisi, tristique sit amet orci sed, vehicula ultricies lectus. Integer pellentesque elit sed augue fringilla, '
                'et dapibus ligula cursus. Nulla facilisi. Phasellus pharetra, risus non euismod venenatis, est tortor malesuada nulla, '
                'non dictum leo augue euismod nisl. Vivamus a auctor magna. Curabitur eget mollis leo. Fusce fringilla nibh vel purus '
                'fermentum, non lacinia sapien interdum. Mauris a elit tempor, egestas orci id, venenatis eros. Curabitur viverra ante '
                'in sapien consectetur, et pretium purus scelerisque. Integer et libero a nunc pretium feugiat. Suspendisse potenti. '
                'Sed at purus arcu. Integer imperdiet nibh eu purus tristique, sit amet pharetra enim volutpat. Donec et nunc vestibulum '
                'orci posuere volutpat sed at nulla. Sed in auctor tortor, id sollicitudin nisi. '
                'Duis laoreet urna sit amet augue vulputate, et malesuada ligula scelerisque. Etiam rhoncus ex in turpis pharetra, '
                'vel fringilla tortor vehicula. Aliquam malesuada massa in fringilla elementum. Aenean sit amet fermentum felis. '
                'In ac fermentum tortor. Fusce vestibulum est id fringilla volutpat. In convallis risus id libero cursus, eget '
                'cursus ligula efficitur. Morbi viverra, libero sit amet vulputate elementum, purus est ultricies risus, id malesuada '
                'enim turpis id tortor. Nulla facilisi. Fusce pharetra dolor ac ex tincidunt, non feugiat libero feugiat. Donec eget '
                'mauris ut risus auctor rutrum. Integer tristique lorem non arcu gravida, id gravida turpis convallis.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
