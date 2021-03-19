import 'package:flutter/material.dart';

class OTPPage extends StatefulWidget {
  OTPPage({Key key}) : super(key: key);

  static final route = "/otp";

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("OTP page")),
      ),
    );
  }
}
