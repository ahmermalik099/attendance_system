import 'package:attendance/services/auth.dart';
import 'package:flutter/material.dart';

import '../../services/firestore.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('View Attendances',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("All the Attendances: "),
          // list of all the attendances using a future builder
          const StudentAttendanceFuture(),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
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

class StudentAttendanceFuture extends StatelessWidget {
  const StudentAttendanceFuture({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreSevice().getStudentAttendances(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
              'No data available'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          // Map<String, dynamic> data = snapshot.data!.docs[0].data();
          List<dynamic> docs = snapshot.data!.docs;
          List<dynamic> attendances = docs.map((doc) => doc.data()).toList();

          return Column(
            children: [
              ...attendances
                  .map((attendance) => AttendanceRow(attendance: attendance))
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
        color: Colors.deepPurple,
        width: double.infinity,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AuthService().user!.photoURL != null
                  ? NetworkImage(AuthService().user!.photoURL!)
                  : const NetworkImage(
                      'https://i.pinimg.com/550x/04/64/6b/04646bc6ef384e1c564b25df6ef17291.jpg'),
            ),
            Text(
              attendance['date'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              getStatus(attendance['attendance'].toString()),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

String getStatus(String attendanceStatus) {
  String status = attendanceStatus;
  if (attendanceStatus == 'present') {
    status = 'Already Marked';
  } else if (attendanceStatus == 'leave?') {
    status = 'Leave is Pending';
  } else if (attendanceStatus == 'leave') {
    status = 'Leave Approved';
  } else if (attendanceStatus == 'absent') {
    status = 'Absent';
  }
  return status;
}
