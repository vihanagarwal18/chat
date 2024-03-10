import 'package:chat/auth/auth_service.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lenk",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          //logout button
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, // arrow vagra ka colour
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }

  void logout() async {
    final _auth = AuthService();
    await _auth.signOut();
    // Navigator.pop(context);
    // Navigator.pushNamed(context, '/HomeRoute');
  }
}
