import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../theme.dart';
class RevmoInitialNameWidget extends StatelessWidget {
  final String initial;

  const RevmoInitialNameWidget({
    Key? key,
    required this.initial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
      child: Container(
        height: 30,
        width: 30,
        decoration:
        BoxDecoration(shape: BoxShape.circle, color: RevmoColors.lightBlue),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          child: FittedBox(
            child:
            RevmoTheme.getBody(initial, 2, color: RevmoColors.originalBlue),
          ),
        ),
      ),
    );
  }
}
