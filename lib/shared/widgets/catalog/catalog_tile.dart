import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class CatalogTile extends StatelessWidget {
  final int _imageHeight = 110;
  final int _imageWidth = 190;
  final double _tileHeight = 150;
  final double _borderRadius = 8;
  final double _calHeight = 10;
  final double _margin = 6;

  final Car car;

  const CatalogTile(this.car);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _tileHeight,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: _margin),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(_borderRadius))),
      child: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    car.model.imageUrl,
                    cacheHeight: _imageHeight,
                    cacheWidth: _imageWidth,
                    width: _imageWidth.toDouble(),
                    height: _imageHeight.toDouble(),
                  ),
                ),
                Row(
                  children: [
                    FittedBox(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10, right: 2, bottom: 2),
                        child: SvgPicture.asset(
                          Paths.calendarSVG,
                          color: RevmoColors.darkBlue,
                          height: _calHeight,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: RevmoTheme.getCaption(car.formattedDate, 1, color: RevmoColors.darkBlue),
                    ),
                  ],
                )
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: 40,
                      child: Image.network(
                        car.model.brand.logoURL,
                      ),
                    )),
                FittedBox(
                  child: RevmoTheme.getSemiBold(car.model.fullName, 1, color: RevmoColors.darkBlue),
                ),
                FittedBox(
                  child:
                      RevmoTheme.getCaption(car.catgName, 1, color: RevmoColors.darkBlue, isBold: true, weight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                FittedBox(
                  child: RevmoTheme.getCaption(AppLocalizations.of(context)!.price, 1,
                      color: RevmoColors.darkBlue, isBold: true, weight: FontWeight.w600),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FittedBox(
                        child: RichText(
                      text: TextSpan(
                          text: car.formattedPrice.toString(),
                          style: RevmoTheme.getSemiBoldStyle(2, color: RevmoColors.darkBlue),
                          children: [TextSpan(text: " EGP", style: RevmoTheme.getSemiBoldStyle(1, color: RevmoColors.darkBlue))]),
                    ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
