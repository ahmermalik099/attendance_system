import 'package:attendance/screens/admin/add_attendance.dart';
import 'package:attendance/screens/admin/admin_panel_screen.dart';
import 'package:attendance/screens/admin/all_students_attendance.dart';
import 'package:attendance/screens/admin/approve_leave_screen.dart';
import 'package:attendance/screens/admin/grading_screen.dart';
import 'package:attendance/screens/admin/report_screen.dart';
import 'package:attendance/screens/user/home_screen.dart';
import 'package:attendance/screens/login_screen.dart';
import 'package:attendance/screens/user/mark_attendance_screen.dart';
import 'package:attendance/screens/user/mark_leave_screen.dart';
import 'package:attendance/screens/register_screen.dart';
import 'package:attendance/screens/user/view_attendance.dart';
import 'package:flutter/material.dart';

import "package:firebase_core/firebase_core.dart";
import "firebase_options.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/markattd': (context) => const MarkAttendanceScreen(),
        '/markleave': (context) => const MarkLeaveScreen(),
        '/viewattd': (context) => const ViewAttendanceScreen(),
        '/adminpanel': (context) => const AdminPanelScreen(),
        '/adminallstudents': (context) => const AllStudentsAttendanceScreen(),
        '/adminreport': (context) => ReportScreen(),
        '/adminapproveleave': (context) => const ApproveLeaveScreen(),
        '/admingrading': (context) => const GradingScreen(),
        '/adminaddattd': (context) => AddAttendanceScreen(),
      },
    );
  }
}
