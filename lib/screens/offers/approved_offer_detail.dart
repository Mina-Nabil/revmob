import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/shared/widgets/UIwidgets/initial_name_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/accounts/buyer.dart';
import '../../shared/colors.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/Customers/customers_page.dart';
import '../../shared/widgets/Customers/revmo_customer_deal_card.dart';
import '../../shared/widgets/home/revmo_appbar.dart';
import '../../shared/widgets/misc/revmo_expandable_info_card.dart';


class ApprovedOfferDetail extends StatefulWidget {
  final Offer offerFromApproved;

  const ApprovedOfferDetail({Key? key, required this.offerFromApproved})
      : super(key: key);

  @override
  State<ApprovedOfferDetail> createState() => _ApprovedOfferDetailState();
}

class _ApprovedOfferDetailState extends State<ApprovedOfferDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RevmoAppBar(),
      backgroundColor: RevmoColors.darkBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RevmoInitialNameWidget(
                        initial: widget.offerFromApproved.buyer.initials),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.offerFromApproved.buyer.fullName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text(
                  widget.offerFromApproved.formattedID,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FadeIn(
                child: _RevmoBuyerDetailsCard(
              isInitiallyExpanded: true,
              buyer: widget.offerFromApproved.buyer!,
            )),
            FadeInUp(
                child: RevmoCarCustomerDetailsCard(
              car: widget.offerFromApproved.car,
            )),
            FadeInUp(
                child: _RevmoCustomerDealDetailsCard(
              offer: widget.offerFromApproved,
            )),
            // FadeInUp(child: RevmoReviewsList())
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}

class _RevmoCustomerDealDetailsCard extends StatelessWidget {
  //haneb3at el customer class badal el car
  // final Car car;
  final Offer offer;
  final bool isInitiallyExpanded;

  const _RevmoCustomerDealDetailsCard(
      {this.isInitiallyExpanded = false, required this.offer});

  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.topCenter,
      child: RevmoExpandableInfoCard(
        body: _DealDetails(
          offer: offer,
        ),
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

class _DealDetails extends StatelessWidget {
  final Offer offer;

  const _DealDetails({required this.offer});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat();

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
              width: 110,
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
                    // '25/2/1997',
                    DateFormat('dd-MM-yyyy')
                        .format(offer.issuingDate)
                        .toString(),
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
                _DetailText(
                  title: "Price",
                  info: formatter.format(offer.price),
                ),
                _DetailText(
                  title: "Min Reservation Payment",
                  info: formatter.format(offer.downPayment),
                ),
                _DetailText(
                  title: "Payment Method",
                  info: offer.isLoan ? 'No Loan Option' : 'Loan',
                ),

                // offer.offerCanLoan == 1 ? SizedBox.shrink():
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //       width: mediaQuery.size.width * 0.3,
                //       child: DetailText(
                //         title: "Loan Amount/ month ",
                //         info: '7000 EGP',
                //       ),
                //     ),
                //     SizedBox(
                //       width: 50,
                //     ),
                //     DetailText(
                //       title: "Duration",
                //       info: '5 years',
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  const _DetailText({Key? key, required this.title, required this.info})
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

class _RevmoBuyerDetailsCard extends StatelessWidget {
  final Buyer buyer;
  final bool isInitiallyExpanded;

  const _RevmoBuyerDetailsCard(
      {this.isInitiallyExpanded = false, required this.buyer});

  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.topCenter,
        child: RevmoExpandableInfoCard(
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: _Details(
              buyer: buyer,
            ),
          ),
          //Todo customer details
          title: AppLocalizations.of(context)!.details,
          initialStateExpanded: isInitiallyExpanded,
          minHeight: RevmoTheme.DETAILS_BOXES_MIN,
          maxHeight: maxBoxHeight,
        ));
  }
}

class _Details extends StatelessWidget {
  final Buyer buyer;

  const _Details({required this.buyer});

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
            info: buyer.fullName,
          ),

          DetailText(
            title: "Email",
            info: buyer.email,
          ),
          DetailText(
            title: "Mobile No",
            info: buyer.mob,
          ),
          // DetailText(
          //   title: "Address",
          //   info: buyer.,
          // ),
          // DetailText(
          //   title: "Date of birth",
          //   info: DateFormat('dd-MM-yyyy').format(buyer.buyerBday!).toString(),
          // ),
        ],
      ),
    );
  }
}


class TileContainer extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  const TileContainer({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ]),
        child: child,
      ),
    );
  }
}

