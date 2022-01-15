import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import './revmo_button.dart';

class DangerButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;

  const DangerButton({this.callBack, this.width=double.infinity, required this.text});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      callBack: callBack,
      color: RevmoColors.darkRed,
      width: width,
      text: text,
    );
  }
}
