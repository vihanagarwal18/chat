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
