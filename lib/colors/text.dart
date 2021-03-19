import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle kPoppinsTextStyle = GoogleFonts.poppins(
  textStyle: TextStyle(color: Colors.black, fontSize: 20),
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
