import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:revmo/shared/colors.dart';

///
///Revmo Theme Class
///
///Class containing Text Styles used for Revmo
///

class RevmoTheme {
  static const double FORMS_MAX_WIDTH = 400;

  static const double _FONT_SIZE_1 = 14;
  static const double _FONT_SIZE_2 = 20;
  static const double _FONT_SIZE_3 = 24;
  static const double _FONT_SIZE_4 = 30;
  static const double _FONT_SIZE_5 = 40;
  static const double _FONT_SIZE_6 = 66;

  static const String FONT_EUROSTILE = "Eurostile";
  static const String FONT_GIBSON = "Gibson";
  static const String FONT_GIBSON_LIGHT = "Gibson_Light";
  static const String FONT_ROBOTO = "ROBOTO";

  static Text getbody1(String text,
      {bool isBold = false,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight weight = FontWeight.w700,
      Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: _FONT_SIZE_3,
          fontStyle: fontStyle,
          color: color,
          fontFamily: FONT_GIBSON,
          fontWeight: (isBold || weight != FontWeight.w700) ? weight : FontWeight.normal),
    );
  }

  static Text getCaption(String text,
      {bool isBold = false,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight weight = FontWeight.w300,
      Color color = Colors.white}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: _FONT_SIZE_1,
          fontStyle: fontStyle,
          fontFamily: FONT_GIBSON_LIGHT,
          color: color,
          fontWeight: (isBold || weight != FontWeight.w300) ? weight : FontWeight.w300),
    );
  }

  static Text getEuroStileTitle(String text) {
    return Text(text, style: TextStyle(fontFamily: FONT_EUROSTILE, fontSize: _FONT_SIZE_5, color: RevmoColors.originalBlue));
  }

  static Text getFormTitle(String text) {
    return Text(text,
        style: TextStyle(fontFamily: FONT_GIBSON, fontSize: _FONT_SIZE_2, color: Colors.white, fontWeight: FontWeight.w700));
  }

  static Text getTextFieldLabel(String text) {
    return Text(text, style: TextStyle(fontFamily: FONT_GIBSON, fontSize: _FONT_SIZE_1, color: Colors.white));
  }

  static Text getTextFieldText(String text) {
    return Text(text, style: TextStyle(fontFamily: FONT_GIBSON_LIGHT,  color: RevmoColors.darkBlue));
  }

  static Text getIconButtonText(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: FONT_ROBOTO, color: RevmoColors.cyan, fontSize: _FONT_SIZE_1),
    );
  }
}
