import 'package:flutter/material.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/screens/home/brand_models_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/cars_carousel.dart';
import 'package:revmo/shared/widgets/revmo_checkbox.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatefulWidget {
  final Car? c;
  final bool isLoading;
  bool get canAccessCar => !isLoading && c != null;
  const CategoryCard(this.c) : this.isLoading = false;
  const CategoryCard.placeholder()
      : c = null,
        isLoading = true;
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final double _cardHeight = 340;
  final double _imageHeight = 200;
  final double _imageWidth = 320;
  final double _horizontalPadding = 20;
  final double _checkboxHeight = 60;
  final double _checkboxWidth = 35;

  bool isSelected = false;

  @override
  void didChangeDependencies() {
    if (widget.canAccessCar) isSelected = CarsSelectionWidget.of(context).hasCar(widget.c!);
    super.didChangeDependencies();
  }

  void toggleCar() {
    if (widget.canAccessCar) {
      CarsSelectionWidget.of(context).toggleCar(widget.c!);
      setState(() {
        isSelected = CarsSelectionWidget.of(context).hasCar(widget.c!);
      });
      print( CarsSelectionWidget.of(context).selectedCars.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _cardWidth = MediaQuery.of(context).size.width - _horizontalPadding * 2;

    return Container(
      //height is set on parent widget -- Horizontal List
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //card title
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: (widget.canAccessCar)
                  ? FittedBox(
                      child: RevmoTheme.getSemiBold(widget.c!.carName, 2, color: RevmoColors.white),
                    )
                  : Shimmer.fromColors(
                      child: Container(
                        width: _imageWidth / 2,
                        height: 16,
                        color: Colors.white,
                      ),
                      baseColor: RevmoColors.baseShimmer,
                      highlightColor: RevmoColors.highlightShimmer,
                      enabled: !widget.canAccessCar,
                    )),
          //cars card
          GestureDetector(
            onTap: toggleCar,
            child: Container(
              height: _cardHeight,
              width: _cardWidth,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
              child: (widget.canAccessCar)
                  ? Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //carousel
                            Container(
                                margin: EdgeInsets.only(top: _checkboxHeight),
                                child: CarsCarousel(car: widget.c!, height: _imageHeight, width: _imageWidth)),
                            //car info
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: FittedBox(
                                  child: RevmoTheme.getSemiBold(widget.c!.motorCC.toString() + "cc " + " - " + widget.c!.horsePowerString, 1,
                                      weight: FontWeight.w700, color: RevmoColors.darkBlue)),
                            ),
                            FittedBox(
                                child: RevmoTheme.getSemiBold( widget.c!.model.type.name + " - " + widget.c!.rims.toString() + "' Rims" , 1,
                                    color: RevmoColors.darkBlue))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 5),
                          width: _checkboxWidth,
                          height: _checkboxHeight,
                          alignment: Alignment.topLeft,
                          child: RevmoCheckbox(
                            initialValue: isSelected,
                            onTap: toggleCar,
                          ),
                        ),
                      ],
                    )
                  : Shimmer.fromColors(
                      child: Container(
                        height: _cardHeight,
                        width: _cardWidth,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      baseColor: RevmoColors.baseShimmer,
                      highlightColor: RevmoColors.highlightShimmer,
                      enabled: !widget.canAccessCar),
            ),
          ),
        ],
      ),
    );
  }
}
