import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';

import '../../../models/cars/car.dart';
import '../../../providers/Seller/catalog_provider.dart';
import '../../colors.dart';
import '../misc/car_info_grid.dart';

class RevmoCarCustomerDetailsCard extends StatelessWidget {
  final Car car;
  final bool isInitiallyExpanded;
  final double maxBoxHeight = 450;

  const RevmoCarCustomerDetailsCard(
      {this.isInitiallyExpanded = false, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: 4.0),
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: CardDetailsCustomer(
              car: car,
            ),
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
  final Car car;

  const CardDetailsCustomer({required this.car});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final catalog = Provider.of<CatalogProvider>(context);
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
                  child: Image.network(car.model.brand.logoURL),
                ),
           const      SizedBox(
                  height: 5,
                ),
                // Text(
                //   car.model.fullName,
                //   style: TextStyle(color: RevmoColors.darkBlue),
                // ),
                // SizedBox(
                //   height: 1,
                // ),
                SizedBox(
                  width: mediaQuery.size.width * 0.3,
                  child: Text(
                    // 'A/T / INSCRIPTION 2021 - Silver',
                    car.carName,
                    style: TextStyle(color: RevmoColors.darkBlue),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: mediaQuery.size.width * 0.4,
              child: Image.network(car.model.imageUrl),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        CarInfoGrid(car),
      ],
    );
  }
}
