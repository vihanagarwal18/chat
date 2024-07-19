import 'package:chat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

void showSnackBar(context, String msg,Color clr) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: clr
    ),
  );
}

class MyTextField extends StatelessWidget {

  final String hinttext;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.hinttext,
    required this.obscureText,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hinttext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode=Provider.of<ThemeProvider>(context,listen:false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500): (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}