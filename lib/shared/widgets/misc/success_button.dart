import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import './revmo_button.dart';

class SuccessButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;

  const SuccessButton({this.callBack, this.width=double.infinity, required this.text});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      callBack: callBack,
      color: RevmoColors.darkGreen,
      width: width,
      text: text,
    );
  }
}
