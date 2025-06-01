import 'dart:io';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/models/controller/profile_controller.dart';
import 'package:aspirehub3/screens/dash_board_screen.dart';
import 'package:aspirehub3/screens/setting_screen.dart';
import 'package:aspirehub3/screens/statics_screen.dart';
import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:aspirehub3/widgets/custom_button.dart';
import 'package:aspirehub3/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isInTabView;

  const ProfileScreen({super.key, this.isInTabView = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  int _selectedIndex = 2;

  Future<void> _showImageSourceActionSheet() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor =
        isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Original color for light mode

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(77),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              const Divider(height: 1),

              // Grid of options similar to social media apps
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 10,
                  runSpacing: 15,
                  children: [
                    // Camera option
                    _buildGridOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      color: primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),

                    // Camera (No Crop) option
                    _buildGridOption(
                      icon: Icons.camera,
                      label: 'Cam (No Crop)',
                      color: primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageNoCrop(ImageSource.camera);
                      },
                    ),

                    // Gallery option
                    _buildGridOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      color: primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),

                    // Gallery (No Crop) option
                    _buildGridOption(
                      icon: Icons.image,
                      label: 'No Crop',
                      color: primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageNoCrop(ImageSource.gallery);
                      },
                    ),

                    // Remove option (if image exists)
                    if (_image != null)
                      _buildGridOption(
                        icon: Icons.delete,
                        label: 'Remove',
                        color: Colors.red,
                        onTap: () {
                          Navigator.pop(context);
                          _removeProfileImage();
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Cancel button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: CustomButton(
                  borderRadius: 12,
                  buttontext: Colors.white,
                  width: double.infinity,
                  height: 45,
                  color: Colors.grey.shade400,
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Pick image
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image == null || !mounted) {
        return; // User canceled or context is no longer valid
      }

      // Create a file from the picked image and save directly
      final File imageFile = File(image.path);
      _saveProfileImage(imageFile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Method to pick image without cropping
  Future<void> _pickImageNoCrop(ImageSource source) async {
    try {
      // Pick image
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image == null || !mounted) {
        return; // User canceled or context is no longer valid
      }

      // Create a file from the picked image and save directly
      final File imageFile = File(image.path);
      _saveProfileImage(imageFile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _saveProfileImage(File imageFile) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor =
        isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Original color for light mode

    // Update the state with the new image
    setState(() {
      _image = imageFile;
    });

    // Save the image directly
    ProfileController.saveImage(imageFile);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile image updated successfully!'),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _removeProfileImage() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor =
        isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Original color for light mode

    try {
      setState(() {
        _image = null;
      });

      // Clear the image in the ProfileController
      await ProfileController.removeImage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile image removed'),
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Load the image from the ProfileController
  Future<void> _loadProfileImage() async {
    // The image is already loaded in the ProfileController
    // We just need to update the local state
    setState(() {
      _image = ProfileController.imageNotifier.value;
    });

    // Listen for changes to the image
    ProfileController.imageNotifier.addListener(_updateLocalImage);
  }

  // Update the local image when the ProfileController changes
  void _updateLocalImage() {
    if (mounted) {
      setState(() {
        _image = ProfileController.imageNotifier.value;
      });
    }
  }

  // Load user profile data
  void _loadUserProfile() {
    // Get current profile data
    final userProfile = ProfileController.profileNotifier.value;

    // Set the text controllers
    nameController.text = userProfile.name;
    emailController.text = userProfile.email;

    // Listen for changes to the profile
    ProfileController.profileNotifier.addListener(_updateProfileFields);
  }

  // Update the text fields when the profile changes
  void _updateProfileFields() {
    if (mounted) {
      final userProfile = ProfileController.profileNotifier.value;
      setState(() {
        nameController.text = userProfile.name;
        emailController.text = userProfile.email;
      });
    }
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor:
          isDarkMode
              ? const Color(0xFF2C2C2C) // Dark mode input background
              : const Color(
                0xFFF5F5F5,
              ), // Light mode input background (slightly lighter than before)
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              isDarkMode
                  ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                  : const Color(0xFF201B39), // Primary color for light mode
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        fontSize: 14,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load the profile image from the ProfileController
    _loadProfileImage();
    // Load the user profile data
    _loadUserProfile();
  }

  @override
  void dispose() {
    // Remove the listeners when the widget is disposed
    ProfileController.imageNotifier.removeListener(_updateLocalImage);
    ProfileController.profileNotifier.removeListener(_updateProfileFields);

    // Dispose of the text controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Profile Image
                      ProfileAvatar(
                        radius: screenWidth * 0.15,
                        showShadow: true,
                        onTap: _showImageSourceActionSheet,
                      ),
                      // Camera Icon Overlay
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                themeProvider.isDarkMode
                                    ? const Color(
                                      0xFF6A5ACD,
                                    ) // Slateblue for dark mode
                                    : const Color(
                                      0xFF1C1259,
                                    ), // Original color for light mode
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User name",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration("Enter Your Username"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration("Enter your email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          "Enter your password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  isDarkMode
                                      ? const Color(
                                        0xFF6A5ACD,
                                      ) // Slateblue for dark mode
                                      : const Color(
                                        0xFF201B39,
                                      ), // Primary color for light mode
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (!RegExp(
                            r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}$',
                          ).hasMatch(value)) {
                            return 'Password must include letters and numbers';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: _inputDecoration(
                          "Confirm your password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  isDarkMode
                                      ? const Color(
                                        0xFF6A5ACD,
                                      ) // Slateblue for dark mode
                                      : const Color(
                                        0xFF201B39,
                                      ), // Primary color for light mode
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    borderRadius: 12,
                    buttontext: Colors.white,
                    width: 171,
                    height: 33,
                    color:
                        themeProvider.isDarkMode
                            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                            : const Color(
                              0xFF1C1259,
                            ), // Original color for light mode
                    text: 'Save Changes',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the user profile data
                        ProfileController.saveUserProfile(
                          name: nameController.text,
                          email: emailController.text,
                        );

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profile saved!'),
                            backgroundColor:
                                themeProvider.isDarkMode
                                    ? const Color(0xFF6A5ACD)
                                    : const Color(0xFF1C1259),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          widget.isInTabView
              ? null
              : NavBar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });

                  // Navigate to the appropriate screen based on the selected index
                  if (index != 2) {
                    // If not the current profile screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          switch (index) {
                            case 0: // Dashboard
                              return const DashBoardScreen();
                            case 1: // Statistics
                              return const StaticsScreen();
                            case 3: // Settings
                              return const SettingScreen();
                            default:
                              return const ProfileScreen();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
    );
  }
}
