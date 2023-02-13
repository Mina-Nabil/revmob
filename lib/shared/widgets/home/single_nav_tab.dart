import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/shared/colors.dart';

class SingleNavigationTabContainer extends StatelessWidget {
  final String iconPath;
  final String tabText;
  final bool isSelected;

  const SingleNavigationTabContainer(
      this.iconPath, this.tabText, this.isSelected);

  final double navBarIconHeight = 22;
  final double navBarTopMargin = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          isSelected
              ? FadeIn(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: 3,
                    color: RevmoColors.navbarColorSelectedIcon),
              )
              : SizedBox(
                  width: 50,
                  height: 3,
                ),
          SizedBox(
            height: 5,
          ),
          isSelected
              ? ElasticIn(
                  child: Container(
                      margin: EdgeInsets.only(top: navBarTopMargin),
                      child: SizedBox(
                        height: navBarIconHeight,
                        child: SvgPicture.asset(iconPath,
                            color: RevmoColors.navbarColorSelectedIcon),
                      )),
                )
              : Container(
                  margin: EdgeInsets.only(top: navBarTopMargin),
                  child: SizedBox(
                    height: navBarIconHeight,
                    child: SvgPicture.asset(
                      iconPath,
                      color: RevmoColors.unSelectedTab,
                    ),
                  )),
          SizedBox(
            height: 10,
          ),
          isSelected ?
          ElasticIn(
            child: Container(
              child: FittedBox(
                child: Text(
                  tabText,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? RevmoColors.navbarColorSelectedIcon
                        : RevmoColors.unSelectedTab,
                  ),
                ),
              ),
            ),
          ) :  Container(
            child: FittedBox(
              child: Text(
                tabText,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? RevmoColors.navbarColorSelectedIcon
                      : RevmoColors.unSelectedTab,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
