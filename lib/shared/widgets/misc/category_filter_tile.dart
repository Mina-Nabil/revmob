import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';

class CategoryFilterTile extends StatelessWidget {
  final Function() onTap;
  final bool isSelected;
  final Car car;

  const CategoryFilterTile({required this.car, required this.onTap, required this.isSelected});

  final double _width = 70;
  final double _height = 25;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (isSelected) ? RevmoColors.grey.withAlpha(50) : Colors.white,
            border: (isSelected) ? null : Border.all(color: RevmoColors.grey, width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Image.network(
                car.model.brand.logoURL,
                errorBuilder: (_, __, ___) => RevmoImagePlaceholder(
                  height: _height,
                  width: _width,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            Flexible(child: FittedBox(child: RevmoTheme.getBody(car.catgName, 1, color: RevmoColors.darkBlue)))
          ],
        ),
      ),
    );
  }
}
