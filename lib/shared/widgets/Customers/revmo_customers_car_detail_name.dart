import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';

import '../../../providers/catalog_provider.dart';
import '../../colors.dart';

class RevmoCarCustomerDetailsCard extends StatelessWidget {
  // final Car car;
  final bool isInitiallyExpanded;
  final double maxBoxHeight = 654;

  const RevmoCarCustomerDetailsCard({this.isInitiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: 4.0),
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: CardDetailsCustomer(),
          ),
          // title: AppLocalizations.of(context)!.details,
          title: 'Car Details',
          initialStateExpanded: isInitiallyExpanded,
          minHeight: RevmoTheme.DETAILS_BOXES_MIN,
          maxHeight: maxBoxHeight,
        ));
  }
}

class CardDetailsCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final catalog = Provider.of<CatalogProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child:
                      Image.network(catalog.catalog.models[0].brand.logoURL),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  catalog.catalog.models[0].fullName,
                  style: TextStyle(color: RevmoColors.darkBlue),
                ),
                SizedBox(
                  height: 1,
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.3,
                  child: Text(
                    'A/T / INSCRIPTION 2021 - Silver',
                    style: TextStyle(color: RevmoColors.darkBlue),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: mediaQuery.size.width * 0.4,
              child: Image.network(catalog.catalog.models[0].imageUrl),
            ),
          ],
        ),
      ],
    );
  }
}
