import 'package:flutter/material.dart';
import 'user_type_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {"title": "Welcome To", "subtitle": "Aspire Hub"},
    {
      "title": "Discover Yourself",
      "subtitle":
          "Not sure which career suits you?\nLet's explore your personality together.",
    },
    {
      "title": "Personalized Career Match",
      "subtitle":
          "We analyze your traits and match\nyou with careers that fit you best.",
    },
    {
      "title": "Learn, Improve, Shine",
      "subtitle":
          "Get tailored courses, track your\ngrowth, and prepare for real job offers",
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _skipToEnd() {
    _controller.animateToPage(
      onboardingData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _goToNextScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const UserTypeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == onboardingData.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0A36),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: _goBack,
                        )
                      else
                        const SizedBox(width: 48),
                      if (_currentPage < onboardingData.length - 1 &&
                          _currentPage > 0)
                        TextButton(
                          onPressed: _skipToEnd,
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardingData.length,
                    onPageChanged: _onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),

                            index == 0
                                ? const Icon(
                                  Icons.wb_sunny_outlined,
                                  size: 100,
                                  color: Colors.white,
                                )
                                : const SizedBox(height: 100),

                            const SizedBox(height: 30),

                            Text(
                              data["title"]!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data["subtitle"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                              textAlign:
                                  index == 0
                                      ? TextAlign.center
                                      : TextAlign.start,
                            ),

                            const Spacer(flex: 2),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onboardingData.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == _currentPage ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            index == _currentPage
                                ? Colors.white
                                : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
              ],
            ),

            Positioned(
              bottom: 30,
              right: 30,
              child: AnimatedSlide(
                offset: isLastPage ? Offset.zero : const Offset(1, 0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: isLastPage ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _goToNextScreen,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF0F0A36),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
