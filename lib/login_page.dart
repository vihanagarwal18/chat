import 'package:flutter/material.dart';

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
      body: Container(
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
    );
  }

  bool validateMobileNumber() {
    String mobileNumber = mobileController.text.trim();
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid mobile number. Please enter a 10-digit number.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void sendOTP() {
    // Replace this with your actual OTP sending logic
    setState(() {
      otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void verifyOTP() {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the OTP'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Add logic for successful OTP verification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP verified successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}