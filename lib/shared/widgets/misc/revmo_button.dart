import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoButton extends StatelessWidget {
  final double _borderRadius = 5.0;
  final double _borderWidth = 1.5;
  final double _fontSize = 15.0;

  final double width;
  final Function()? callBack;
  final Color color;
  final Color textColor;
  final String text;
  final bool addBorder;
  const RevmoButton({this.callBack, required this.width, required this.color, required this.text, this.addBorder=false, this.textColor= Colors.white});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callBack, 
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: _fontSize)),
          backgroundColor: MaterialStateProperty.all(callBack!=null ? color : color.withOpacity(0.6)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            
            side: (addBorder) ? BorderSide(width: _borderWidth, color: RevmoColors.originalBlue) : BorderSide.none
          ))),
      child: Container(
        width: width,
        alignment: Alignment.center,
        child: FittedBox(child: Text(text.toUpperCase(), style: RevmoTheme.getCaptionStyle(1, color: textColor),)),
      ),
    );
  }
}
