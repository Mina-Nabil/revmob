import 'package:flutter/material.dart';

Widget smallCustomIndicator(BuildContext context, {
  Color? color,
  double? height,
  double? width,

}) {

  return SizedBox(
      height: height ?? 16,
      width: width ?? 16,
      child: CircularProgressIndicator(
        color: color ?? Colors.white,
        strokeWidth: 1,
      ));
}
