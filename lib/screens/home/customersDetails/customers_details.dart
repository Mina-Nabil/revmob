import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/models/Customers/CUSTOMERS_MODDEL_MODEL.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/UIwidgets/initial_name_widget.dart';
import '../../../shared/widgets/Customers/customers_page.dart';
import '../../../shared/widgets/Customers/revmo_customer_deal_card.dart';
import '../../../shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';
class CustomersDetails extends StatefulWidget {

final SoldOffer customer;
  const CustomersDetails ({ Key? key, required this.customer }): super(key: key);
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
                RevmoInitialNameWidget(initial:  widget.customer.buyer!.initials),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.customer.buyer!.buyerName!.toTitleCase(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FadeIn(child: RevmoBuyerDetailsCard(isInitiallyExpanded: true,buyer: widget.customer.buyer!,)),
            FadeInUp(child: RevmoCarCustomerDetailsCard(car: widget.customer.car!,)),
            FadeInUp(child: RevmoCustomerDealDetailsCard(offer: widget.customer,)),
            FadeInUp(child: RevmoReviewsList())
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}
