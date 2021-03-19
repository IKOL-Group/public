import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kAccentColor = Color.fromARGB(255, 87, 185, 86);
const Color kGreyIconColor = Color.fromARGB(255, 123, 123, 123);

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
