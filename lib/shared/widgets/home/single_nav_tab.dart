import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/shared/colors.dart';

class SingleNavigationTabContainer extends StatelessWidget {
  final String iconPath;
  final String tabText;
  final bool isSelected;

  const SingleNavigationTabContainer(this.iconPath, this.tabText, this.isSelected);

  final double navBarIconHeight = 20;
  final double navBarTopMargin = 5;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            margin: EdgeInsets.only(top: navBarTopMargin),
            child: SizedBox(
              height: navBarIconHeight,
              child: SvgPicture.asset(
                iconPath,
                color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
              ),
            )),
        Container(
          child: FittedBox(
            child: Text(
              tabText,
              style: TextStyle(
                color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
