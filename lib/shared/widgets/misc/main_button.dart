import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import './revmo_button.dart';

class MainButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;
  final Color? color;
  final Color? textColor;

  const MainButton({this.callBack, this.width = double.infinity, required this.text, this.color = RevmoColors.originalBlue, this.textColor = Colors.white,});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      textColor:textColor! ,
      callBack: callBack,
      color: color!,
      width: width,
      text: text,
    );
  }
}
