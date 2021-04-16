import 'dart:async';

import 'package:flutter/material.dart';
import 'package:public_app/Routes/Routes.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Center(
          // height: height / 10,
          child: Image.asset('assets/logo/Logo.png',
              fit: BoxFit.fitHeight, height: height / 10)),
    );
  }

  Future<void> timer() async {
    Timer(Duration(seconds: 2), () {
      //It will redirect  after 2 seconds
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.authValidation, (route) => false,
          arguments: null);
    });
  }
}
