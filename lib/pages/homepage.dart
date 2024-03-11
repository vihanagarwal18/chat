import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/my_drawer.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

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
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, // arrow vagra ka colour
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
