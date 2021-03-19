import 'package:flutter/material.dart';

class EmailVerifyPage extends StatefulWidget {
  EmailVerifyPage({Key key}) : super(key: key);

  static final route = "/addEmail";

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("EmailVerify page")),
      ),
    );
  }
}
