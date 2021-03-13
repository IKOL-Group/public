import 'package:flutter/material.dart';
import 'package:public_app/api.dart';
import 'package:public_app/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IKOLE',
      theme: ThemeData(
        accentColor: kAccentColor,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: MyHomePage(title: 'IKOL?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _started = false;

  Future<void> toggleActive() async {
    await APIMethods.toggleActive(!_started);
    setState(() {
      _started = !_started;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Color.fromARGB(255, 91, 175, 110),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hey Lokendar!',
          style: GoogleFonts.poppins(textStyle: textStyle),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/usericon.svg",
              semanticsLabel: 'User Page',
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/help.svg",
              semanticsLabel: 'Help Page',
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: _started
                    ? Color.fromARGB(255, 244, 47, 35)
                    : Color.fromARGB(255, 82, 167, 81),
                child: InkWell(
                  onTap: () {
                    toggleActive();
                  },
                  splashColor: _started
                      ? Color.fromARGB(255, 136, 48, 42)
                      : kAccentColor,
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Center(
                      child: Text(
                        _started ? "STOP SHARING" : "SHARE LOCATION",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        tooltip: "Add",
      ),
    );
  }
}
