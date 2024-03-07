import 'package:chat/components/components.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .667,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mobile Number Input
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Enter Mobile Number',
                  ),
                ),
                SizedBox(height: 20.0),

                // Send OTP Button
                ElevatedButton(
                  onPressed: () {
                    if (validateMobileNumber()) {
                      sendOTP();
                    }
                  },
                  child: Text('Send OTP'),
                ),
                SizedBox(height: 20.0),

                // OTP Input
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                  ),
                ),
                SizedBox(height: 20.0),

                // Verify OTP Button
                ElevatedButton(
                  onPressed: () {
                    verifyOTP();
                  },
                  child: Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateMobileNumber() {
    String mobileNumber = mobileController.text.trim();
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      showSnackBar(context,
          "Invalid mobile number. Please enter a 10-digit number.", Colors.red);
      return false;
    }
    return true;
  }

  void sendOTP() {
    setState(() {
      otpSent = true;
    });
    showSnackBar(context, "OTP sent successfully", Colors.green);
  }

  void verifyOTP() {
    if (otpController.text.isEmpty) {
      showSnackBar(context, 'Please enter the OTP', Colors.red);
    }
    // else if(otpController.text!=generatedOtp){
    //   showsnackBar(context,'Invalid OTP',Colors.red);
    // }
    else {
      showSnackBar(context, 'OTP verified successfully', Colors.green);
      //Navigator.of(context).pop();
      // Navigator.pushNamedAndRemoveUntil(context,'HomeRoute',
      //       (_) => false,
      //       // ModalRoute.withName('/')
      // );
      Navigator.pushNamed(context, '/HomeRoute');
    }
  }
}
