import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class RevmoCheckbox extends StatelessWidget {
  final double _diameter = 30;
  final bool isSelected;
  final Function() onTap;
  const RevmoCheckbox({required bool initialValue, required Function() onTap})
      : isSelected = initialValue,
        onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: RevmoColors.originalBlue),
            color: (isSelected) ? RevmoColors.originalBlue : Colors.white),
        width: _diameter,
        alignment: Alignment.center,
        padding: EdgeInsets.all(2),
        child: FittedBox(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
