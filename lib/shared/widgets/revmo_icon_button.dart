import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoIconButton extends StatelessWidget {
  final double width;
  final Widget iconWidget;
  final Function()? callback;
  final String? text;

  const RevmoIconButton({required this.width, required this.iconWidget, required this.callback, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: RevmoColors.darkBlue,
            border: Border.all(color: RevmoColors.cyan, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 20, child: iconWidget),
            if (text != null)
              SizedBox(
                width: 12,
              ),
            (text != null) ? RevmoTheme.getIconButtonText(text!) : Text(""),
          ],
        ),
      ),
    );
  }
}
