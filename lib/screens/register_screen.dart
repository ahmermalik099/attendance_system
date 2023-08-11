
import 'package:attendance/services/auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  String email = '', password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
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
                final user = await AuthService().registerUser(email, password);
                if(user != null){
                  Navigator.pushNamed(context, '/home');
                }else{
                  var snackBar = SnackBar(content: Text('User not found'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } catch (e){
                var snackBar = SnackBar(content: Text(e.toString()));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}
