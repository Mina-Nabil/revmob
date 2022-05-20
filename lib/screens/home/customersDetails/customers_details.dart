import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/screens/home/customers_tab.dart';
import 'package:revmo/shared/colors.dart';
import '../../../shared/widgets/Customers/customers_page.dart';
import '../../../shared/widgets/Customers/revmo_customer_deal_card.dart';
import '../../../shared/widgets/home/revmo_appbar.dart';

class CustomersDetails extends StatefulWidget {
  @override
  _CustomersDetailsState createState() => _CustomersDetailsState();
}

class _CustomersDetailsState extends State<CustomersDetails> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: RevmoAppBar(),
      backgroundColor: RevmoColors.darkBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                InitialsCircle(
                  name: 'MH',
                  opacity: 0.8,
                  whiteText: true,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Mohamed Helmy',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FadeIn(child: RevmoCarDetailsCard(isInitiallyExpanded: true,)),
            FadeInUp(child: RevmoCarCustomerDetailsCard()),
            FadeInUp(child: RevmoCustomerDealDetailsCard()),
            FadeInUp(child: RevmoReviewsList())
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}
