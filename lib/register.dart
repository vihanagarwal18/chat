import 'package:chat/components/components.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController mailregisterController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                TextField(
                  maxLength: 20,
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  maxLength: 20,
                  controller: confirmpassController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
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
    );
  }

  void submit_register(){
    String mail=mailregisterController.text;
    String pass=passController.text;
    String confirmpass=confirmpassController.text;

    if(mail.isEmpty || pass.isEmpty || confirmpass.isEmpty){
      showSnackBar(context, "Enter all details", Colors.red);
    }
    else if(pass==confirmpass) {
      // perform logic for registering user
      showSnackBar(context, "Registered Succesfully", Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, '/HomeRoute', (_) => false);
    }
    else{
      showSnackBar(context, "Confirm Password does not match", Colors.red);
    }
  }
}
