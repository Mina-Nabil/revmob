import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class DateRow extends StatelessWidget {
  final DateTime date;

  const DateRow(this.date);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Paths.calendarSVG,
          color: RevmoColors.darkBlue,
          height: 10,
        ),
        SizedBox(
          width: 3,
        ),
        RevmoTheme.getCaption(date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString(), 1,
            color: RevmoColors.lightPetrol)
      ],
    );
  }
}
