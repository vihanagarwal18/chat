import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'pages/register.dart';
import 'pages/forget_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
