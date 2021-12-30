import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import './revmo_button.dart';

class MainButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;

  const MainButton({this.callBack, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      callBack: callBack,
      color: RevmoColors.originalBlue,
      width: width,
      text: text,
    );
  }
}
