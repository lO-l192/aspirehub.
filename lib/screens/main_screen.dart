import 'package:aspirehub3/screens/dash_board_screen.dart';
import 'package:aspirehub3/screens/previous_screen.dart';
import 'package:aspirehub3/screens/profile_screen.dart';
import 'package:aspirehub3/screens/setting_screen.dart';
import 'package:aspirehub3/screens/statics_screen.dart';

import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  // Constructor with initial tab index
  final int initialTabIndex;

  const MainScreen({super.key, this.initialTabIndex = 0});

  // Static method to navigate to a specific tab
  static void navigateToTab(BuildContext context, int tabIndex) {
    final mainScreenState = context.findAncestorStateOfType<_MainScreenState>();
    if (mainScreenState != null) {
      mainScreenState._onItemSelected(tabIndex);
    } else {
      // If we're not inside the MainScreen widget tree, navigate to MainScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(initialTabIndex: tabIndex),
        ),
        (route) => false,
      );
    }
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  // List of all screens - added PreviousScreen as the 5th screen
  final List<Widget> _screens = [
    const DashBoardScreen(isInTabView: true),
    const StaticsScreen(isInTabView: true),
    const ProfileScreen(isInTabView: true),
    const SettingScreen(isInTabView: true),
    const PreviousScreen(isInTabView: true),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
