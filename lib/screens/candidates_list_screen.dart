import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:provider/provider.dart';
import '../models/candidate.dart';
import '../services/chat_service.dart';
import 'filter_options_screen.dart';
import 'candidate_detail_screen.dart';
import 'chat_detail_screen.dart';

class CandidatesListScreen extends StatefulWidget {
  const CandidatesListScreen({super.key});

  @override
  State<CandidatesListScreen> createState() => _CandidatesListScreenState();
}

class _CandidatesListScreenState extends State<CandidatesListScreen> {
  // Sample data for candidates
  final List<Candidate> _candidates = [
    Candidate(
      id: '1',
      name: 'Amgd Ahmed',
      specialty: 'Software Engineering',
      avatarPath: 'assets/images/profile.png',
      points: 300,
      rank: 1,
    ),
    Candidate(
      id: '2',
      name: 'Amir Mahmoud',
      specialty: 'Product Management',
      avatarPath: 'assets/images/pers1.png',
      points: 275,
      rank: 2,
    ),
    Candidate(
      id: '3',
      name: 'Amr Ahmed',
      specialty: 'UI/UX Design',
      avatarPath: 'assets/images/pers2.png',
      points: 250,
      rank: 3,
    ),
    Candidate(
      id: '4',
      name: 'Ahmed mahmoud',
      specialty: 'Data Science',
      avatarPath: 'assets/images/pers3.png',
      points: 240,
      rank: 4,
    ),
    Candidate(
      id: '5',
      name: 'Bahaa Amr',
      specialty: 'Marketing',
      avatarPath: 'assets/images/testpic.png',
      points: 230,
      rank: 5,
    ),
    Candidate(
      id: '6',
      name: 'Ahmed Magdy',
      specialty: 'Cyber Security',
      avatarPath: 'assets/images/pers22.png',
      points: 225,
      rank: 6,
    ),
    Candidate(
      id: '7',
      name: 'Ahmed Magdy',
      specialty: 'Cyber Security',
      avatarPath: 'assets/images/pers22.png',
      points: 225,
      rank: 7,
    ),
    Candidate(
      id: '8',
      name: 'Ahmed Magdy',
      specialty: 'Cyber Security',
      avatarPath: 'assets/images/pers22.png',
      points: 225,
      rank: 8,
    ),
    Candidate(
      id: '9',
      name: 'Ahmed Magdy',
      specialty: 'Cyber Security',
      avatarPath: 'assets/images/pers22.png',
      points: 225,
      rank: 9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Candidates',
          style: TextStyle(
            fontFamily: 'Mulish',
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search/Filter bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GestureDetector(
              onTap: () {
                // Navigate to filter options screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterOptionsScreen(),
                  ),
                ).then((selectedFilters) {
                  // Handle selected filters when returning from the filter screen
                  if (selectedFilters != null) {
                    // Apply filters to the candidates list
                    setState(() {
                      // In a real app, you would filter _candidates based on selectedFilters
                      // For now, we'll just log the selected filters
                      debugPrint('Selected filters: $selectedFilters');
                    });
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color:
                      themeProvider.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withAlpha(179),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        enabled: false, // Disable direct input
                        decoration: InputDecoration(
                          hintText: 'Filter by date or field...',
                          hintStyle: TextStyle(
                            fontFamily: 'Mulish',
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withAlpha(179),
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Candidates list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: _candidates.length,
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1.h,
                    color:
                        themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                  ),
              itemBuilder: (context, index) {
                final candidate = _candidates[index];
                return _buildCandidateItem(candidate);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateItem(Candidate candidate) {
    return InkWell(
      onTap: () {
        // Navigate to candidate detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CandidateDetailScreen(candidate: candidate),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 30.w,
              height: 30.h,
              alignment: Alignment.center,
              child: Text(
                candidate.rank.toString(),
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16.sp,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Avatar
            CircleAvatar(
              radius: 30.r,
              backgroundImage: AssetImage(candidate.avatarPath),
            ),
            SizedBox(width: 16.w),

            // Candidate info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    candidate.specialty,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14.sp,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withAlpha(179),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${candidate.points} points',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14.sp,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),

            // Message icon
            IconButton(
              icon: Icon(
                Icons.mail_outline,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withAlpha(128),
                size: 24.sp,
              ),
              onPressed: () {
                // Get or create chat for this candidate
                final chatService = ChatService();
                final chat = chatService.getOrCreateChat(
                  candidate.rank.toString(),
                  candidate.name,
                  candidate.avatarPath,
                );

                // Navigate to chat screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChatDetailScreen(
                          chat: chat,
                          onMessageSent: (updatedChat, message) {
                            // This will update the chat in the chat list
                            setState(() {
                              // Force a rebuild to reflect changes in the UI
                            });
                          },
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
