import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car_accessory.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class AccessoryTile extends StatelessWidget {
  final CarAccessory accessory;
  const AccessoryTile(this.accessory);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 9),
            child: SizedBox(
                height: 12,
                width: 12,
                child: Container(decoration: BoxDecoration(color: RevmoColors.originalBlue, shape: BoxShape.circle), child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(child:Icon(Icons.check, color: Colors.white)),
                ))),
          ),
          FittedBox(child: RevmoTheme.getBody(accessory.name, 1, color: RevmoColors.darkBlue),)
        ],
      ),
    );
  }
}
