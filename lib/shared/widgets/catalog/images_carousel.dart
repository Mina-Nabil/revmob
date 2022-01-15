import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';

class RevmoImagesCarousel extends StatefulWidget {
  final Car car;
  final double height;
  final double width;
  const RevmoImagesCarousel({required this.car, required this.height, required this.width});

  @override
  _RevmoImagesCarouselState createState() => _RevmoImagesCarouselState();
}

class _RevmoImagesCarouselState extends State<RevmoImagesCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final double _indicatorsDiameter = 8.0;
  final double _indicatorsContainerHeight=20;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(children: [
        Expanded(
          child: widget.car.carImages.length > 0 ? CarouselSlider.builder(
            carouselController: _controller,
            options: CarouselOptions(
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            itemCount: widget.car.carImages.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
              child: RevmoCarImageWidget(
                  revmoImage: widget.car.carImages[itemIndex], imageHeight: widget.height - _indicatorsContainerHeight, imageWidth: widget.width),
            ),
          ) : RevmoImagePlaceholder(width: widget.width, height: widget.height,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.car.carImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _indicatorsDiameter,
                height: _indicatorsDiameter,
                margin: EdgeInsets.only(top: 8.0, left: 1.5, right: 1.5, bottom: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: RevmoColors.darkBlue),
                    shape: BoxShape.circle, color: (!(_current == entry.key)) ? RevmoColors.darkBlue : Colors.transparent),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
