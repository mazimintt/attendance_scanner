import 'package:attendance_scanner/homepage.dart';
import 'package:attendance_scanner/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_screen.dart';
import 'student_management_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'attendance_provider.dart';
import 'student_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AttendanceProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biometric Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/student_home': (context) => const StudentHomeScreen(), // Add this
        '/attendance': (context) => const AttendanceScreen(),
        '/students': (context) => const StudentManagementScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}