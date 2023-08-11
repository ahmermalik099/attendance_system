import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/firestore.dart';

class AddAttendanceScreen extends StatefulWidget {
  AddAttendanceScreen({super.key});

  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  String date = '2023-07-20';

  String UID = "";

  String status = "present";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Report', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Date:"),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(2023, 7, 20),
                onDateTimeChanged: (DateTime newDateTime) {
                  date = DateFormat('yyyy-MM-dd').format(newDateTime);
                },
              ),
            ),
            StudentListFuture(uid: UID),
            Container(
              color: Colors.blueAccent,
              child: DropdownButton(
                dropdownColor: Colors.blueAccent,
                value: status,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                items: <String>['present', 'absent', 'leave', 'leave?']
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
            ),
            ElevatedButton(
              onPressed: () {
                FirestoreSevice().addAttendance(UID, date, status);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentListFuture extends StatefulWidget {
  StudentListFuture({super.key, required this.uid});
  String uid;

  @override
  State<StudentListFuture> createState() => _StudentListFutureState();
}

class _StudentListFutureState extends State<StudentListFuture> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreSevice().allStudentsID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
              'No data available'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          // Map<String, dynamic> data = snapshot.data!.docs[0].data();
          List<String> students = snapshot.data!;
          students.add('');

          return Container(
            color: Colors.blueAccent,
            child: DropdownButton(
              dropdownColor: Colors.blueAccent,
              value: widget.uid,
              onChanged: (String? newValue) {
                setState(() {
                  widget.uid = newValue!;
                });
              },
              items: students.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
