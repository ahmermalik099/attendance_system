import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';

class AllStudentsAttendanceScreen extends StatelessWidget {
  const AllStudentsAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('All Students Attendance',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adminaddattd');
            },
            child: Text('Add'),
          ),
          const StudentAttendanceFuture(),
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
    return StreamBuilder(
      stream: FirestoreSevice().getAllStudentsAttendances(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
              'No data available'); // Display a message if there's no data.
        } else if (snapshot.hasData){
          // has data
          List<dynamic> docs = snapshot.data!.docs;

          return Column(
            children: [
              Text('hi')
            ],
          );
        }
      },
    );
  }
}

class AttendanceRow extends StatefulWidget {
  AttendanceRow({super.key, required this.attendance, required this.item});

  final Map<String, dynamic> attendance;
  String item;

  @override
  State<AttendanceRow> createState() => _AttendanceRowState();
}

class _AttendanceRowState extends State<AttendanceRow> {
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
              widget.attendance['student_id'].toString().substring(0, 10),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              widget.attendance['date'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            DropdownButton(
              dropdownColor: Colors.blueAccent,
              value: widget.item,
              onChanged: (String? newValue) {
                setState(() {
                  widget.item = newValue!;
                });

                FirestoreSevice()
                        .updateAttendanceStatus(widget.attendance, widget.item);
              },
              items: <String>['present', 'absent', 'leave?', 'leave']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            IconButton(
              onPressed: () {
                FirestoreSevice().deleteAttendance(widget.attendance);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
