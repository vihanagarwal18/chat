
import 'package:flutter/material.dart';

void showSnackBar(context, String msg,Color clr) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: clr
    ),
  );
}
