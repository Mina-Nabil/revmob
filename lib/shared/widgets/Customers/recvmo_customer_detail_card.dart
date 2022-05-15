import 'package:flutter/material.dart';

import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoCarDetailsCard extends StatelessWidget {
  //haneb3at el customer class badal el car
  // final Car car;
  final bool isInitiallyExpanded;

  const RevmoCarDetailsCard({this.isInitiallyExpanded = false});

  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Details(),
          ),
          //Todo customer details
          title: AppLocalizations.of(context)!.details,
          initialStateExpanded: isInitiallyExpanded,
          minHeight: RevmoTheme.DETAILS_BOXES_MIN,
          maxHeight: maxBoxHeight,
        ));
  }
}

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailText(
            title: "Name",
            info: 'Mohamed Helmy Abd Ellatif',
          ),
          DetailText(
            title: "National ID",
            info: '0000000000000000',
          ),
          DetailText(
            title: "Email",
            info: 'Marcmgedbaky@hotmail.com',
          ),
          DetailText(
            title: "Mobile No",
            info: '01113266564',
          ),
          DetailText(
            title: "Address",
            info: 'Abbas El Akkad - Nasr City - Cairo - Egypt',
          ),
          DetailText(
            title: "Date of birth",
            info: '5/0/1982',
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
      padding: EdgeInsets.only(top: 10),
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
