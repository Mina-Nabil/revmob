import 'package:flutter/material.dart';
import './revmo_button.dart';

class SecondaryButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;
  final Color textColor;
  const SecondaryButton({this.callBack, this.width=double.infinity, required this.text, this.textColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      callBack: callBack,
      color: Colors.transparent,
      textColor: textColor,
      width: width,
      text: text,
      addBorder: true,
    );
  }
}
