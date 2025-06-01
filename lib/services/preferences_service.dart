import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle user preferences and app settings
class PreferencesService {
  static const String _userTypeKey = 'user_type';
  static const String _firstLaunchKey = 'first_launch';
  
  /// Save the user type (job seeker or company)
  static Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
  }
  
  /// Get the saved user type
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }
  
  /// Check if this is the first time the app is launched
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }
  
  /// Mark that the app has been launched before
  static Future<void> setAppLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }
  
  /// Clear all preferences (for logout or testing)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
