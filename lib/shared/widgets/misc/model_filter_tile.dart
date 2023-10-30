import 'package:flutter/material.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';

class CarModelFilterTile extends StatelessWidget {
  final Function() onTap;
  final CarModel model;
  final bool isSelected;
  const CarModelFilterTile({required this.model, required this.onTap, required this.isSelected});

  final double _width = 70;
  final double _height = 25;
  final double _padding = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (isSelected) ? RevmoColors.grey.withAlpha(50) : Colors.white,
            border: (isSelected) ? null : Border.all(color: RevmoColors.grey, width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
          flex: 2,
          // fit: FlexFit.tight,
              child: Center(
                child: Image.network(
                  model.brand.logoURL,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (_, __, ___) => RevmoImagePlaceholder(
                    height: _height,
                    width: _width,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2,),

            // Expanded(
            //     flex: 2,
            //     child: FittedBox(child: RevmoTheme.getBody(model.name, 1, color: RevmoColors.darkBlue))),

            Expanded(
              child: Text(
                model.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10 , color: RevmoColors.darkBlue, fontStyle:  FontStyle.normal, fontWeight: FontWeight.w700, ),
              ),
            ),
         SizedBox(width: 3,),
          ],
        ),
      ),
    );
  }
}
