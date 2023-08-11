import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;


  Future<User?> emailLogin(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
  
  Future<User?> registerUser(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}