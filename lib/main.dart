import 'dart:async';

import 'package:flutter/material.dart';
import 'package:public_app/api.dart';
import 'package:public_app/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() {
  runApp(MyApp());
}

const double _kMinCircularProgressIndicatorSize = 36.0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IKOLE',
      theme: ThemeData(
        accentColor: kAccentColor,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: MyHomePage(title: 'IKOL'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      // fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 91, 175, 110),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hey Lokendar!',
          style: GoogleFonts.poppins(
            textStyle: textStyle,
            fontWeight: FontWeight.bold,
          ),
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
      body: HomeWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
        },
        backgroundColor: Colors.white,
        child: Transform.translate(
          offset: Offset(0, 4),
          child: SvgPicture.asset(
            "assets/gmaps.svg",
            semanticsLabel: 'Open in Maps',
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _active;
  String _error;
  var _loading = false;

  // TODO ui click threshold
  Timer _debounce;

  void showSnackBar(String value) {
    // https://stackoverflow.com/a/49932085/8608146
    Scaffold.of(context)
        // ignore: deprecated_member_use
        .showSnackBar(
      SnackBar(
        content: Text(value),
        action: SnackBarAction(
          label: "DISMISS",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void initState() {
    asyncInitState();
    super.initState();
  }

  void asyncInitState() async {
    setState(() {
      _loading = true;
    });
    final uinfo = await APIMethods.getUserInfo();
    var success = uinfo[0];
    var error = uinfo[1];
    setState(() {
      if (success) {
        var active = uinfo[2];
        _active = active;
      } else {
        _error = error;
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void toggleActive() {
    _error = null;
    if (_loading || _active == null) return;
    // https://stackoverflow.com/a/52930197/8608146
    if (_debounce?.isActive ?? false) _debounce.cancel();

    // if loading we anyway return
    // so this will only trigger build when needed
    setState(() {
      _loading = true;
    });
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      var _x = await APIMethods.toggleActive(!_active);
      final bool success = _x[0];
      final String error = _x[1];
      setState(() {
        if (success) {
          final bool active = _x[2];
          _active = active;
          // remove any previous error
        } else {
          _error = error;
        }
        // we're not loading anymore
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // show snackbar
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showSnackBar(_error);
      });
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              Center(
                child: SizedBox(
                  child: _loading
                      ? CircularProgressIndicator(
                          strokeWidth: 10,
                          semanticsLabel: _active == null
                              ? "Checking share location state"
                              : "Turning ${_active ? "off" : "on"} location sharing",
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _active == null
                                ? Color.fromARGB(155, 123, 123, 123)
                                : _active
                                    ? Color.fromARGB(155, 244, 47, 35)
                                    : Color.fromARGB(155, 82, 167, 81),
                          ),
                        )
                      : null,
                  height: 220.0,
                  width: 220.0,
                ),
              ),
              Center(
                child: buildShareOption(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ClipOval buildShareOption() {
    return ClipOval(
      child: Material(
        color: _active == null
            ? Color.fromARGB(255, 123, 123, 123)
            : _active
                ? Color.fromARGB(255, 244, 47, 35)
                : Color.fromARGB(255, 82, 167, 81),
        child: InkWell(
          onTap: () {
            toggleActive();
          },
          splashColor: _active == null
              ? Color.fromARGB(255, 123, 123, 123)
              : _active
                  ? Color.fromARGB(255, 136, 48, 42)
                  : kAccentColor,
          child: SizedBox(
            width: 220,
            height: 220,
            child: Center(
              child: Text(
                _active == null
                    ? "SHARE LOCATION"
                    : _active
                        ? "STOP SHARING"
                        : "SHARE LOCATION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
