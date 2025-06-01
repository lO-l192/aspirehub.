import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/company_bottom_navbar.dart';
import 'chat_list_screen.dart';
import 'candidates_list_screen.dart';
import 'company_settings_screen.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: CompanyBottomNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildMessagesTab();
      case 2:
        return _buildCandidatesTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company banner image
          Image.asset(
            'assets/images/comp.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company profile section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        'assets/images/com.png',
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // Company details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Industry: Software Development & Talent Placement",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.sp,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Headquarters: New York, USA",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.sp,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Company Size: 1000+ employees",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.sp,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // About section
                Text(
                  "About Andela",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Andela is a global talent network that connects companies with top software engineers, product managers, and other tech professionals. Founded in 2014, Andela has helped businesses scale their engineering teams by providing access to world-class developers from around the globe. With a rigorous vetting process, Andela ensures that only the most skilled and experienced professionals join its network, allowing companies to find the right talent quickly and efficiently. Whether you're looking for software engineers, cloud architects, or data scientists, Andela provides customized hiring solutions tailored to your needs.",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 24.h),

                // Current job openings
                Text(
                  "Current Job Openings",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: 8.h),

                // Job list
                _buildJobItem("Senior Software Engineer (Remote)"),
                _buildJobItem("Frontend Developer (React.js)"),
                _buildJobItem("Backend Engineer (Node.js, Python)"),
                _buildJobItem("Data Scientist"),
                _buildJobItem("Cloud Engineer"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobItem(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // Messages tab with chat list
  Widget _buildMessagesTab() {
    return const ChatListScreen();
  }

  Widget _buildCandidatesTab() {
    return const CandidatesListScreen();
  }

  Widget _buildSettingsTab() {
    return const CompanySettingsScreen();
  }
}
