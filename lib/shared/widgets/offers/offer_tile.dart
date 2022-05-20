import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/models/cars/revmo_image.dart';
import 'package:revmo/models/offers/new_offer_screen.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/brand_logo.dart';
import 'package:revmo/shared/widgets/misc/date_row.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';

class OfferTile extends StatelessWidget {
  final OfferRequest? request;
  final Offer? offer;
  final double _cardHeight;
  final bool _isRequest;

  const OfferTile.request(this.request)
      : offer = null,
        _isRequest = true,
        _cardHeight = 200;
  const OfferTile.pending(this.offer)
      : request = null,
        _isRequest = false,
        _cardHeight = 240;
  const OfferTile.approved(this.offer)
      : request = null,
        _isRequest = false,
        _cardHeight = 240;
  const OfferTile.expired(this.offer)
      : request = null,
        _isRequest = false,
        _cardHeight = 240;

  final double userImageDiameter = 30;

  @override
  Widget build(BuildContext context) {
    Widget idBox = Container(
      height: 20,
      width: 80,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: RevmoColors.originalBlue.withAlpha(50)),
      child: FittedBox(
        child: RevmoTheme.getBody(_isRequest ? request!.formatedID : offer!.formattedID, 1, color: RevmoColors.lightPetrol),
      ),
    );

    createNewOffer() {
      if (this.request != null)
        Navigator.of(context).push(PageTransition(child: NewOfferScreen(this.request!), type: PageTransitionType.rightToLeft));
    }

    return Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
        height: _cardHeight,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserImage(
                          (_isRequest) ? request!.buyer : offer!.buyer,
                          userImageDiameter,
                          fallbackTiInitials: true,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: userImageDiameter,
                              alignment: Alignment.center,
                              child: RevmoTheme.getBody((_isRequest) ? request!.buyer.fullName : offer!.buyer.fullName, 1,
                                  color: RevmoColors.lightPetrol),
                            ),
                            DateRow((_isRequest) ? request!.createdDate : offer!.issuingDate),
                            SizedBox(
                              height: 15,
                            ),
                            BrandLogo((_isRequest) ? request!.car.model.brand : offer!.car.model.brand, 26, 26),
                            SizedBox(
                              height: 5,
                            ),
                            RevmoTheme.getSemiBold((_isRequest) ? request!.car.model.fullName : offer!.car.model.fullName, 1,
                                color: RevmoColors.lightPetrol),
                            RevmoTheme.getBody((_isRequest) ? request!.car.desc1 : offer!.car.desc1, 1,
                                color: RevmoColors.lightPetrol),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: RevmoCarImageWidget(
                              revmoImage: RevmoCarImage(
                                  imageURL: (_isRequest) ? request!.car.model.imageUrl : offer!.car.model.fullName,
                                  isModelImage: true,
                                  sortingValue: 1),
                              imageHeight: 70,
                              imageWidth: 120,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MainButton(text: AppLocalizations.of(context)!.createOffer, callBack: createNewOffer)
                ],
              ),
            ),
            idBox,
          ],
        ));
  }
}
