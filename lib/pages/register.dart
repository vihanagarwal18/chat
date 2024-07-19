// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:chat/components/components.dart';
import 'package:chat/constants/contants.dart';
import 'package:flutter/material.dart';
import 'package:chat/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
// Import Dart's async library for Timer

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController mailregisterController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  bool showpassword = true;
  bool confirmpassword = true;
  Timer? verificationTimer; // Declare the Timer
  bool canResendEmail = true; // Track if the resend button can be pressed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lenk_bg, // Match background color
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
                    color: Colors.white, // Match container color
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
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Join us and start chatting!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Email TextField
                      TextField(
                        controller: mailregisterController,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email ID',
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
                        maxLength: 20,
                        controller: passController,
                        obscureText: showpassword,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
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
                            onPressed: () {
                              setState(() {
                                showpassword = !showpassword;
                              });
                            },
                            icon: Icon(
                              showpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Confirm Password TextField
                      TextField(
                        maxLength: 20,
                        obscureText: confirmpassword,
                        controller: confirmpassController,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                            onPressed: () {
                              setState(() {
                                confirmpassword = !confirmpassword;
                              });
                            },
                            icon: Icon(
                              confirmpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            submit_register();
                          },
                          child: Text('Submit'),
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
                      // Login Link
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/AuthGate',
                            (_) => false,
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: 'Login',
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

  void submit_register() async {
    String mail = mailregisterController.text;
    String pass = passController.text;
    String confirmpass = confirmpassController.text;

    if (mail.isEmpty || pass.isEmpty || confirmpass.isEmpty) {
      showSnackBar(context, "Enter all details", Colors.red);
    } else if (pass != confirmpass) {
      showSnackBar(context, "Confirm Password does not match", Colors.red);
    } else {
      final _auth = AuthService();
      try {
        User user = await _auth.signUpWithEmailPassword(mail, pass);
        if (user != null) {
          await user.sendEmailVerification();

          await checkEmailVerified(user);
          // Show dialog informing the user to verify their email
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevents closing the dialog by tapping outside
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Verify Your Email'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'A verification email has been sent to $mail. Please verify your email ID to complete registration.It will redirect automatically after verification'),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: canResendEmail
                            ? () async {
                                try {
                                  await user.reload();
                                  user = FirebaseAuth.instance.currentUser!;
                                  await user.sendEmailVerification();
                                  showSnackBar(
                                      context,
                                      "Verification email resent. Please check your email.",
                                      Colors.blue);
                                  setState(() {
                                    canResendEmail = false;
                                  });
                                  Timer(Duration(seconds: 45), () {
                                    setState(() {
                                      canResendEmail = true;
                                    });
                                  });
                                } catch (e) {
                                  showSnackBar(
                                      context,
                                      "Failed to resend verification email: $e",
                                      Colors.red);
                                }
                              }
                            : null,
                        child: Text('Resend Verification Email'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: mail,
                              password: pass,
                            );
                            print(userCredential.toString());
                            await user.reload();
                            final updatedUser =
                                FirebaseAuth.instance.currentUser;
                            await checkEmailVerified(updatedUser!);
                          } catch (e) {
                            showSnackBar(context, "Failed to verify email: $e",
                                Colors.red);
                          }
                        },
                        child: Text('I have verified my email.'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      verificationTimer
                          ?.cancel(); // Cancel the verification check
                      await user.delete();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
          // Start checking for email verification
          await checkEmailVerified(user);
        } else {
          showSnackBar(context, "Registration Failed", Colors.red);
        }
      } catch (e) {
        showSnackBar(context, "Registration Failed: $e", Colors.red);
      }
    }
  }

  Future<void> checkEmailVerified(User user) async {
    const checkInterval = Duration(seconds: 5);

    verificationTimer = Timer.periodic(checkInterval, (timer) async {
      await user.reload(); // Reload user to get the latest status
      User? updatedUser =
          FirebaseAuth.instance.currentUser; // Get the updated user
      print(updatedUser);

      if (updatedUser != null && updatedUser.emailVerified) {
        print(1);
        timer.cancel(); // Stop the timer when the email is verified
        Navigator.of(context).pop(); // Dismiss the verification dialog
        showSnackBar(
            context, "Verified and logged in successfully", Colors.green);
        Navigator.pushNamedAndRemoveUntil(
            context, '/AuthGate', (_) => false); // Navigate to '/AuthGate'
      } else {
        print(2);
        // showSnackBar(context, "Verify the mail first", Colors.red);
      }
    });
  }

  // void deleteaccount() async {
  //   final _auth = AuthService();
  //   String mail = mailregisterController.text;
  //   String pass = passController.text;
  //
  //   try {
  //     // Sign in the user to get the current user object
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: mail,
  //       password: pass,
  //     );
  //     User user = userCredential.user!;
  //
  //     // Delete the user account
  //     await user.delete();
  //     await _auth.signOut();
  //     showSnackBar(context, "Account deleted successfully", Colors.green);
  //   } catch (e) {
  //     showSnackBar(context, "Account deletion failed: $e", Colors.red);
  //   }
  //   // await _auth.signOut();
  //   // // User user= await _auth.signInWithEmailPassword(mail, pass);
  //   // await user.delete();
  // }
}
