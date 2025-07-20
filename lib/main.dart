import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/views/dashboard/view.dart';


void main() {
  // Ensures Flutter binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for desktop (landscape primarily)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  runApp(const CodyZeaApp());
}

// Main application widget - sets up theme and navigation
class CodyZeaApp extends StatelessWidget {
  const CodyZeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cody Zea - Food Ordering',
      debugShowCheckedModeBanner: false,

      // Dark theme configuration matching the design
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35), // Orange accent color
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Dark background
        cardColor: const Color(0xFF2A2A2A), // Card background

        // AppBar theme for consistent header styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        // Text theme for consistent typography
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      // Light theme configuration for system theme switching
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: Colors.white,
        cardColor: const Color(0xFFF5F5F5),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F5),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      // Use system theme by default
      themeMode: ThemeMode.system,
      home: const DashboardView(),
    );
  }
}
