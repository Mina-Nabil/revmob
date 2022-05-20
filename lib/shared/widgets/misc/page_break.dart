import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class PageBreak extends StatelessWidget {
  const PageBreak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      constraints: BoxConstraints(maxWidth: double.infinity),
      height: .25,
      color: RevmoColors.grey,
    );
  }
}
