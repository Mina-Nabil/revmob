import 'package:flutter/material.dart';

import '../../colors.dart';

class DetailText extends StatelessWidget {
  const DetailText({Key? key, required this.title, required this.info, this.fontSize = 14, this.icon, this.topPadding = 10})
      : super(key: key);
  final String title;
  final String info;
  final double? fontSize;
  final double? topPadding ;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: RevmoColors.darkBlue,
              fontSize: fontSize
            ),
          ),
          SizedBox(
            height: 2,
          ),
          icon != null ?
          Row(
            children: [
              icon!,
SizedBox(width: 5,),
              Text(
                info,
                style: TextStyle(
                  color: RevmoColors.darkBlue,
                  fontSize: fontSize
                ),
              ),
            ],
          ) :
          Text(
            info,
            style: TextStyle(
                color: RevmoColors.darkBlue,
                fontSize: fontSize
            ),
          ),
        ],
      ),
    );
  }
}
