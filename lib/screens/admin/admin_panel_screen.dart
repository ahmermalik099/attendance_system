import 'package:flutter/material.dart';

import '../../services/auth.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Admin Panel',
           style: TextStyle(color: Colors.white)
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminallstudents');
            },
            child: const Text('All Students Attendance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminreport');
            },
            child: const Text('Report'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminapproveleave');                
            },
            child: const Text('Leave Requests'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admingrading');
            },
            child: const Text('Grading System'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pop(context);
            },
            child: const Text('Logout'),
          ),
          const SizedBox(
            width: double.infinity,
            height: 1,
          ),
        ],
      ),
    );
  }
}