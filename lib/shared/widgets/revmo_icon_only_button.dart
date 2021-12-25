import 'package:flutter/material.dart';

class RevmoIconButton extends StatelessWidget {
  final double _borderRadius = 5;

  final Color _color;
  final Function() _callback;
  final Widget _iconWidget;
  final double _width;
  final double _iconPadding;

  const RevmoIconButton({required Color color, required Function() callback, required Widget iconWidget, required double width, required double iconPadding})
      : _color = color,
        _callback = callback,
        _width = width,
        _iconWidget = iconWidget,
        _iconPadding = iconPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _callback,
      child: Container(
        width: _width,
        padding: EdgeInsets.all(_iconPadding),
        height: _width,
        decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.all(Radius.circular(_borderRadius))),
        child: _iconWidget,
      ),
    );
  }
}
