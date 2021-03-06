import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/screens/catalog/car_details_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/date_row.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';

class CatalogTile extends StatelessWidget {
  final int _imageHeight = 110;
  final int _imageWidth = 190;
  final double _tileHeight = 150;
  final double _borderRadius = 8;
  final double _calHeight = 10;
  final double _margin = 6;

  final Car car;
  final List<ModelColor> ownedColors;
  const CatalogTile(this.car, this.ownedColors);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(CarDetailsScreen.ROUTE_NAME, arguments: CarDetailsScreenArguments(car, ownedColors)),
      child: Container(
        height: _tileHeight,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: _margin * 2),
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
                      errorBuilder: (_, __, stacktrace) {
                        print(stacktrace);
                        return RevmoImagePlaceholder(
                          height: _imageHeight.toDouble(),
                          width: _imageWidth.toDouble(),
                        );
                      },
                      width: _imageWidth.toDouble(),
                      height: _imageHeight.toDouble(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10, right: 2, bottom: 2),
                    child: DateRow(car.addedDate),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 5, top: 10),
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
                    child: RevmoTheme.getCaption(car.catgName, 1,
                        color: RevmoColors.darkBlue, isBold: true, weight: FontWeight.w600),
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
                            children: [
                              TextSpan(
                                  text: " " + AppLocalizations.of(context)!.egCurrency,
                                  style: RevmoTheme.getSemiBoldStyle(1, color: RevmoColors.darkBlue))
                            ]),
                      ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
