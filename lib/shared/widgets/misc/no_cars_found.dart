import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoCarsFound extends StatelessWidget {
  final bool isSellersCars;
  final Function()? addButtonFunc;
  NoCarsFound(this.isSellersCars, {this.addButtonFunc});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset(
        Paths.emptyCatalogSVG,
        color: RevmoColors.darkerBlue,
      ),
      SizedBox(
        height: 10,
      ),
      FittedBox(
        child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.noCars, 2, color: RevmoColors.originalBlue),
      ),
      if(isSellersCars)
      FittedBox(
        child: RevmoTheme.getBody(AppLocalizations.of(context)!.noCarsCaption, 1),
      ),
      SizedBox(
        height: 20,
      ),
      if(addButtonFunc!=null)
      MainButton(width: double.infinity, text: AppLocalizations.of(context)!.letsAddCars, callBack: addButtonFunc)
    ]));
  }
}
