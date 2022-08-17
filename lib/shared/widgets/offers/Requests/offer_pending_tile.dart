import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/cars/revmo_image.dart';
import '../../../../models/offers/offer.dart';
import '../../../colors.dart';
import '../../../theme.dart';
import '../../catalog/brand_logo.dart';
import '../../misc/date_row.dart';
import '../../misc/main_button.dart';
import '../../misc/revmo_image_widget.dart';
import '../../settings/user_image.dart';

class PendingRequestTile extends StatelessWidget {
  const PendingRequestTile({
    Key? key,
    required this.pendingOffer,
    required this.extendOffer,
  }) : super(key: key);
  final Offer pendingOffer;
  final VoidCallback extendOffer;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    var toDay = DateTime.parse(DateTime.now().toString());
    var fromDate = DateTime.parse(pendingOffer.expiryDate.toString());
    Duration diff = fromDate.difference(toDay);

    var formatter = NumberFormat();
    return Stack(
      alignment: AppLocalizations.of(context)!.localeName == 'en'
          ? Alignment.topRight
          : Alignment.topLeft,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: UserImage(
                      pendingOffer.buyer,
                      30,
                      fallbackTiInitials: true,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: RevmoTheme.getBody(
                            pendingOffer.buyer.fullName, 1,
                            color: RevmoColors.lightPetrol),
                      ),
                      DateRow(pendingOffer.issuingDate),
                      SizedBox(
                        height: 15,
                      ),
                      BrandLogo(pendingOffer.car.model.brand, 26, 26),
                      SizedBox(
                        height: 5,
                      ),
                      RevmoTheme.getSemiBold(pendingOffer.car.model.fullName, 1,
                          color: RevmoColors.lightPetrol),
                      RevmoTheme.getBody(pendingOffer.car.desc1, 1,
                          color: RevmoColors.lightPetrol),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        diff.inDays <= 3
                            ? Text(
                                '${AppLocalizations.of(context)!.expiresIn} ${diff.inDays} ${AppLocalizations.of(context)!.days}',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                '${AppLocalizations.of(context)!.expiresIn} ${diff.inDays} ${AppLocalizations.of(context)!.days}',
                                style: TextStyle(color: Color(0xff26AEE4)),
                              ),
                        Container(
                          alignment:
                              AppLocalizations.of(context)!.localeName == "en"
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                          child: RevmoCarImageWidget(
                            revmoImage: RevmoCarImage(
                                imageURL: pendingOffer.car.model.imageUrl,
                                isModelImage: true,
                                sortingValue: 1),
                            imageHeight: 70,
                            imageWidth: 120,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          formatter.format(pendingOffer.price).toString() +
                              ' ${AppLocalizations.of(context)!.egp}',
                          style: TextStyle(
                              fontSize: 20,
                              color: RevmoColors.darkBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainButton(
                      width: mediaQuery.size.width * 0.5,
                      text: AppLocalizations.of(context)!.extendOfferFor2days,
                      callBack: extendOffer
                      // print('extend offer for 2 days ');
                      ),
                  MainButton(
                      color: Colors.transparent,
                      width: mediaQuery.size.width * 0.2,
                      text: AppLocalizations.of(context)!.cancelOffer,
                      textColor: Color(0xff26AEE4),
                      callBack: () {
                        print('Cancel offer');
                      }),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 20,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: RevmoColors.originalBlue.withAlpha(50)),
          child: FittedBox(
            child: RevmoTheme.getBody(pendingOffer.formattedID.toString(), 1,
                color: RevmoColors.lightPetrol),
          ),
        ),
      ],
    );
  }
}
