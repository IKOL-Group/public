import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  static final route = "/help";

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Help?")),
      ),
    );
  }
}
