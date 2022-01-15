import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/color_selector.dart';
import 'revmo_expandable_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoCarColorsCard extends StatelessWidget {
  final Car car;
  final bool isInitiallyExpanded;
  final List<ModelColor> initiallySelectedColors;
  const RevmoCarColorsCard(this.car, {this.isInitiallyExpanded = false, this.initiallySelectedColors = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.center,
        child: RevmoExpandableInfoCard(
            initialStateExpanded: isInitiallyExpanded,
            title: AppLocalizations.of(context)!.colors,
            body: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              children: car.model.colors.map((e) {
                ValueNotifier<bool> selectionNotifier = new ValueNotifier(initiallySelectedColors.contains(e));
                return ModelColorSelector(
                  car: car,
                  modelColor: e,
                  isSelected: selectionNotifier,
                );
              }).toList(),
            ),
            minHeight: RevmoTheme.DETAILS_BOXES_MIN,
            maxHeight: 300));
  }
}
