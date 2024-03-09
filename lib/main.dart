import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login_page.dart';
import 'register.dart';
import 'forget_password.dart';
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
        '/RegisterRoute':(context) => RegisterPage(),
        '/ForgetPassword' :(context) => ForgetPassword(),
        //'/':(context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //home: Homepage(),
    );
  }
}
