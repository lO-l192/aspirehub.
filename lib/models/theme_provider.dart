import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Load theme from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveThemeToPrefs();
    notifyListeners();
  }

  // Set specific theme
  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _saveThemeToPrefs();
    notifyListeners();
  }
}

// Light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF201B39),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF201B39),
    secondary: Color(0xFF6A5ACD),
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF1C1259),
    unselectedItemColor: Colors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFFF1F1F1),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontFamily: 'Mulish',
      fontWeight: FontWeight.w500,
    ),
  ),
);

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF6A5ACD),
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF201B39),
    secondary: Color(0xFF6A5ACD),
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFF6A5ACD),
    unselectedItemColor: Colors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF2C2C2C),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontFamily: 'Mulish',
      fontWeight: FontWeight.w500,
    ),
  ),
);
