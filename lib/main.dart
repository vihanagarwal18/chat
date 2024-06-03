import 'package:chat/auth/auth_gate.dart';
//import 'package:chat/themes/light_mode.dart';
import 'package:chat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'pages/register.dart';
import 'pages/forget_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/setting.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
        create:(context) => ThemeProvider(),
        child:MyApp(),
      ),
      // MyApp()
  );
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
        '/AuthGate': (context) => AuthGate(),
        '/SettingPage':(context) => Setting(),
        //'/':(context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: AuthGate(),
      // theme: lightMode,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
