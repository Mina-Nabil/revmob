import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';
import 'package:revmo/shared/widgets/UIwidgets/custom_cachedNetwork.dart';

import '../../../../environment/paths.dart';
import '../../../../models/cars/revmo_image.dart';
import '../../../../models/offers/offer.dart';
import '../../../../screens/offers/approved_offer_detail.dart';
import '../../../../screens/offers/approved_offer_view.dart';
import '../../../colors.dart';
import '../../../theme.dart';
import '../../UIwidgets/initial_name_widget.dart';
import '../../catalog/brand_logo.dart';
import '../../misc/date_row.dart';
import '../../misc/main_button.dart';
import '../../misc/revmo_image_widget.dart';
import '../../settings/user_image.dart';

class ApprovedExpiredRequestTile extends StatelessWidget {
  const ApprovedExpiredRequestTile({
    Key? key,
    required this.offer,
    this.extendOffer,
    required this.approved,
  }) : super(key: key);
  final Offer offer;
  final VoidCallback? extendOffer;
  final bool approved;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    var toDay = DateTime.parse(DateTime.now().toString());
    var fromDate = DateTime.parse(offer.expiryDate.toString());
    Duration diff = fromDate.difference(toDay);

    var formatter = NumberFormat();
    return Stack(
      alignment: AppLocalizations.of(context)!.localeName == 'en'
          ? Alignment.topRight
          : Alignment.topLeft,
      children: [
        Container(
          // margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(12),

          // height: 162,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //initial name
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: UserImage(
                      offer.buyer,
                      30,
                      fallbackTiInitials: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),

                  //left Column
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            // 'Buyer Name'
                            offer.buyer.fullName.toTitleCase(),
                            style: TextStyle(color: RevmoColors.darkBlue),
                          ),
                        ),
                        DateRow(offer.buyerResponseDate!),
                        SizedBox(
                          height: 5,
                        ),
                        _CarLogoName(
                          offer: offer,
                          logoUrl: offer.car.model.brand.logoURL,
                          carName: offer.car.carName,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        !approved
                            ? SizedBox(
                                height: 12,
                              )
                            : SizedBox.shrink(),
                        // Row(
                        //   children: [
                        //     offer.seller.image == null
                        //         ? Icon(
                        //             Icons.account_circle_rounded,
                        //             color: RevmoColors.white,
                        //           )
                        //         : SizedBox(
                        //             height: 20,
                        //             child:
                        //                 Image.network(offer.seller.image!)),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     SizedBox(
                        //       width: 100,
                        //       child: Text(
                        //         // 'seller name',
                        //         offer.seller.fullName.toTitleCase(),
                        //         style: TextStyle(color: RevmoColors.darkBlue),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  //right Column
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            approved
                                ? SizedBox(
                                    height: 5,
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            Paths.calendarSVG,
                                            color: Colors.red,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                              offer.formatedExpiryDate
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                            SizedBox(
                                height: 100,
                                child: CustomCachedImageNetwork(
                                    imageUrl: offer.car.model.imageUrl)),
                            // SizedBox(
                            //   height: 4,
                            // ),
                            // Text(
                            //   '${formatter.format(offer.price).toString()} ${AppLocalizations.of(context)!.egp}',
                            //   style: TextStyle(
                            //       color: RevmoColors.darkBlue,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 20),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            offer.seller.image == null
                                ? Icon(
                                    Icons.account_circle_rounded,
                                    color: RevmoColors.white,
                                  )
                                : SizedBox(
                                    height: 20,
                                    child: Image.network(offer.seller.image!)),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                // 'seller name',
                                offer.seller.fullName.toTitleCase(),
                                style: TextStyle(color: RevmoColors.darkBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${formatter.format(offer.price).toString()} ${AppLocalizations.of(context)!.egp}',
                          style: TextStyle(
                              color: RevmoColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  MainButton(
                      width: mediaQuery.size.width,
                      text: approved
                          ? AppLocalizations.of(context)!.offerDetail
                          : AppLocalizations.of(context)!.renewOffer,
                      callBack: () {
                        if (approved) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AcceptedOfferView(
                                        offer: offer,
                                      )));
                        } else {
                          // expired tab
                          print(offer.id);
                          extendOffer!();
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.all(Radius.circular(7)),
        //       color: Colors.white),
        //   width: double.infinity,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           ClipRRect(
        //             borderRadius: BorderRadius.circular(20),
        //             child: UserImage(
        //               offer.buyer,
        //               30,
        //               fallbackTiInitials: true,
        //             ),
        //           ),
        //           SizedBox(
        //             width: 4,
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Container(
        //                 height: 30,
        //                 alignment: Alignment.center,
        //                 child: RevmoTheme.getBody(offer.buyer.fullName, 1,
        //                     color: RevmoColors.lightPetrol),
        //               ),
        //               DateRow(offer.buyerResponseDate!),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               BrandLogo(offer.car.model.brand, 26, 26),
        //               SizedBox(
        //                 height: 5,
        //               ),
        //               RevmoTheme.getSemiBold(offer.car.model.fullName, 1,
        //                   color: RevmoColors.lightPetrol),
        //               RevmoTheme.getBody(offer.car.desc1, 1,
        //                   color: RevmoColors.lightPetrol),
        //
        //               Row(
        //                 children: [
        //
        //                   RevmoTheme.getBody(offer.seller.fullName, 1,
        //                       color: RevmoColors.lightPetrol),
        //                 ],
        //               ),
        //
        //             ],
        //           ),
        //           Expanded(
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.end,
        //               children: [
        //                 const SizedBox(
        //                   height: 16,
        //                 ),
        //                 approved
        //                     ? SizedBox(height: 25,)
        //                     : Column(
        //                       children: [
        //                         SizedBox(
        //                           height: 5,
        //                         ),
        //                         Row(
        //                   mainAxisAlignment: MainAxisAlignment.end,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                         SvgPicture.asset(
        //                           Paths.calendarSVG,
        //                           color: Colors.red,
        //                           height: 10,
        //                         ),
        //                         SizedBox(
        //                           width: 3,
        //                         ),
        //                         Text(offer.formatedExpiryDate.toString(),
        //                             style: TextStyle(
        //                                 color: Colors.red,
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 12)),
        //                   ],
        //                 ),
        //                         SizedBox(
        //                           height: 5,
        //                         ),
        //                       ],
        //                     ),
        //                 Container(
        //                   alignment:
        //                   AppLocalizations.of(context)!.localeName == "en"
        //                       ? Alignment.bottomRight
        //                       : Alignment.bottomLeft,
        //                   child: RevmoCarImageWidget(
        //                     revmoImage: RevmoCarImage(
        //                         imageURL: offer.car.model.imageUrl,
        //                         isModelImage: true,
        //                         sortingValue: 1),
        //                     imageHeight: 70,
        //                     imageWidth: 120,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 20,
        //                 ),
        //                 Text(
        //                   formatter.format(offer.price).toString() +
        //                       ' ${AppLocalizations.of(context)!.egp}',
        //                   style: TextStyle(
        //                       fontSize: 20,
        //                       color: RevmoColors.darkBlue,
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //
        //
        //               ],
        //             ),
        //           ),
        //
        //
        //
        //         ],
        //       ),
        //       MainButton(
        //           width: mediaQuery.size.width,
        //           text: approved
        //               ? AppLocalizations.of(context)!.offerDetail
        //               : AppLocalizations.of(context)!.renewOffer,
        //           callBack: () {
        //             if (approved) {} else {
        //               // expired tab
        //               print(offer.id);
        //               extendOffer!();
        //             }
        //           }),
        //     ],
        //   ),
        // ),
        Container(
          height: 20,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: RevmoColors.originalBlue.withAlpha(50)),
          child: FittedBox(
            child: RevmoTheme.getBody(offer.formattedID.toString(), 1,
                color: RevmoColors.lightPetrol),
          ),
        ),
      ],
    );
  }
}

class _CarLogoName extends StatelessWidget {
  const _CarLogoName({
    Key? key,
    required this.logoUrl,
    required this.carName,
    required this.offer,
  }) : super(key: key);

  final String logoUrl;
  final String carName;
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 25,
            child: Image.network(
              logoUrl,
              errorBuilder: (context, e, s) {
                return Icon(
                  Icons.error,
                  size: 10,
                  color: Colors.red,
                );
              },
            )),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 5,
        ),
        RevmoTheme.getSemiBold(offer.car.model.fullName, 1,
            color: RevmoColors.lightPetrol),
        RevmoTheme.getBody(offer.car.desc1, 1, color: RevmoColors.lightPetrol),
      ],
    );
  }
}
