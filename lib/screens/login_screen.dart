import 'dart:developer';

import 'package:attendance/services/auth.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            onChanged: (value) => email = value,
          ),
          TextField(
            onChanged: (value) => password = value,
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              try{
                // If admin document exists
                bool isFound = await FirestoreService().checkAdminEmailExists(email);
                if (isFound){
                  // Now we login using Firebase Auth
                  final user = await AuthService().emailLogin(email, password);
                  if(user != null){
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PreApp()));
                  } 
                }else{
                  var snackBar = SnackBar(content: Text('Admin Not Found'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } catch (e){
                var snackBar = SnackBar(content: Text(e.toString()));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('New User? Create Account'),
          ),
        ],
      ),
    );
  }
}
