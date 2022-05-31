import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:revmo/shared/colors.dart';


void configLoading(){
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskType = EasyLoadingMaskType.black
    ..backgroundColor = RevmoColors.darkBlue
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..userInteractions = false
    // ..customAnimation = CustomAnimation()
    ..dismissOnTap = false;
}


class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();
  static const int _INDICATOR_TYPE = 1;
  static List<Color> _indicatorColors = [
    RevmoColors.white,
    RevmoColors.originalBlue,
    RevmoColors.darkBlue,
  ];
  @override
  Widget buildWidget(
      Widget child,
      AnimationController controller,
      AlignmentGeometry alignment,
      ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child:  LoadingIndicator(indicatorType: Indicator.values[_INDICATOR_TYPE], colors: _indicatorColors, strokeWidth: 4.0),
      ),
    );
  }
}