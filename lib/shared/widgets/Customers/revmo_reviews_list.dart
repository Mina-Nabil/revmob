import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_expandable_info_card.dart';

class RevmoReviewsList extends StatelessWidget {
  //haneb3at el customer class badal el car
  // final Car car;
  final bool isInitiallyExpanded;

  const RevmoReviewsList({this.isInitiallyExpanded = false});

  final double maxBoxHeight = 330;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.topCenter,
      child: RevmoExpandableInfoCard(
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              ReviewContainer(),
              ReviewContainer(),
              ReviewContainer(),
            ],
          ),
        ),
        //Todo customer details
        // title: AppLocalizations.of(context)!.details,
        title: 'Reviews',
        initialStateExpanded: isInitiallyExpanded,
        minHeight: RevmoTheme.DETAILS_BOXES_MIN,
        maxHeight: maxBoxHeight,
      ),
    );
  }
}

class ReviewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
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
                    style: TextStyle(fontSize: 10, color: RevmoColors.darkBlue),
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
                    style: TextStyle(fontSize: 10, color: RevmoColors.darkBlue),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff26AEE4).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"s standard dummy text ever since the 1500s,',
              style: TextStyle(color: RevmoColors.darkBlue),
            ),
          )
        ],
      ),
    );
  }
}
