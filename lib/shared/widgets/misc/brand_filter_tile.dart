import 'package:flutter/material.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';

class BrandFilterTile extends StatelessWidget {
  final Function() onTap;
  final Brand brand;
  final bool isSelected;

  const BrandFilterTile({required this.brand, required this.onTap, required this.isSelected});

  final double _width = 70;
  final double _height = 25;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (isSelected) ? RevmoColors.grey.withAlpha(50) : Colors.white,
            border: (isSelected) ? null : Border.all(color: RevmoColors.grey, width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Center(
                child: Image.network(
                  brand.logoURL,
                  errorBuilder: (_, __, ___) => RevmoImagePlaceholder(
                    height: _height,
                    width: _width,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Flexible(
              
              child: FittedBox(child: RevmoTheme.getBody(brand.name, 1, color: RevmoColors.darkBlue)))
          ],
        ),
      ),
    );
  }
}
