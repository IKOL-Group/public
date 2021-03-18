import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_app/api.dart';
import 'package:public_app/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() {
  runApp(MyApp());
}

// const double _kMinCircularProgressIndicatorSize = 36.0;

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
      resizeToAvoidBottomInset: false,
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
      body: ShareWidget(),
      floatingActionButton: ScaffoldFAB(),
    );
  }
}

class ScaffoldFAB extends StatelessWidget {
  const ScaffoldFAB({
    Key key,
  }) : super(key: key);

  void _openLocationInMaps(BuildContext context) async {
    /// Determine the current position of the device.
    ///
    /// When the location services are not enabled or permissions
    /// are denied the `Future` will return an error.
    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Please turn on location');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }

    try {
      var pos = await _determinePosition();
      MapsLauncher.launchCoordinates(pos.latitude, pos.longitude, "Location");
    } catch (e) {
      print(e.runtimeType);
      showSnackBar(context, "$e");
    }
  }

  void showSnackBar(BuildContext context, String value) {
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
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openLocationInMaps(context),
      backgroundColor: Colors.white,
      child: Transform.translate(
        offset: Offset(0, 4),
        child: SvgPicture.asset(
          "assets/gmaps.svg",
          semanticsLabel: 'Open in Maps',
        ),
      ),
    );
  }
}

class ShareWidget extends StatefulWidget {
  ShareWidget({Key key}) : super(key: key);

  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
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

  Future<void> asyncInitState() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final uinfo = await APIMethods.getUserInfo();
    // increase loading time
    // TODO do this only if request was very fast
    await Future.delayed(Duration(milliseconds: 300));
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
    // remove any previous error
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
          if (active) {
            // TODO
          }
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

    print(MediaQuery.of(context).padding.top);
    print(MediaQuery.of(context).size.height);
    print(kToolbarHeight);

    return RefreshIndicator(
      onRefresh: asyncInitState,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    // 32 pixels is hardcoded
                    MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        62.182,
              ),
              child: Stack(
                children: [
                  ListView(),
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
            ),
          ],
        ),
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
