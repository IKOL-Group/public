import 'package:flutter/material.dart';

class IdentityVerifyPage extends StatefulWidget {
  IdentityVerifyPage({Key key}) : super(key: key);

  static final route = "/id_aadhar";

  @override
  _IdentityVerifyPageState createState() => _IdentityVerifyPageState();
}

class _IdentityVerifyPageState extends State<IdentityVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("IdentityVerify page")),
      ),
    );
  }
}
