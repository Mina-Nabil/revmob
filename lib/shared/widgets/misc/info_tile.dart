import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class CarInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? iconData;
  final String? svgPath;
  const CarInfoTile({required this.title, required this.value, this.iconData, this.svgPath});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: 30,
          
          decoration: BoxDecoration(
            color: RevmoColors.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: (svgPath != null)
                    ? SvgPicture.asset(svgPath!, color: RevmoColors.originalBlue)
                    : (iconData != null)
                        ? Icon(
                            iconData,
                            color: RevmoColors.originalBlue,
                          )
                        : Container(),
                fit: FlexFit.tight,
              ),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: FittedBox(child: RevmoTheme.getBody(title, 1, color: RevmoColors.darkBlue)),
                  )),
              Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: FittedBox(child: RevmoTheme.getSemiBold(value, 2, color: RevmoColors.darkBlue)),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
