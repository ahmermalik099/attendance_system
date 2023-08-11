import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestore.dart';

class ApproveLeaveScreen extends StatelessWidget {
  const ApproveLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title:
            const Text('Approve Leave', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ApproveLeaveStream(),
        ],
      ),
    );
  }
}

class ApproveLeaveStream extends StatelessWidget {
  const ApproveLeaveStream({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreSevice().getLeaveRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text(
              'No Pending leaves in these dates'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          // Map<String, dynamic> data = snapshot.data!.docs[0].data();

          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data! 
                                as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

          List<Map<String, dynamic>> leaves = docs.map((doc) => doc.data()).toList();



          List<dynamic> attendances = docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['doc_id'] = doc.id; // Add the document ID to the map
            return data;
          }).toList();

          return Column(
            children: [
              ...attendances
                  .map((attendance) => AttendanceRow(
                        attendance: attendance,
                      ))
                  .toList()
            ],
          );
        }
      },
    );
  }
}

class AttendanceRow extends StatelessWidget {
  const AttendanceRow({super.key, required this.attendance});
  final Map<String, dynamic> attendance;

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
              attendance['student_id'].toString().substring(0, 10),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              attendance['date'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              attendance['attendance'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                FirestoreSevice().updateAttendanceStatus(attendance, 'leave');
              },
              icon: const Icon(
            Icons.check_circle,
              ),
              color: Colors.greenAccent.shade100,
            ),
            IconButton(
              onPressed: () {
                FirestoreSevice().updateAttendanceStatus(attendance, 'absent');
              },
              icon: const Icon(
            Icons.heart_broken,
              ),
              color: Colors.redAccent.shade100,
            )
          ],
        ),
      ),
    );
  }
}
