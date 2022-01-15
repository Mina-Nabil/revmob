import 'package:flutter/material.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/car_info_grid.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoCarDetailsCard extends StatelessWidget {
  final Car car;
  final bool isInitiallyExpanded;
  const RevmoCarDetailsCard(this.car, {this.isInitiallyExpanded = false});

  final double maxBoxHeight = 300;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: CarInfoGrid(car),
          title: AppLocalizations.of(context)!.details,
          initialStateExpanded: isInitiallyExpanded,
          minHeight: RevmoTheme.DETAILS_BOXES_MIN,
          maxHeight: maxBoxHeight,
        ));
  }
}
