import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';

class MarkLeaveScreen extends StatefulWidget {
  const MarkLeaveScreen({super.key});

  @override
  State<MarkLeaveScreen> createState() => _MarkLeaveScreenState();
}

class _MarkLeaveScreenState extends State<MarkLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Mark Leave', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LeaveStatusStream(),
          ElevatedButton(
            onPressed: () async {
              String response = await FirestoreSevice().requestLeave();

              var snackBar = SnackBar(content: Text(response));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {});
            },
            child: const Text('Request for Leave'),
          ),
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

class LeaveStatusStream extends StatelessWidget {
  const LeaveStatusStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreSevice().getAttendanceStatusStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
              'Not Marked'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          Map<String, dynamic> data = snapshot.data!.docs[0].data();
          String status = '';
          if (data['attendance'] == 'present') {
            status = 'Already Marked';
          } else if (data['attendance'] == 'leave?') {
            status = 'Leave is Pending';
          } else if (data['attendance'] == 'leave') {
            status = 'Leave Approved';
          } else if (data['attendance'] == 'absent') {
            status = 'Absent';
          }
          return Text("Attendance Status: ${status}");
        }
      },
    );
  }
}
