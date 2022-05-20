import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:revmo/shared/colors.dart';

///
///Revmo Theme Class
///
///Class containing Text Styles used for Revmo
///

class RevmoTheme {
  static const double FORMS_MAX_WIDTH = 400;
  static const double DETAILS_BOXES_MIN = 40;
  static const double DEFAULT_HEADERS_HEIGHT = 64;
  static const double SEARCH_BAR_HEIGHT = 40;
  static const double FIELDS_VER_MARGIN = 10;

  static const double _FONT_SIZE_0 = 10;
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

  static const double DIMMING_RATIO = 0.63;

  static const int _INDICATOR_TYPE = 1;
  static List<Color> _indicatorColors = [
    RevmoColors.white,
    RevmoColors.originalBlue,
    RevmoColors.darkBlue,
  ];

//animtaions consts
  static const Curve BOXES_CURVE = Curves.fastLinearToSlowEaseIn;
  static const Curve PAGES_CURVE = Curves.easeInOut;
  static const Duration PAGES_DURATION = const Duration(milliseconds: 300);

  static double getFontSize(int size) {
    switch (size) {
      case 0:
        return _FONT_SIZE_0;
      case 1:
        return _FONT_SIZE_1;
      case 2:
        return _FONT_SIZE_2;
      case 3:
        return _FONT_SIZE_3;
      case 4:
        return _FONT_SIZE_4;
      case 5:
        return _FONT_SIZE_5;
      case 6:
      default:
        return _FONT_SIZE_6;
    }
  }

  static getBodyStyle(int size,
          {bool isBold = false,
          FontStyle fontStyle = FontStyle.normal,
          FontWeight weight = FontWeight.w700,
          Color color = Colors.white}) =>
      TextStyle(
          fontSize: getFontSize(size),
          fontStyle: fontStyle,
          color: color,
          fontFamily: FONT_GIBSON,
          fontWeight: (isBold || weight != FontWeight.w700) ? weight : FontWeight.normal);

  static Text getBody(String text, int size,
          {bool isBold = false,
          FontStyle fontStyle = FontStyle.normal,
          FontWeight weight = FontWeight.w700,
          TextOverflow? overflow,
          Color color = Colors.white}) =>
      Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: getBodyStyle(size, color: color, fontStyle: fontStyle, weight: weight, isBold: isBold),
      );

  static getTitleStyle({Color color = Colors.white}) => TextStyle(
      fontSize: getFontSize(2),
      fontStyle: FontStyle.normal,
      color: color,
      fontFamily: FONT_GIBSON,
      fontWeight: FontWeight.w600);

  static Text getTitle(String text, {Color color = Colors.white, TextOverflow overflow = TextOverflow.ellipsis}) => Text(
        text,
        overflow: overflow,
        style: getTitleStyle(color: color),
      );

  static getSemiBoldStyle(int size,
          {FontStyle fontStyle = FontStyle.normal, FontWeight weight = FontWeight.w600, Color color = Colors.white}) =>
      TextStyle(fontSize: getFontSize(size), fontStyle: fontStyle, color: color, fontFamily: FONT_GIBSON, fontWeight: weight);

  static Text getSemiBold(String text, int size,
          {FontStyle fontStyle = FontStyle.normal,
          FontWeight weight = FontWeight.w600,
          Color color = Colors.white,
          TextOverflow overflow = TextOverflow.ellipsis}) =>
      Text(
        text,
        overflow: overflow,
        style: getSemiBoldStyle(size, color: color, fontStyle: fontStyle, weight: weight),
      );

  static TextStyle getCaptionStyle(int size,
          {bool isBold = false,
          FontStyle fontStyle = FontStyle.normal,
          FontWeight weight = FontWeight.w500,
          Color color = Colors.white}) =>
      TextStyle(
          fontSize: getFontSize(size),
          fontStyle: fontStyle,
          fontFamily: FONT_GIBSON_LIGHT,
          color: color,
          fontWeight: (isBold || weight != FontWeight.w500) ? weight : FontWeight.w500);

  static Text getCaption(String text, int size,
          {bool isBold = false,
          FontStyle fontStyle = FontStyle.normal,
          FontWeight weight = FontWeight.w300,
          TextOverflow? overflow,
          Color color = Colors.white}) =>
      Text(text,
          overflow: overflow,
          textAlign: TextAlign.center,
          style: getCaptionStyle(size, isBold: isBold, fontStyle: fontStyle, weight: weight, color: color));

  static Text getEuroStileTitle(String text) {
    return Text(text, style: TextStyle(fontFamily: FONT_EUROSTILE, fontSize: getFontSize(5), color: RevmoColors.originalBlue));
  }

  static Text getFormTitle(String text) {
    return Text(text,
        style: TextStyle(fontFamily: FONT_GIBSON, fontSize: getFontSize(2), color: Colors.white, fontWeight: FontWeight.w500));
  }

  static Text getTextFieldLabel(String text, {Color color=Colors.white}) {
    return Text(text, style: TextStyle(fontFamily: FONT_GIBSON, fontSize: getFontSize(1), color: color));
  }

  static TextStyle getTextFieldStyle() {
    return TextStyle(fontFamily: FONT_GIBSON_LIGHT, color: RevmoColors.white);
  }

  static TextStyle getCarTileTitleStyle() {
    return TextStyle(fontFamily: FONT_GIBSON, fontWeight: FontWeight.w700, color: RevmoColors.darkBlue);
  }

  static Text getCarTileTitle(String text) {
    return Text(text, style: getCarTileTitleStyle());
  }

  static Text getTextFieldText(String text) {
    return Text(text, style: getTextFieldStyle());
  }

  static Text getIconButtonText(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: FONT_ROBOTO, color: RevmoColors.cyan, fontSize: getFontSize(1)),
    );
  }

  static LoadingIndicator getLoadingIndicator() {
    return LoadingIndicator(indicatorType: Indicator.values[_INDICATOR_TYPE], colors: _indicatorColors, strokeWidth: 4.0);
  }

  static Widget getLoadingContainer(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      context: context,
      child: Container(
        height: 65,
        width: 65,
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(color: RevmoColors.backgroundDim, borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.topCenter,
        child: SizedBox(
            child:
                LoadingIndicator(indicatorType: Indicator.values[_INDICATOR_TYPE], colors: _indicatorColors, strokeWidth: 4.0)),
      ),
    );
  }

  static showRevmoSnackbar(BuildContext context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(msg, style: getBodyStyle(1, color: RevmoColors.darkBlue),)));
  }
}
