import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/images_carousel.dart';
import 'package:revmo/shared/widgets/misc/car_info_grid.dart';
import 'package:revmo/shared/widgets/misc/horizontal_small_car_images.dart';
import 'package:revmo/shared/widgets/misc/revmo_car_colors_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarSelectionDetailedPage extends StatefulWidget {
  final Car car;
  final List<ModelColor> selectedColors;
  const CarSelectionDetailedPage(this.car, {this.selectedColors = const []});

  @override
  State<CarSelectionDetailedPage> createState() => _CarSelectionDetailedPageState();
}

class _CarSelectionDetailedPageState extends State<CarSelectionDetailedPage> with SingleTickerProviderStateMixin {
  final Duration _arrowAnimationDuration = const Duration(milliseconds: 200);
  final Duration _boxAnimationDuration = const Duration(milliseconds: 1500);
  final double _carouselHeight = 280;
  final double _carouserWidth = 320;
  final double _maxHeight = 1000;
  final double _minHeight = 435;
  final double _largeTextBoxHeight = 25;
  late AnimationController _controller;

  late double _mainCardHeight;

  toggleMainCardSize() {
    if (_mainCardHeight == _minHeight) {
      _controller.forward();
      setState(() {
        _mainCardHeight = _maxHeight;
      });
    } else {
      _controller.reverse();
      setState(() {
        _mainCardHeight = _minHeight;
      });
    }
  }

  @override
  void initState() {
    _mainCardHeight = _minHeight;
    _controller = AnimationController(
      duration: _arrowAnimationDuration,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              height: _largeTextBoxHeight,
              child: FittedBox(child: RevmoTheme.getSemiBold(widget.car.carName, 2, color: RevmoColors.white))),
          Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              alignment: Alignment.centerLeft,
              height: _largeTextBoxHeight,
              child: FittedBox(
                child: RevmoTheme.getSemiBold(widget.car.desc1, 1, color: RevmoColors.white),
              )),
          AnimatedContainer(
            duration: _boxAnimationDuration,
            curve: RevmoTheme.BOXES_CURVE,
            constraints: BoxConstraints(minHeight: _minHeight, maxHeight: _mainCardHeight),
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                RevmoImagesCarousel(
                  car: widget.car,
                  height: _carouselHeight,
                  width: _carouserWidth,
                ),
                //car info
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: RevmoTheme.getSemiBold(widget.car.desc1, 1, weight: FontWeight.w700, color: RevmoColors.darkBlue),
                ),
                Container(
                    alignment: Alignment.center, child: RevmoTheme.getSemiBold(widget.car.desc2, 1, color: RevmoColors.darkBlue)),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: HorizontalSmallCarImagesList(widget.car),
                ),
                //Expandable details section title
                GestureDetector(
                  onTap: toggleMainCardSize,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.25).animate(_controller),
                          child: Icon(
                            Icons.arrow_right,
                            color: RevmoColors.originalBlue,
                          ),
                        ),
                        Center(
                            child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.details, 1, color: RevmoColors.darkBlue))
                      ],
                    ),
                  ),
                ),
                //Expandable details section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: CarInfoGrid(
                    widget.car,
                    isScrollable: true,
                  ),
                )
              ],
            ),
          ),
          RevmoCarColorsCard(
            widget.car,
            initiallySelectedColors: widget.selectedColors,
          ),
        ],
      ),
    );
  }
}
