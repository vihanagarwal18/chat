import 'package:flutter/material.dart';
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

  const MyTextField({
    super.key,
    required this.hinttext,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Theme.of(context).colorScheme.primary),
            ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText:hinttext,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green: Colors.grey.shade500,
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}



