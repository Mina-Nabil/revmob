import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';

import '../../../models/Customers/CUSTOMERS_MODDEL_MODEL.dart';
import '../../colors.dart';
import '../../theme.dart';
import '../UIwidgets/initial_name_widget.dart';

class CustomersListTile extends StatelessWidget {
  final SoldOffer customerSoldOffer;

  CustomersListTile({Key? key, required this.customerSoldOffer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat();
    return Container(
      // margin: EdgeInsets.only(bottom: 20),
      // height: 162,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //initial name
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RevmoInitialNameWidget(
                        initial: customerSoldOffer.buyer!.initials,
                      )),
                ),


                //left Column
                Expanded(

                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          // 'Buyer Name'
                          customerSoldOffer.buyer!.fullName.toTitleCase(),
                          style: TextStyle(color: RevmoColors.darkBlue),
                        ),
                      ),
                      _CarLogoName(
                        logoUrl: customerSoldOffer.car!.model.brand.logoURL,
                        carName: customerSoldOffer.car!.carName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          customerSoldOffer.seller!.sellerImge == null
                              ? Icon(
                                  Icons.account_circle_rounded,
                                  color: RevmoColors.white,
                                )
                              : SizedBox(
                                  height: 20,
                                  child: Image.network(
                                      customerSoldOffer.seller!.sellerImge)),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              // 'seller name',
                              customerSoldOffer.seller!.sellerName!.toTitleCase(),
                              style: TextStyle(color: RevmoColors.darkBlue),
                            ),
                          ),
                        ],
                      ),
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
                            height: 100,
                              child: Image.network(customerSoldOffer.car!.model.imageUrl)),
                          SizedBox(
                            height: 6,
                          ),

                          Text(
                            '${ formatter.format( customerSoldOffer.offerPrice).toString()} EGP',
                            style: TextStyle(
                                color: RevmoColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Expiry Date :',style: TextStyle(color: RevmoColors.darkBlue,fontSize: 12),),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  // '2010/10/10',
                                  DateFormat('dd-MM-yyyy').format( customerSoldOffer.offerExpiryDate ?? DateTime.now()).toString(),
                                  style: TextStyle(
                                      color: RevmoColors.darkBlue,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _BottomDateRating(ratingOne: 2, ratingTwo: 3,date: customerSoldOffer.offerStartDate, expiryDate: customerSoldOffer.offerExpiryDate,)
        ],
      ),
    );
  }
}

class _BottomDateRating extends StatelessWidget {
  const _BottomDateRating({
    Key? key, required this.date, required this.ratingOne, required this.ratingTwo, this.expiryDate,
  }) : super(key: key);
final DateTime? date;
final DateTime? expiryDate;
final int ratingOne;
final int ratingTwo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 10),
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xff26AEE4).withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                // '2010/10/10',
                  DateFormat('dd-MM-yyyy').format( date ?? DateTime.now()).toString(),
                style: TextStyle(
                    color: RevmoColors.darkBlue,
                    fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bus_alert_outlined,
                    color: RevmoColors.darkBlue,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RatingBarIndicator(
                    rating: 3,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 10.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ' |  3.0',
                    style: TextStyle(
                        fontSize: 10, color: RevmoColors.darkBlue),
                  )
                ],
              ),

              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.bus_alert_outlined,
                    color: RevmoColors.darkBlue,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RatingBarIndicator(
                    rating: 3,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 10.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ' |  3.0',
                    style: TextStyle(
                        fontSize: 10, color: RevmoColors.darkBlue),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarLogoName extends StatelessWidget {
  const _CarLogoName({
    Key? key,
    required this.logoUrl,
    required this.carName,
  }) : super(key: key);

  final String logoUrl;
  final String carName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30, child: Image.network(logoUrl)),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 100,
          child: Text(
            // customerProvider.customersList[index].car!.carName,
            carName,
            style: TextStyle(color: RevmoColors.darkBlue),
          ),
        ),
      ],
    );
  }
}

