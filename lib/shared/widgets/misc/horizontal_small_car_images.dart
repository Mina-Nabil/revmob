import 'package:flutter/material.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';

class HorizontalSmallCarImagesList extends StatelessWidget {
  final Car car;
  final double _imagesHeight = 50;
  final double _imagesWidth = 65;
  const HorizontalSmallCarImagesList(this.car);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _imagesHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: car.carImages.length,
          itemBuilder: (cnxt, index) => Padding(
              padding: EdgeInsets.only(right: 2),
              child: RevmoCarImageWidget(
                revmoImage: car.carImages[index],
                imageHeight: _imagesHeight,
                imageWidth: _imagesWidth,
              ))),
    );
  }
}
