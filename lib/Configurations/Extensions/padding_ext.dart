import 'package:flutter/widgets.dart';

extension PaddingtoWidget on Widget {
  Widget setPageHorizontalPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.0565,
      ),
      child: this,
    );
  }

  Widget setOnlyPadding(
      BuildContext context, {
        double top = 0,
        double bottom = 0,
        double left = 0,
        double right = 0,
        bool enableMediaQuery = true,
      }) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: enableMediaQuery ? mediaQuery.size.height * top : top,
        bottom: enableMediaQuery ? mediaQuery.size.height * bottom : bottom,
        left: enableMediaQuery ? mediaQuery.size.width * left : left,
        right: enableMediaQuery ? mediaQuery.size.width * right : right,
      ),
      child: this,
    );
  }
}