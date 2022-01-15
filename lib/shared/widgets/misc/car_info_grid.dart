import 'package:flutter/material.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/shared/widgets/misc/accessory_tile.dart';
import 'package:revmo/shared/widgets/misc/info_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarInfoGrid extends StatelessWidget {
  final Car car;
  final bool isScrollable;
  const CarInfoGrid(this.car, {this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    final List<Widget> infoTiles = [
      CarInfoTile(svgPath: Paths.motorSVG, title: AppLocalizations.of(context)!.motor, value: car.motorCC.toString() + "cc"),
      //  CarInfoTile(svgPath: Paths.arrowsInSVG, title: AppLocalizations.of(context)!.gears, value: car.motorType),
      //  CarInfoTile(svgPath: Paths.speedometerSVG, title: AppLocalizations.of(context)!.gears, value: car.gears),
      CarInfoTile(svgPath: Paths.transmissionSVG, title: AppLocalizations.of(context)!.transmission, value: car.transmission),
      CarInfoTile(svgPath: Paths.motorSVG, title: AppLocalizations.of(context)!.torque, value: car.torque),
      //  CarInfoTile(svgPath: Paths.petrolStationSVG, title: AppLocalizations.of(context)!.fuel, value: car.gasType),
      //  CarInfoTile(svgPath: Paths.roadSVG, title: AppLocalizations.of(context)!.literPerKm, value: car.literPerKm),
      CarInfoTile(
          svgPath: Paths.topSpeedometerSVG,
          title: AppLocalizations.of(context)!.topSpeed,
          value: car.topSpeed.toString() + "Km/h"),
      CarInfoTile(svgPath: Paths.calendarSVG, title: AppLocalizations.of(context)!.year, value: car.model.year),
      CarInfoTile(svgPath: Paths.horsePowerSVG, title: AppLocalizations.of(context)!.horsePower, value: car.horsePowerString),
      //  CarInfoTile(svgPath: Paths.flagSVG, title: AppLocalizations.of(context)!.origin, value: car.model.origin),
      CarInfoTile(
          svgPath: Paths.accelerationSVG,
          title: AppLocalizations.of(context)!.acceleration,
          value: car.acceleration.toString() + "s"),
      CarInfoTile(svgPath: Paths.carLengthSVG, title: AppLocalizations.of(context)!.dimensions, value: car.dimensions),
      CarInfoTile(svgPath: Paths.carHeightSVG, title: AppLocalizations.of(context)!.carHeight, value: car.height.toString()),
      //  CarInfoTile(svgPath: Paths.carBodySVG, title: AppLocalizations.of(context)!.carWidth, value: car.width),
      CarInfoTile(
          svgPath: Paths.heightClearanceSVG, title: AppLocalizations.of(context)!.groundClearance, value: car.height.toString()),
      CarInfoTile(svgPath: Paths.rimsSVG, title: AppLocalizations.of(context)!.rims, value: car.rims.toString()),
    ];
    final List<Widget> accessoryTiles = car.accessories.map((e) => AccessoryTile(e)).toList();

    return SingleChildScrollView(
        physics: (isScrollable) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              childAspectRatio: 150 / 30,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              children: infoTiles,
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              childAspectRatio: 13.0,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              children: accessoryTiles,
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}
