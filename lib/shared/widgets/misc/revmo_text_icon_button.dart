import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoTextIconButton extends StatelessWidget {
  final double width;
  final Widget iconWidget;
  final Function()? callback;
  final String? text;
  final bool borderless;
  final Color? color;
  final double margin;

  const RevmoTextIconButton(
      {required this.width, required this.iconWidget, required this.callback, this.text, this.borderless = false, this.color, this.margin=15});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
            color: color ?? RevmoColors.darkBlue,
            border: (borderless) ? null : Border.all(color: RevmoColors.cyan, width: 1),
            borderRadius: (borderless) ? null : BorderRadius.all(Radius.circular(20))),
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
