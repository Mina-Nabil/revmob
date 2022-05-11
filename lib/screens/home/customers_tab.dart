import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:revmo/shared/colors.dart';

import '../../environment/paths.dart';
import '../../providers/catalog_provider.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/home/search_bar.dart';
import '../../shared/widgets/misc/revmo_icon_only_button.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';

class CustomersTab extends StatelessWidget {
  static const String screenName = "customerTab";

  @override
  Widget build(BuildContext context) {
    final catalog = Provider.of<CatalogProvider>(context);

    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Text(
            "Customers",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: RevmoTheme.SEARCH_BAR_HEIGHT,
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  height: RevmoTheme.SEARCH_BAR_HEIGHT,
                  searchCallback: null,
                  textEditingController: TextEditingController(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 1),
                child: RevmoIconButton(
                  callback: null,
                  width: RevmoTheme.SEARCH_BAR_HEIGHT,
                  color: RevmoColors.petrol,
                  iconWidget:
                      SvgPicture.asset(Paths.sortSVG, color: Colors.white),
                  iconPadding: 10,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: RevmoIconButton(
                    callback: null,
                    width: RevmoTheme.SEARCH_BAR_HEIGHT,
                    color: RevmoColors.originalBlue,
                    iconWidget:
                        SvgPicture.asset(Paths.filtersSVG, color: Colors.white),
                    iconPadding: 10,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => FadeInUp(
                duration: Duration(milliseconds: 700),
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  // height: 162,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color(0xff07C5FA).withOpacity(0.2),
                                  child: Text(
                                    'MH',
                                    style:
                                        TextStyle(color: Color(0xff26AEE4)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Mohamed Helmy',
                                      style: TextStyle(
                                          color: RevmoColors.darkBlue),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 30,
                                          child: Image.network(catalog
                                              .catalog
                                              .models[0]
                                              .brand
                                              .logoURL)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        catalog.catalog.models[0].fullName,
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue),
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                        catalog.catalog.models[0].type.name,
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle_rounded,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Aly hashmawy',
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: Image.network(catalog
                                              .catalog.models[0].imageUrl)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                        '500,000 EGP',
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 65, right: 10),
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
                                  '25/2/1997',
                                  style: TextStyle(
                                      color: RevmoColors.darkBlue,
                                      fontSize: 12),
                                )
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
                                      unratedColor:
                                          Colors.amber.withAlpha(50),
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ' |  3.0',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: RevmoColors.darkBlue),
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
                                      unratedColor:
                                          Colors.amber.withAlpha(50),
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ' |  3.0',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: RevmoColors.darkBlue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ]).setPageHorizontalPadding(context),
    );
  }
}
