import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:public_app/Routes/Routes.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/screens/profile/profile.dart';

import '../main.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  HomeScreen({Key key, this.token}) : super(key: key);

  // static final String route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Hey Lokendar!',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: kGreenColor,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/usericon.svg",
              semanticsLabel: 'User Page',
              color: Theme.of(context).appBarTheme.actionsIconTheme.color,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.profile);
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/help.svg",
              semanticsLabel: 'Help Page',
              color: Theme.of(context).appBarTheme.actionsIconTheme.color,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.help);
            },
          ),
        ],
      ),
      body: ShareWidget(),
      floatingActionButton: ScaffoldFAB(),
    );
  }
}