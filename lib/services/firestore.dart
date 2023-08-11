import 'package:attendance/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<bool> checkAdminEmailExists(String email) async {
  try {

    // Query the Firestore collection for the document with the specified email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('admin') 
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // Check if the document with the specified email exists
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}




  Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    // currently logged in user chats
    return _firestore
        .collection('chats')
        .where('members', arrayContains: AuthService().user!.uid)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getChatsFuture() {
    // currently logged in user chats
    return _firestore
        .collection('chats')
        .where('members', arrayContains: AuthService().user!.uid)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatID) {
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .where('text', isEqualTo: 'heyyy')
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMessagesFuture(String chatID) {
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .get();
  }
}

class FireStoreDataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all quizes documents
  Stream<QuerySnapshot<Map<String, dynamic>>> getQuizData() {
    return _firestore.collection('Quiz').snapshots();
  }

  // Future to get all quizes documents
  Future<QuerySnapshot<Map<String, dynamic>>> getQuizDataFuture() {
    return _firestore.collection('Quiz').get();
  }

  // Future to get all questions of a specific quiz documents
  Future<QuerySnapshot<Map<String, dynamic>>> getQuestionsForQuiz(String id) {
    return _firestore
        .collection('Quiz')
        .doc(id)
        .collection('Questions')
        .get(); // Questions/blind-1
  }

  // Stream to get all questions of a specific quiz documents
  Stream<QuerySnapshot<Map<String, dynamic>>> getQuestionsForQuizStream(
      String id) {
    return _firestore
        .collection('Quiz')
        .doc(id)
        .collection('Questions')
        .snapshots(); // Questions/blind-1
  }
}

class FirestoreSevice {
  Stream<dynamic> getAttendanceStatusStream() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final status = FirebaseFirestore.instance
        .collection('attendance')
        .where('student_id', isEqualTo: AuthService().user!.uid)
        .where('date', isEqualTo: formattedDate)
        .snapshots();

    return status;
  }

  Future<bool> checkIfAlreadyMarked() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final alreadyMarkedRef = await FirebaseFirestore.instance
        .collection('attendance')
        .where('student_id', isEqualTo: AuthService().user!.uid)
        .where('date', isEqualTo: formattedDate)
        .where('attendance',
            whereIn: ['present', 'leave?', 'leave', 'absent']).get();

    return alreadyMarkedRef.size > 0 ? true : false;
  }

  Future<String> markAttendance() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    if (await checkIfAlreadyMarked()) {
      return 'Already Marked for the Day. Cant Change it';
    }

    // setDoc
    final ref = FirebaseFirestore.instance.collection('attendance').doc();

    await ref.set({
      'student_id': AuthService().user!.uid,
      'attendance': 'present',
      'date': formattedDate,
      // 'time': FieldValue.serverTimestamp()
    });
    return 'Attendance/Leave Marked';
  }

  Future<String> requestLeave() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    if (await checkIfAlreadyMarked()) {
      return 'Already Marked for the Day. Cant Change it';
    }

    final ref = FirebaseFirestore.instance.collection('attendance').doc();

    await ref.set({
      'student_id': AuthService().user!.uid,
      'date': formattedDate,
      'attendance': 'leave?'
    });
    return 'Attendance/Leave Marked';
  }

  Future<dynamic> getStudentAttendances() async {
    final attendances = await FirebaseFirestore.instance
        .collection('attendance')
        .where('student_id', isEqualTo: AuthService().user!.uid)
        .get();

    return attendances;
  }

  // Admin Functions

  Stream<dynamic> getAllStudentsAttendances() {
    final attendances =
        FirebaseFirestore.instance.collection('attendance').snapshots();

    return attendances;
  }

  // Update Attendance Status
  Future<void> updateAttendanceStatus(
      Map<String, dynamic> attendance, String newValue) async {
    final ref = FirebaseFirestore.instance
        .collection('attendance')
        .doc(attendance['doc_id']);

    ref.update({
      'attendance': newValue,
    });
  }

  // Delete Attendance
  Future<void> deleteAttendance(Map<String, dynamic> attendance) async {
    final ref = FirebaseFirestore.instance
        .collection('attendance')
        .doc(attendance['doc_id']);

    await ref.delete();
  }

  Future<dynamic> getReport(String startDate, String endDate) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('attendance')
        .where('date',
            isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();

    return querySnapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLeaveRequests() {
    final leaveRequests = FirebaseFirestore.instance
        .collection('attendance')
        .where('attendance', isEqualTo: 'leave?')
        .get();

    return leaveRequests;
  }

  Future<Map<String, List<DocumentSnapshot<Map<String, dynamic>>>>>
      gradingSystem() async {
    final ref = await FirebaseFirestore.instance.collection('attendance').get();
    Map<String, List<DocumentSnapshot<Map<String, dynamic>>>> groupedRecords =
        {};
    // Adding keys to the map
    for (var doc in ref.docs) {
      // doc.data()
      String studentID = doc.data()['student_id'];
      if (!groupedRecords.containsKey(studentID)) {
        groupedRecords[studentID] = [];
      }
      groupedRecords[studentID]!.add(doc);
    }

    return groupedRecords;
  }

  Future<List<String>> allStudentsID() async {
    final ref = await FirebaseFirestore.instance.collection('attendance').get();
    List<String> uids = [];
    // Adding keys to the map
    for (var doc in ref.docs) {
      // doc.data()
      String studentID = doc.data()['student_id'];
      if (!uids.contains(studentID)) {
        uids.add(studentID);
      }
    }
    return uids;
  }

  Future<void> addGrade(List<dynamic> studentsGrade) async {
    dynamic ref = FirebaseFirestore.instance.collection('grades');
    for (Map<String, dynamic> student in studentsGrade) {
      ref = ref.doc(student['student_id']);
      await ref.set({
        'student_id': student['student_id'],
        'attendanceCount': student['attendanceCount'],
        'grade': student['grade']
      });
    }
  }

  Future<void> addAttendance(String UID, String date, String status) async {
    // If no clash then create it
    if (await checkIfAlreadyMarkedArguments(UID, date, status)) {
      return;
    }
    final ref = FirebaseFirestore.instance.collection('attendance').doc();

    await ref.set({
      'student_id': UID,
      'attendance': status,
      'date': date,
    });
  }

  Future<bool> checkIfAlreadyMarkedArguments(
      String UID, String date, String status) async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final alreadyMarkedRef = await FirebaseFirestore.instance
        .collection('attendance')
        .where('student_id', isEqualTo: AuthService().user!.uid)
        .where('date', isEqualTo: formattedDate)
        .where('attendance',
            whereIn: ['present', 'leave?', 'leave', 'absent']).get();

    return alreadyMarkedRef.size > 0 ? true : false;
  }
}
