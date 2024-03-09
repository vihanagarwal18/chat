import 'package:chat/components/components.dart';
import 'package:flutter/material.dart';
import 'package:chat/auth/auth_service.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController mailregisterController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController=TextEditingController();
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
              height: MediaQuery.of(context).size.height * .5,
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

  void submit_register() {
    String mail=mailregisterController.text;
    String pass=passController.text;
    String confirmpass=confirmpassController.text;

    if(mail.isEmpty || pass.isEmpty || confirmpass.isEmpty){
      showSnackBar(context, "Enter all details", Colors.red);
    }
    else if(pass!=confirmpass) {
      showSnackBar(context, "Confirm Password does not match", Colors.red);
    }
    else{
      // perform logic for registering user
      try{
        final _auth=AuthService();
        _auth.signUpWithEmailPassword(mail, pass);
        showSnackBar(context, "Registered Succesfully", Colors.green);
        //_auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/AuthGate', (_) => false);
      }
      catch (e){
        throw Exception(e);
      }

      //_auth.signOut();
      //Navigator.pushNamedAndRemoveUntil(context, '/HomeRoute', (_) => false);
    }
  }
}
