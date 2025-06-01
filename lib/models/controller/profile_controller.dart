import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User profile data model
class UserProfile {
  final String name;
  final String email;
  final String? personalityType;
  final String? careerSuggestion;

  UserProfile({
    required this.name,
    required this.email,
    this.personalityType,
    this.careerSuggestion,
  });

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'User',
      email: json['email'] ?? 'user@example.com',
      personalityType: json['personalityType'],
      careerSuggestion: json['careerSuggestion'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'personalityType': personalityType,
      'careerSuggestion': careerSuggestion,
    };
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    String? email,
    String? personalityType,
    String? careerSuggestion,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      personalityType: personalityType ?? this.personalityType,
      careerSuggestion: careerSuggestion ?? this.careerSuggestion,
    );
  }
}

class ProfileController {
  // Image notifier
  static final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  // User profile notifier
  static final ValueNotifier<UserProfile> profileNotifier =
      ValueNotifier<UserProfile>(
        UserProfile(name: 'User', email: 'user@example.com'),
      );

  // Initialize and load the saved data
  static Future<void> initialize() async {
    await Future.wait([loadSavedImage(), loadUserProfile()]);
  }

  // Save the image path to SharedPreferences
  static Future<void> saveImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', image.path);
    imageNotifier.value = image;
  }

  // Remove the saved image
  static Future<void> removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImagePath');
    imageNotifier.value = null;
  }

  // Load the saved image from SharedPreferences
  static Future<void> loadSavedImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profileImagePath');

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          imageNotifier.value = file;
        }
      }
    } catch (e) {
      debugPrint('Error loading profile image: $e');
    }
  }

  // Save user profile data
  static Future<void> saveUserProfile({
    String? name,
    String? email,
    String? personalityType,
    String? careerSuggestion,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get current profile
      final currentProfile = profileNotifier.value;

      // Create updated profile
      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        personalityType: personalityType,
        careerSuggestion: careerSuggestion,
      );

      // Save to SharedPreferences as JSON
      await prefs.setString(
        'userProfileData',
        '{"name":"${updatedProfile.name}",'
            '"email":"${updatedProfile.email}",'
            '"personalityType":${updatedProfile.personalityType != null ? '"${updatedProfile.personalityType}"' : 'null'},'
            '"careerSuggestion":${updatedProfile.careerSuggestion != null ? '"${updatedProfile.careerSuggestion}"' : 'null'}}',
      );

      // Update the notifier
      profileNotifier.value = updatedProfile;
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  // Save personality type specifically
  static Future<void> savePersonalityResult({
    required String personalityType,
    required String careerSuggestion,
  }) async {
    await saveUserProfile(
      personalityType: personalityType,
      careerSuggestion: careerSuggestion,
    );
  }

  // Load user profile data
  static Future<void> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('userProfileData');

      if (profileJson != null && profileJson.isNotEmpty) {
        try {
          // Try to parse the JSON string properly
          // This is a more robust approach than string splitting
          Map<String, dynamic> profileMap = {};

          // Extract name
          final nameRegex = RegExp(r'"name":"([^"]+)"');
          final nameMatch = nameRegex.firstMatch(profileJson);
          if (nameMatch != null && nameMatch.groupCount >= 1) {
            profileMap['name'] = nameMatch.group(1);
          }

          // Extract email
          final emailRegex = RegExp(r'"email":"([^"]+)"');
          final emailMatch = emailRegex.firstMatch(profileJson);
          if (emailMatch != null && emailMatch.groupCount >= 1) {
            profileMap['email'] = emailMatch.group(1);
          }

          // Extract personalityType
          final personalityTypeRegex = RegExp(r'"personalityType":"([^"]+)"');
          final personalityTypeMatch = personalityTypeRegex.firstMatch(
            profileJson,
          );
          if (personalityTypeMatch != null &&
              personalityTypeMatch.groupCount >= 1) {
            profileMap['personalityType'] = personalityTypeMatch.group(1);
          }

          // Extract careerSuggestion
          final careerSuggestionRegex = RegExp(r'"careerSuggestion":"([^"]+)"');
          final careerSuggestionMatch = careerSuggestionRegex.firstMatch(
            profileJson,
          );
          if (careerSuggestionMatch != null &&
              careerSuggestionMatch.groupCount >= 1) {
            profileMap['careerSuggestion'] = careerSuggestionMatch.group(1);
          }

          // Create UserProfile from the map
          final userProfile = UserProfile.fromJson(profileMap);

          // Update the notifier
          profileNotifier.value = userProfile;
        } catch (parseError) {
          debugPrint('Error parsing profile JSON: $parseError');
          // Fallback to basic profile if parsing fails
          profileNotifier.value = UserProfile(
            name: 'User',
            email: 'user@example.com',
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }
}

// For backward compatibility
class ProfileImageNotifier {
  static ValueNotifier<File?> get imageNotifier =>
      ProfileController.imageNotifier;

  static Future<void> initialize() async {
    await ProfileController.initialize();
  }

  static Future<void> saveImage(File image) async {
    await ProfileController.saveImage(image);
  }

  static Future<void> removeImage() async {
    await ProfileController.removeImage();
  }

  static Future<void> loadSavedImage() async {
    await ProfileController.loadSavedImage();
  }
}
