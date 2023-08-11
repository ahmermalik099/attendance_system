import 'package:attendance/services/storage.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              String img = (await StorageService().selectFile())!;
              img == "" ? null : setState(() {});
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AuthService().user!.photoURL != null
                  ? NetworkImage(AuthService().user!.photoURL!)
                  : const NetworkImage(
                      'https://i.pinimg.com/550x/04/64/6b/04646bc6ef384e1c564b25df6ef17291.jpg'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/markattd');
            },
            child: const Text('Mark Attendance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/markleave');
            },
            child: const Text('Mark Leave'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/viewattd');
            },
            child: const Text('View Attendance'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pop(context);
            },
            child: const Text('Logout'),
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
