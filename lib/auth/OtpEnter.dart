import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenchargehub/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {
  final String verificationId;

  const Otp(this.verificationId, {Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otp = TextEditingController();
  bool isLoading = false; // Added isLoading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://www.cellcom.eu/phpthumb/cache/uploads/sms_toepassingen/Wachtwoord-via-sms-1/w400h2400zc0q100/Wachtwoord-via-sms-1.png',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: otp,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 6, // Assuming OTP length is 6 digits
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? emailid = prefs.getString('user_email');
                          String? username = prefs.getString('user_name');
                          String? photo = prefs.getString('user_photo_url');
                          String? phone = prefs.getString('user_number');

                          prefs.setBool('islogged',true );
                          setState(() {
                            isLoading = true; // Set isLoading to true when button is pressed
                          });
                          FirebaseAuth auth = FirebaseAuth.instance;
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otp.text);
                          await auth.signInWithCredential(credential);
                          await sendUserData(emailid!, phone!, username!);
                          setState(() {
                            isLoading = false; // Set isLoading back to false after verification
                          });
                          Get.to(()=>const HomePage());
                        },
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: isLoading
                              ? const CircularProgressIndicator() // Show CircularProgressIndicator when isLoading is true
                              : const Text(
                            'Verify',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> sendUserData(String email, String number, String name) async {
  var url = Uri.parse('http://16.171.199.244:5001/createuser/user'); // Replace with your API URL

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'number': number,
      'name': name,
    }),
  );

  if (response.statusCode == 201) {
    print('User data sent successfully');
  } else {
    print('Failed to send user data');
  }
}