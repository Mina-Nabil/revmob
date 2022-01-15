import 'package:flutter/material.dart';
import 'package:revmo/models/model_color.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class ColorFilterTile extends StatelessWidget {
  final Function() onTap;
  final bool isSelected;
  final ModelColor color;

  const ColorFilterTile({required this.color, required this.isSelected, required this.onTap});

  final double _width = 70;
  final double _height = 25;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        width: _width,
  
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: (isSelected) ? Border.all(
                    color: RevmoColors.darkBlue,
                  ) : null
                ),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color.color),
                ),
              ),
            ),
            Flexible(child: FittedBox(child: RevmoTheme.getBody(color.name, 1, color: RevmoColors.darkBlue, isBold: isSelected)))
          ],
        ),
      ),
    );
  }
}
