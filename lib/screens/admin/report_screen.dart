import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../services/firestore.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String fromDate='2023-07-20', toDate='2023-07-25';

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
            Text("From:"),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(2023, 7, 20),
                onDateTimeChanged: (DateTime newDateTime) {
                  fromDate = DateFormat('yyyy-MM-dd').format(newDateTime);
      
                },
              ),
            ),
            Text('To'),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(2023, 7, 25),
                onDateTimeChanged: (DateTime newDateTime) {
                  // Do something
                  toDate= DateFormat('yyyy-MM-dd').format(newDateTime);
      
                },
              ),
            ),
      
            ElevatedButton(
              onPressed: (){
                setState(() {
                  
                });
              },
              child: Text('Search'),
            ),
            ReportFuture(from: fromDate, to: toDate)
          ],
        ),
      ),
    );
  }
}


class ReportFuture extends StatelessWidget {
  const ReportFuture({super.key, required this.to, required this.from});
  final String from, to;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreSevice().getReport(from, to),
       builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No Attendances Found in these dates'); // Display a message if there's no data.
        } else {
          // Display the data from Firestore in your UI.
          // Map<String, dynamic> data = snapshot.data!.docs[0].data();
          List<dynamic> docs = snapshot.data!.docs;
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
              attendance['student_id'].toString().substring(0,10),
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
          ],
        ),
      ),
    );
  }
}
