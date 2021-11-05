import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class SingleNavigationTabContainer extends StatelessWidget {
  final String iconPath;
  final String tabText;
  final bool isSelected;

  const SingleNavigationTabContainer(this.iconPath, this.tabText, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Container(
        //     margin: EdgeInsets.only(top: navBarTopMargin),
        //     child: SvgPicture.asset(
        //       Paths.notificationPageNavBarIcon,
        //       color: _selectedIndex == 1 ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
        //       width: navBarIconSize,
        //     )),
        Container(
          child: Text(
            tabText,
            style: TextStyle(
              color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
            ),
          ),
        )
      ],
    ));
  }
}
