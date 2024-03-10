import 'package:chat/components/components.dart';
import 'package:flutter/material.dart';
import 'package:chat/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Import Dart's async library for Timer

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .5,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mobile Number Input
                  TextField(
                    controller: mailregisterController,
                    //keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Email ID',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // password Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 20,
                          controller: passController,
                          obscureText: showpassword,
                          decoration: InputDecoration(
                            labelText: 'Enter Password',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 20,
                          obscureText: confirmpassword,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            confirmpassword = !confirmpassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      submit_register();
                      //verifyOTP();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
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
        UserCredential userCredential =
            await _auth.signUpWithEmailPassword(mail, pass);
        if (userCredential.user != null) {
          await userCredential.user!.sendEmailVerification();
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
                          'A verification email has been sent to $mail. Please verify your email ID to complete registration.'),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          await userCredential.user!.sendEmailVerification();
                          showSnackBar(
                              context,
                              "Verification email resent. Please check your email.",
                              Colors.blue);
                        },
                        child: Text('Resend Verification Email'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await checkEmailVerified(userCredential.user!);
                        },
                        child: Text('I have verified my email.'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async{
                      verificationTimer?.cancel(); // Cancel the verification check
                      await userCredential.user!.delete();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );

          // Start checking for email verification
          await checkEmailVerified(userCredential.user!);
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
      print(user);
      if (user.emailVerified) {
        print(1);
        timer.cancel(); // Stop the timer when the email is verified
        Navigator.of(context).pop(); // Dismiss the verification dialog
        Navigator.pushNamedAndRemoveUntil(
            context, '/AuthGate', (_) => false); // Navigate to '/AuthGate'
      }
      else{
        print(2);
      }
    });
  }
}
