import 'dart:io';

import 'package:flutter/material.dart';
import 'package:public_app/Routes/Routes.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';

class ChooseLogInType extends StatefulWidget {
  @override
  _ChooseLogInTypeState createState() => _ChooseLogInTypeState();
}

class _ChooseLogInTypeState extends State<ChooseLogInType> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kGreenColor,
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 100.0,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.login);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: kGreenColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Text('Log In', style: kPoppinsTextStyle4),
                ),
              ),
            ),
            SizedBox(
              width: 10.0
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.register);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: kGreenColor,
                    border: Border.all(color: kGreenColor, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Text('Register', style: kPoppinsTextStyle3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}