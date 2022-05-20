import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';

class NotFoundWidget extends StatelessWidget {
  final bool isOffers;
  final bool isCustomers;
  final bool isCars;
  final bool isSellersCars;
  final Function()? callback;

  NotFoundWidget.cars(this.isSellersCars, [this.callback])
      : isCars = true,
        isCustomers = false,
        isOffers = false;
  NotFoundWidget.customers([this.callback])
      : isCars = false,
        isCustomers = true,
        isOffers = false,
        isSellersCars = false;
  NotFoundWidget.offers([this.callback])
      : isCars = false,
        isCustomers = false,
        isOffers = true,
        isSellersCars = false;

  @override
  Widget build(BuildContext context) {
    String title = (isOffers)
        ? AppLocalizations.of(context)!.noOffers
        : (isCars)
            ? AppLocalizations.of(context)!.noCars
            : AppLocalizations.of(context)!.noCustomers;

    String subtitle = (isOffers)
        ? AppLocalizations.of(context)!.noOffersSub
        : (isCars)
            ? AppLocalizations.of(context)!.noCarsCaption
            : AppLocalizations.of(context)!.noCustomersSub;

    String svgPath = (isCars) ? Paths.emptyCatalogSVG : Paths.noCustomersSVG;

    return LayoutBuilder(
        builder: (context, constraints) => ListView(children: [
              Container(
                  alignment: Alignment.center,
                  height: constraints.maxHeight,
                  child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset(
                      svgPath,
                      color: RevmoColors.darkerBlue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: RevmoTheme.getSemiBold(title, 2, color: RevmoColors.originalBlue),
                    ),
                    if (isSellersCars)
                      FittedBox(
                        child: RevmoTheme.getBody(subtitle, 1),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (callback != null)
                      MainButton(width: double.infinity, text: AppLocalizations.of(context)!.letsAddCars, callBack: callback)
                  ])))
            ]));
  }
}
