import 'package:chat/components/components.dart';
import 'package:chat/constants/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showpassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lenk_bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth = constraints.maxWidth > 600
                    ? constraints.maxWidth * 0.5
                    : constraints.maxWidth * 0.9;
                double containerHeight = constraints.maxHeight > 800
                    ? constraints.maxHeight * 0.667
                    : constraints.maxHeight * 0.8;

                return Container(
                  width: containerWidth,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/logo.png', 
                        height: 50,
                      ),
                      SizedBox(height: 20.0),
                      // Welcome Text
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Glad to see you again 👋\nLogin to your account below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Google Sign-In Button
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // Implement Google Sign-In
                      //   },
                      //   icon: Icon(Icons.login, color: Colors.red),
                      //   label: Text('Continue with Google'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.white,
                      //     foregroundColor: Colors.black,
                      //     side: BorderSide(color: Colors.grey.shade300),
                      //     padding: EdgeInsets.symmetric(vertical: 15),
                      //     textStyle: TextStyle(fontSize: 16),
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),
                      // Email TextField
                     TextField(
                        controller: mailController,
                        decoration: InputDecoration(
                          hintText: 'enter email...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Password TextField
                      TextField(
                        controller: passwordController,
                        obscureText: showpassword,
                        decoration: InputDecoration(
                          hintText: 'enter password...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              color: Colors.grey.shade500,
                              showpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                showpassword = !showpassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            submit_login();
                          },
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lenk_purple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Registration Link
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/RegisterRoute',
                            (_) => false,
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'Sign up for Free',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void submit_login() async {
    String mailid = mailController.text;
    String password = passwordController.text;
    final authService = AuthService();

    if (mailid.isEmpty || password.isEmpty) {
      showSnackBar(context, "Fill both the fields", Colors.red);
    } else if (!mailid.isEmpty) {
      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailid,
          password: password,
        );
        print(userCredential.toString());
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (user.emailVerified) {
            print("User is verified");
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/AuthGate',
              (_) => false,
            );
          } else {
            print("User is not verified");
            showSnackBar(
                context, "Please do the verification first", Colors.red);
            authService.signOut();
          }
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException caught: ${e.code}");
        if (e.code == 'invalid-credential') {
          showSnackBar(context, "Incorrect credentials or mail not registered",
              Colors.red);
        } else {
          showSnackBar(
              context, "An error occurred. Please try again.", Colors.red);
        }
      } catch (e) {
        showSnackBar(
            context, "An error occurred. Please try again.", Colors.red);
      }
    }
  }
}