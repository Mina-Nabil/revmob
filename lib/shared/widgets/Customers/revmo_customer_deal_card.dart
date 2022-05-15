import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoCustomerDealDetailsCard extends StatelessWidget {
  //haneb3at el customer class badal el car
  // final Car car;
  final bool isInitiallyExpanded;

  const RevmoCustomerDealDetailsCard({this.isInitiallyExpanded = false});

  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.topCenter,
      child: RevmoExpandableInfoCard(
        body: Details(),
        //Todo customer details
        // title: AppLocalizations.of(context)!.details,
        title: 'Deal Details',
        initialStateExpanded: isInitiallyExpanded,
        minHeight: RevmoTheme.DETAILS_BOXES_MIN,
        maxHeight: maxBoxHeight,
      ),
    );
  }
}

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(10),
              width: 100,
              decoration: BoxDecoration(
                color: Color(0xff26AEE4).withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: RevmoColors.darkBlue,
                    size: 17,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '25/2/1997',
                    style: TextStyle(color: RevmoColors.darkBlue, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailText(
                  title: "Price",
                  info: '1,500,000 EGP',
                ),
                DetailText(
                  title: "Min Reservation Payment",
                  info: '1000 EGP',
                ),
                DetailText(
                  title: "Payment Method",
                  info: 'Loan',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.3,
                      child: DetailText(
                        title: "Address",
                        info: 'Abbas El Akkad - Nasr City - Cairo - Egypt',
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    DetailText(
                      title: "Date of birth",
                      info: '5/0/1982',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  const DetailText({Key? key, required this.title, required this.info})
      : super(key: key);
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: RevmoColors.darkBlue,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            info,
            style: TextStyle(
              color: RevmoColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
