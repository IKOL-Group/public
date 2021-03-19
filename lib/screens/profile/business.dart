import 'package:flutter/material.dart';

class BusinessDetailsPage extends StatefulWidget {
  BusinessDetailsPage({Key key}) : super(key: key);

  static final route = "/business";

  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("BusinessDetails page")),
      ),
    );
  }
}
