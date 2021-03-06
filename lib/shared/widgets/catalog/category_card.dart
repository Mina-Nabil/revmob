import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/screens/catalog/brand_models_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_car_images_card.dart';
import 'package:revmo/shared/widgets/misc/revmo_checkbox.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryCard extends StatefulWidget {
  final Car? c;
  final bool isLoading;
  final bool isFoundOnCatalog;
  bool get canAccessCar => !isLoading && c != null;
  CategoryCard(this.c, this.isFoundOnCatalog) : this.isLoading = false;
  CategoryCard.placeholder()
      : c = null,
        isLoading = true,
        isFoundOnCatalog = false;
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final double _cardHeight = 360;
  final double _imageHeight = 290;
  final double _imageWidth = 320;
  final double _checkboxHeight = 60;
  final double _checkboxWidth = 35;

  bool isSelected = false;
  bool isToggled = false;

  void toggleCar() {
    isToggled = true;
    if (widget.canAccessCar) {
      CarsSelectionWidget.of(context).toggleCar(widget.c!);
      setState(() {
        isSelected = CarsSelectionWidget.of(context).hasCar(widget.c!);
      });
      print(CarsSelectionWidget.of(context).selectedCars.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          (widget.canAccessCar)
              ? Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    GestureDetector(
                        onTap: toggleCar,
                        child: RevmoCarImagesCard(
                          widget.c!,
                          height: _cardHeight,
                          imagesWidth: _imageWidth,
                          imagesHeight: _imageHeight,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          width: _checkboxWidth,
                          height: _checkboxHeight,
                          alignment: Alignment.topLeft,
                          child: RevmoCheckbox(
                            initialValue: isSelected,
                            onTap: toggleCar,
                          ),
                        ),
                        Tooltip(
                            padding: EdgeInsets.all(5),
                            height: 35,
                            triggerMode: (widget.isFoundOnCatalog) ? TooltipTriggerMode.tap : TooltipTriggerMode.manual,
                            textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                            message: AppLocalizations.of(context)!.carFoundInCatalogMsg,
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              width: _checkboxWidth,
                              height: _checkboxHeight,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.bookmark_added,
                                color: widget.isFoundOnCatalog ? RevmoColors.darkGreen : RevmoColors.darkGrey,
                                size: 30,
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              : Shimmer.fromColors(
                  child: Container(
                    height: _cardHeight,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  baseColor: RevmoColors.baseShimmer,
                  highlightColor: RevmoColors.highlightShimmer,
                  enabled: !widget.canAccessCar),
        ],
      ),
    );
  }
}
