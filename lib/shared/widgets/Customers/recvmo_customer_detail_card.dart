import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';

import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/Customers/CUSTOMERS_MODDEL_MODEL.dart';
import 'detail_text.dart';

class RevmoBuyerDetailsCard extends StatelessWidget {
  final Buyer buyer;
  final bool isInitiallyExpanded;
  const RevmoBuyerDetailsCard({this.isInitiallyExpanded = false,required this.buyer});
  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Details(buyer: buyer,),
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
  final Buyer buyer;
  const Details({required this.buyer});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat();

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailText(
            title: "Name",
            info: buyer.fullName.toTitleCase(),
          ),
          DetailText(
            title: "National ID",
            info: buyer.buyerNationalId,
          ),
          DetailText(
            title: "Email",
            info: buyer.buyerMail!,
          ),
          DetailText(
            title: "Mobile No",
            info: buyer.buyerMob1!,
          ),
          // DetailText(
          //   title: "Address",
          //   info: buyer.,
          // ),
          DetailText(
            title: "Date of birth",
            info: DateFormat('dd-MM-yyyy').format(buyer.buyerBday!).toString(),
          ),
        ],
      ),
    );
  }
}

