import 'package:flutter/material.dart';
import './revmo_button.dart';

class SecondaryButton extends StatelessWidget {
  final double width;
  final Function()? callBack;
  final String text;

  const SecondaryButton({this.callBack, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return RevmoButton(
      callBack: callBack,
      color: Colors.transparent,
      width: width,
      text: text,
      addBorder: true,
    );
  }
}
