import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/candidate.dart';

import '../services/chat_service.dart';
import 'chat_detail_screen.dart';

class CandidateDetailScreen extends StatelessWidget {
  final Candidate candidate;

  const CandidateDetailScreen({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button

            // Candidate details
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundImage: AssetImage(candidate.avatarPath),
                      ),
                    ),

                    // Name
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        candidate.name,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Field
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Field: ',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: candidate.specialty,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Score
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Score: ',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: candidate.points.toString(),
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Email
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Email: ',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: _getEmailFromName(candidate.name),
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Summary section
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Text(
                        'Summary:',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        _getSummary(candidate.specialty),
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),

                    // Skills section
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Text(
                        'Skills:',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _getSkills(candidate.specialty).map((skill) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        skill,
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    // Experience section
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Text(
                        'Experience:',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        '${_getJobTitle(candidate.specialty)} - XYZ Tech (2022 - Present)',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _getExperience(candidate.specialty).map((exp) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        exp,
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back to list button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Back to list',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Message button
                          ElevatedButton.icon(
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
                                      (context) => ChatDetailScreen(chat: chat),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1053),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            icon: Icon(Icons.message, size: 20.sp),
                            label: Text(
                              'Message',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to generate content based on candidate specialty
  String _getEmailFromName(String name) {
    final nameParts = name.toLowerCase().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0]}${nameParts[1].substring(0, 2)}@gmail.com';
    }
    return '${nameParts[0]}89@gmail.com';
  }

  String _getSummary(String specialty) {
    switch (specialty) {
      case 'Software Engineering':
        return 'Experienced Software Engineer skilled in full-stack development and cloud technologies. Passionate about building scalable and efficient applications.';
      case 'Product Management':
        return 'Strategic Product Manager with expertise in product development lifecycle and market analysis. Focused on creating user-centered products that drive business growth.';
      case 'UI/UX Design':
        return 'Creative UI/UX Designer with a strong portfolio of digital products. Combines aesthetic design with user-centered thinking to create intuitive interfaces.';
      case 'Data Science':
        return 'Analytical Data Scientist with expertise in machine learning and statistical analysis. Skilled at extracting insights from complex datasets to drive business decisions.';
      case 'Marketing':
        return 'Results-driven Marketing Professional with experience in digital marketing strategies. Specializes in campaign management and brand development.';
      case 'Cyber Security':
        return 'Security expert with experience in vulnerability assessment and threat mitigation. Dedicated to protecting systems and data from evolving cyber threats.';
      default:
        return 'Experienced professional with expertise in $specialty. Passionate about delivering high-quality work and continuous improvement.';
    }
  }

  List<String> _getSkills(String specialty) {
    switch (specialty) {
      case 'Software Engineering':
        return [
          'Languages: JavaScript, Python, Java',
          'Frameworks: React.js, Node.js, Django',
          'Databases: MySQL, MongoDB',
        ];
      case 'Product Management':
        return [
          'Product Strategy',
          'User Research',
          'Agile Methodologies',
          'Data Analysis',
        ];
      case 'UI/UX Design':
        return [
          'Figma, Adobe XD, Sketch',
          'User Research',
          'Wireframing & Prototyping',
          'Interaction Design',
        ];
      case 'Data Science':
        return [
          'Python, R, SQL',
          'Machine Learning',
          'Data Visualization',
          'Statistical Analysis',
        ];
      case 'Marketing':
        return [
          'Digital Marketing',
          'Content Strategy',
          'SEO/SEM',
          'Social Media Management',
        ];
      case 'Cyber Security':
        return [
          'Network Security',
          'Penetration Testing',
          'Security Auditing',
          'Incident Response',
        ];
      default:
        return [
          'Professional Skills',
          'Technical Expertise',
          'Project Management',
          'Communication',
        ];
    }
  }

  String _getJobTitle(String specialty) {
    switch (specialty) {
      case 'Software Engineering':
        return 'Software Engineer';
      case 'Product Management':
        return 'Product Manager';
      case 'UI/UX Design':
        return 'UI/UX Designer';
      case 'Data Science':
        return 'Data Scientist';
      case 'Marketing':
        return 'Marketing Specialist';
      case 'Cyber Security':
        return 'Security Analyst';
      default:
        return '$specialty Specialist';
    }
  }

  List<String> _getExperience(String specialty) {
    switch (specialty) {
      case 'Software Engineering':
        return [
          'Developed scalable web apps using React.js & Node.js.',
          'Optimized database queries, improving performance by 30%.',
        ];
      case 'Product Management':
        return [
          'Led development of 3 successful product launches.',
          'Increased user engagement by 45% through feature optimization.',
        ];
      case 'UI/UX Design':
        return [
          'Redesigned core product interface, improving user satisfaction by 40%.',
          'Created design system used across multiple products.',
        ];
      case 'Data Science':
        return [
          'Built predictive models that increased conversion rates by 25%.',
          'Developed data pipeline processing 500GB of data daily.',
        ];
      case 'Marketing':
        return [
          'Managed campaigns resulting in 35% increase in lead generation.',
          'Optimized content strategy, improving organic traffic by 50%.',
        ];
      case 'Cyber Security':
        return [
          'Implemented security protocols reducing vulnerabilities by 60%.',
          'Led security training for 200+ employees.',
        ];
      default:
        return [
          'Led key projects with measurable business impact.',
          'Collaborated with cross-functional teams to deliver results.',
        ];
    }
  }
}
