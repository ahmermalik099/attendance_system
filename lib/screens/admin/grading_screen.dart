import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestore.dart';

class GradingScreen extends StatelessWidget {
  const GradingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Grading', style: TextStyle(color: Colors.white)),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReportFuture(),
        ],
      ),
    );
  }
}

class ReportFuture extends StatelessWidget {
  const ReportFuture({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreSevice().gradingSystem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
              'No Attendances Found in these dates'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          // Map<String, dynamic> data = snapshot.data!.docs[0].data();
          Map<String, List<DocumentSnapshot<Map<String, dynamic>>>> myMap =
              snapshot.data!;

          List<dynamic> studentsGrade = [];
          myMap.forEach((key, value) {
            // key = userid, value = list of attendances by that user
            String grade = '';
            if (value.length == 26) {
              grade = 'A';
            } else {
              grade = 'F';
            }
            studentsGrade.add({
              'student_id': key,
              'attendanceCount': value.length,
              'grade': grade
            });
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...studentsGrade
                  .map((student) => AttendanceRow(
                        student: student,
                      ))
                  .toList(),
              ElevatedButton(
                onPressed: () {
                  FirestoreSevice().addGrade(studentsGrade);
                },
                child: Text('AssignGrades'),
              ),
            ],
          );
        }
      },
    );
  }
}

class AttendanceRow extends StatelessWidget {
  const AttendanceRow({super.key, required this.student});
  final Map<String, dynamic> student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Colors.blueAccent,
        width: double.infinity,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              student['student_id'].toString().substring(0, 10),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              student['attendanceCount'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              student['grade'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
