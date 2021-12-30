import 'package:flutter/material.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/shared/widgets/misc/color_selector.dart';
import './revmo_expandable_info_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoCarColorsCard extends StatelessWidget {
  final Car car;
  final bool isInitiallyExpanded;
  const RevmoCarColorsCard(this.car,{this.isInitiallyExpanded=false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.center,
        child: RevmoExpandableInfoContainer(
          initialStateExpanded: isInitiallyExpanded,
            title: AppLocalizations.of(context)!.colors,
            body:  GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: 
              car.model.colors
                  .map((e) => ModelColorSelector(
                        modelColor: e,
                        isSelected: new ValueNotifier(false),
                      ))
                  .toList(),
            ),
            minHeight: 40,
            maxHeight: 200));
  }
}
