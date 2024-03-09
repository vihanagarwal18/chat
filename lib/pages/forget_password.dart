import 'package:flutter/material.dart';
import '../components/components.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController mailregisterController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController=TextEditingController();
  TextEditingController otpController=TextEditingController();
  bool showpassword=false;
  bool confirmpassword=false;
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
                  border: Border.all(), borderRadius: BorderRadius.circular(20)),
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

                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Enter Otp',
                    ),
                  ),

                  SizedBox(height: 20.0),
                  // password Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 20,
                          obscureText: showpassword,
                          controller: passController,
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
                      submit_finish();
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

  void submit_finish(){
    String mail=mailregisterController.text;
    String pass=passController.text;
    String confirmpass=confirmpassController.text;
    String otp=otpController.text;

    if(mail.isEmpty || pass.isEmpty || confirmpass.isEmpty || otp.isEmpty){
      showSnackBar(context, "Enter all details", Colors.red);
    }
    else if(pass!=confirmpass) {
      showSnackBar(context, "Confirm Password does not match", Colors.red);
    }
    else{
      // perform logic for checking correct otp and change password
      showSnackBar(context, "Password change Succesfully", Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, '/LoginRoute', (_) => false);
    }
  }
}
