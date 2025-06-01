import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Models/theme_provider.dart';
import 'Models/controller/profile_controller.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the ProfileController
  await ProfileController.initialize();

  // Clear preferences to simulate first-time launch
  // Comment this out in production to keep user data
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(const AspireHub());
}

class AspireHub extends StatelessWidget {
  const AspireHub({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Aspire Hub',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeProvider.themeMode,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
