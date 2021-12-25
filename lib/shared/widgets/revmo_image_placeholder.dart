import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class RevmoImagePlaceholder extends StatelessWidget {
  const RevmoImagePlaceholder({
    required double height,
    required double width,
  })  : _height = height,
        _width = width;

  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        width: _width,
        margin: EdgeInsets.all(2.0),
        color: RevmoColors.originalBlue.withAlpha((255 * .3).toInt()),
        child: Center(
            child: Icon(
          Icons.car_repair,
          color: Colors.white,
        )));
  }
}
