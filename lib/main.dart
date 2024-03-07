import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      //initialRoute: '/',
      routes: {
        '/HomeRoute': (context) => Homepage(),
        '/LoginRoute':(context) => LoginPage(),
        //'/':(context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //home: Homepage(),
    );
  }
}
