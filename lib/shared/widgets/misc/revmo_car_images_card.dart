import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/images_carousel.dart';

class RevmoCarImagesCard extends StatelessWidget {
  final Car car;
  final double height;
  final double imagesWidth;
  final double imagesHeight;

  const RevmoCarImagesCard(this.car, {this.height = 350, this.imagesHeight=260, this.imagesWidth = 320});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //carousel
            Container(margin: EdgeInsets.only(top: 10), child: RevmoImagesCarousel(car: car, height: imagesHeight, width: imagesWidth)),
            //car info
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: FittedBox(child: RevmoTheme.getSemiBold(car.desc1, 1, weight: FontWeight.w700, color: RevmoColors.darkBlue)),
            ),
            FittedBox(child: RevmoTheme.getSemiBold(car.desc2, 1, color: RevmoColors.darkBlue))
          ],
        ));
  }
}
