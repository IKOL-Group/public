import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:public_app/colors/colors.dart';

final TextStyle kPoppinsTextStyle = GoogleFonts.poppins(
  textStyle: TextStyle(color: Colors.black, fontSize: 20),
);

final TextStyle kPoppinsTextStyle2 = GoogleFonts.poppins(
  textStyle: TextStyle(color: Colors.grey, fontSize: 20),
);

final TextStyle kPoppinsTextStyle3 = GoogleFonts.poppins(
  textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
);

final TextStyle kPoppinsTextStyle4 = GoogleFonts.poppins(
  textStyle: TextStyle(color: kGreenColor, fontSize: 20),
);

TextStyle kPoppinsTextStyleSize({double fontSize = 20}) => GoogleFonts.poppins(
      textStyle: TextStyle(color: Colors.black, fontSize: fontSize),
    );

TextStyle kSubtitleTextStyleSize({double fontSize = 20, bool mono: false}) =>
    mono
        ? GoogleFonts.sourceCodePro(
            textStyle: TextStyle(color: Colors.black, fontSize: fontSize),
          )
        : GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black, fontSize: fontSize),
          );


const String kBaseUrl = 'http://139.59.45.103:3000';