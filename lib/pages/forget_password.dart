import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/components.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController mailregisterController = TextEditingController();
  // TextEditingController passController = TextEditingController();
  // TextEditingController confirmpassController = TextEditingController();
  // TextEditingController otpController = TextEditingController();
  // bool showpassword = false;
  // bool confirmpassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
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

                      // TextField(
                      //   controller: otpController,
                      //   keyboardType: TextInputType.phone,
                      //   decoration: InputDecoration(
                      //     labelText: 'Enter Otp',
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 20.0),
                      // // password Input
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextField(
                      //         maxLength: 20,
                      //         obscureText: showpassword,
                      //         controller: passController,
                      //         decoration: InputDecoration(
                      //           labelText: 'Enter Password',
                      //         ),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           showpassword = !showpassword;
                      //         });
                      //       },
                      //       icon: Icon(Icons.remove_red_eye_rounded),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 20.0),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextField(
                      //         maxLength: 20,
                      //         obscureText: confirmpassword,
                      //         controller: confirmpassController,
                      //         decoration: InputDecoration(
                      //           labelText: 'Confirm Password',
                      //         ),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           confirmpassword = !confirmpassword;
                      //         });
                      //       },
                      //       icon: Icon(Icons.remove_red_eye_rounded),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          submit_finish();
                          //verifyOTP();
                        },
                        child: Text('Reset Password'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/AuthGate', (_) => false);
                          },
                          child: Text('Go to Login Page')),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/RegisterRoute', (_) => false);
                          },
                          child: Text('Go to Register Page')),
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

  void submit_finish() async {
    String mail = mailregisterController.text;
    // String pass = passController.text;
    // String confirmpass = confirmpassController.text;
    // String otp = otpController.text;

    if (mail.isEmpty) {
      showSnackBar(context, "Enter the mail first", Colors.red);
      return;
    }
    //else if (pass != confirmpass) {
    //   showSnackBar(context, "Confirm Password does not match", Colors.red);
    //}
    // else {
    // try{
    //   await FirebaseAuth.instance.sendPasswordResetEmail(email: mailregisterController.text.trim());
    //   // perform logic for checking correct otp and change password
    //   showSnackBar(context, "Reset Password email sent on  ${mailregisterController.text} ", Colors.green);
    //   //Navigator.pushNamedAndRemoveUntil(context, '/LoginRoute', (_) => false);
    // } on FirebaseAuthException catch(e){

    try {
      // Check if the email is registered
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(mail);
      if (signInMethods.isEmpty) {
        showSnackBar(context, "This email is not registered", Colors.red);
        return;
      }

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
      showSnackBar(context, "Reset Password email sent to $mail", Colors.green);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Error: ${e.message}", Colors.red);
    }
  }
}
