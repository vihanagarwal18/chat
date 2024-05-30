import 'package:chat/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'homepage.dart';
import 'package:chat/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showpassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .667,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: mailController,
                    //keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Email ID',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Password Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 20,
                          obscureText: showpassword,
                          //obscuringCharacter: '\$',
                          controller: passwordController,
                          keyboardType: TextInputType.number,
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

                  // Verify OTP Button
                  ElevatedButton(
                    onPressed: () {
                      submit_login();
                    },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/RegisterRoute',
                        (_) => false,
                      );
                    },
                    child: Text('For Registeration'),
                  ),
                  SizedBox(height: 20.0),
                  // foregt password
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/ForgetPassword', (_) => false);
                    },
                    child: Text('Forgot Password'),
                  ),
                ],
              ),
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
            showSnackBar(context, "Please do the verification first", Colors.red);
            authService.signOut();
            //logOut();
          }
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException caught: ${e.code}");
        if (e.code == 'invalid-credential') {
          showSnackBar(context, "Incorrect credentials or mail not registered", Colors.red);
        } else {
          showSnackBar(context, "An error occurred. Please try again.", Colors.red);
        }
      } catch (e) {
        showSnackBar(context, "An error occurred. Please try again.", Colors.red);
      }
    }
  }

  // void logOut() async {
  //   final _auth = AuthService();
  //   await _auth.signOut();
  // }
}
