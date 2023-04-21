import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:revmo/Configurations/Routes/PageRouteName.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/UIwidgets/skeleton_loading.dart';

import '../../environment/paths.dart';
import '../../providers/Seller/catalog_provider.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/catalog/catalog_tile.dart';

import 'package:revmo/shared/widgets/UIwidgets/ui_widgets.dart';

import '../../shared/widgets/misc/date_row.dart';
import '../settings/settings_screen.dart';
import '../settings/subscriptions_screen.dart';

class DashboardTab extends StatefulWidget {
  static const String screenName = "DashboardTab";

  const DashboardTab({Key? key}) : super(key: key);

  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context, listen: false);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: RefreshIndicator(
          onRefresh: () async {
            await account.loadCurrentPlan();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeContainer(name: account.user?.fullName ?? ''),
                const SizedBox(
                  height: 15,
                ),

                //TODO waiting for apis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 3,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          unratedColor: Colors.amber.withAlpha(50),
                          direction: Axis.horizontal,
                        ),
                        Text(
                          ' |  3.0',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timelapse_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Very Responsive')
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                // TitleHeader(
                //   title: AppLocalizations.of(context)!.topSales,
                // ),
                account.currentPlan == null
                    ? SizedBox.shrink()
                    : Consumer<AccountProvider>(
                        builder: (context, providerAcc, __) {
                          return InkWell(
                            onTap: (){
                              // Navigator.of(context)
                              //     .pushNamed(PageRouteName.subscriptions);
                              // Navigator.of(context)
                              //     .pushNamed(SettingsScreen.ROUTE_NAME);
                              Navigator.of(context).push(PageTransition(child: SubscriptionScreen(), type: PageTransitionType.rightToLeft));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: mediaQuery.size.width,
                              // height: 250,
                              decoration: BoxDecoration(
                                  color: Color(0xff08243d),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TitleHeader(
                                    title:
                                        "Current Subscription Plan\n (${providerAcc.plans!.name})",
                                    alignCenter: true,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SubscriptionPlan(
                                        selected: false,
                                        title: "Offers Limit",
                                        icon: Icon(
                                          Iconsax.money_time5,
                                          color: RevmoColors.white,
                                        ),
                                        info:
                                            "${providerAcc.currentPlan!.offers.toString()}/${providerAcc.plans!.offersLimit.toString()}",
                                      ),
                                      SubscriptionPlan(
                                        selected: false,
                                        title: "Users Limit",
                                        icon: Icon(
                                          Iconsax.people5,
                                          color: RevmoColors.white,
                                        ),
                                        info:
                                            "${providerAcc.currentPlan!.users.toString()}/${providerAcc.plans!.usersLimit.toString()}",
                                      ),
                                      SubscriptionPlan(
                                        selected: false,
                                        title: "Models Limit",
                                        icon: Icon(
                                          Iconsax.car5,
                                          color: RevmoColors.white,
                                        ),
                                        info:
                                            "${providerAcc.currentPlan!.models.toString()}/${providerAcc.plans!.modelsLimit.toString()}",
                                      ),
                                    ],
                                  ),

                                  // SizedBox(
                                  //   height: 200,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     Column(
                                  //       children: [
                                  //         Text('Total sold cars'),
                                  //         // Text(account.user?.carsSoldCount.toString() ?? '0'),
                                  //         Text('0'),
                                  //       ],
                                  //     ),
                                  //     Column(
                                  //       children: [
                                  //         Text('Achieved target'),
                                  //         Text('${'0'}  %'),
                                  //         // Text('${account.user?.salesTotal.toString()} %'),
                                  //       ],
                                  //     ),
                                  //     Column(
                                  //       children: [
                                  //         Text('No. of sellers'),
                                  //         Text(''),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                // TargetSalesBox(
                //              soldCarsCount: account.user?.carsSoldCount.toString(),
                //              achievedTarget: account.user?.salesTotal.toString(),
                //              sellersCount: '6',
                //            ),
                TitleHeader(
                  title: AppLocalizations.of(context)!.recentlyAdded,
                ),
                RecentlyAdded(
                  name: 'Mitsubishi Outlander, 2021',
                  price: '540,000 ${AppLocalizations.of(context)!.egCurrency}',
                  imgUrl:
                      'https://pngimg.com/uploads/mitsubishi/mitsubishi_PNG185.png',
                ),
                TitleHeader(
                  title: AppLocalizations.of(context)!.topSales,
                ),

                //TODO
                FadeInLeft(
                  child: SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: mediaQuery.size.width * 0.7,
                          padding: EdgeInsets.all(10
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    'https://pngimg.com/uploads/bmw/small/bmw_PNG1693.png',
                                    scale: 1.5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network("https://pngimg.com/uploads/car_logo/small/car_logo_PNG1641.png", scale :7),
                                      SizedBox(height: 10,),

                                      FittedBox(
                                        child: RevmoTheme.getSemiBold("BMW X6", 1, color: RevmoColors.darkBlue),
                                      ),
                                      FittedBox(
                                        child: RevmoTheme.getCaption("4X4", 1,
                                            color: RevmoColors.darkBlue, isBold: true, weight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10,),

                                      FittedBox(
                                        child: RevmoTheme.getCaption(AppLocalizations.of(context)!.price, 1,
                                            color: RevmoColors.darkBlue, isBold: true, weight: FontWeight.w600),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: FittedBox(
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "5,000,000",
                                                    style: RevmoTheme.getSemiBoldStyle(2, color: RevmoColors.darkBlue),
                                                    children: [
                                                      TextSpan(
                                                          text: " " + AppLocalizations.of(context)!.egCurrency,
                                                          style: RevmoTheme.getSemiBoldStyle(1, color: RevmoColors.darkBlue))
                                                    ]),
                                              ))),


                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 10, right: 2, bottom: 2),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        Paths.calendarSVG,
                                        color: RevmoColors.darkBlue,
                                        height: 13,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      RevmoTheme.getCaption(
                                          "10/10/2022",
                                          1,
                                          color: RevmoColors.lightPetrol),

                                    ],
                                  )
                              ),
                            ],
                          ),
                        );

                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 20,
                        );
                      },
                    ),
                  ),
                ),

                TitleHeader(
                  title: AppLocalizations.of(context)!.recent,
                ),
                SizedBox(
                  height: 330,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return FadeInRight(
                        child: RecentCarsContainer(
                          imgUrl:
                              "https://pngimg.com/uploads/mitsubishi/mitsubishi_PNG185.png",
                          logoUrl:
                              "https://img.icons8.com/color/344/mitsubishi.png",
                          name: "Mitsubishi Outlander, 2022",
                          brand: "4 x 4",
                          price: '500,000 ${AppLocalizations.of(context)!.egp}',
                          seller: 'Aly Mahmoud',
                          onTap: () {
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 20,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ).setPageHorizontalPadding(context),
          ),
        ));
  }
}

class RecentCarsContainer extends StatelessWidget {
  const RecentCarsContainer({
    Key? key,
    this.name,
    this.brand,
    this.price,
    this.seller,
    this.imgUrl,
    this.logoUrl,
    this.onTap,
  }) : super(key: key);
  final String? name;
  final String? brand;
  final String? price;
  final String? seller;
  final String? imgUrl;
  final String? logoUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      // height: 241,
      width: 180,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imgUrl != null
              ? SizedBox(height: 100, child: Image.network(imgUrl!))
              : SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No Image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          logoUrl != null
              ? SizedBox(
                  height: 30,
                  child: Image.network(
                    logoUrl!,
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 5,
          ),
          Text(
            name ?? '',
            // 'BMW X1 2021',
            style: TextStyle(color: Color(0xff003157)),
          ),
          Text(
            brand ?? '',
            // 'A/T / X-Line',
            style: TextStyle(color: Color(0xff003157)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            price ?? '',
            // catalog.filteredCatalog[index].formattedPrice
            //     .toString(),
            style: TextStyle(
                color: Color(0xff003157),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Icon(Icons.account_circle_rounded, color: Color(0xff003157)),
          Text(
            seller ?? '',
            // 'Aly Mahmoud',
            style: TextStyle(color: Color(0xff003157)),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xff003157))),
            child: InkWell(
              onTap: onTap,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.details,
                style: TextStyle(color: Color(0xff003157)),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlyAdded extends StatelessWidget {
  const RecentlyAdded({
    Key? key,
    this.name,
    this.price,
    this.imgUrl,
  }) : super(key: key);
  final String? name;
  final String? price;
  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 140,
      width: 336,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: Image.network(
                      'https://img.icons8.com/color/344/mitsubishi.png')),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 100,
                child: Text(
                  name ?? '',
                  style: TextStyle(color: Color(0xff003157), fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.startingPrice,
                style: TextStyle(color: Color(0xff003157), fontSize: 15),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                price ?? '',
                style: TextStyle(
                    color: Color(0xff003157),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          AppLocalizations.of(context)!.localeName == 'ar'
              ? Positioned(
                  left: -80,
                  top: -70,
                  child: SizedBox(
                    height: 210,
                    child: Image.network(imgUrl!),
                  ),
                )
              : Positioned(
                  right: -80,
                  top: -70,
                  child: SizedBox(
                    height: 210,
                    child: Image.network(imgUrl!),
                  ),
                )
        ],
      ),
    );
  }
}

class TargetSalesBox extends StatelessWidget {
  TargetSalesBox({
    Key? key,
    this.soldCarsCount,
    this.achievedTarget,
    this.sellersCount,
  }) : super(key: key);

  final String? soldCarsCount;
  final String? achievedTarget;
  final String? sellersCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(2),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
          color: Color(0xff08243d), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Total sold cars'),
                  // Text(account.user?.carsSoldCount.toString() ?? '0'),
                  Text(soldCarsCount ?? '0'),
                ],
              ),
              Column(
                children: [
                  Text('Achieved target'),
                  Text('${achievedTarget ?? '0'}  %'),
                  // Text('${account.user?.salesTotal.toString()} %'),
                ],
              ),
              Column(
                children: [
                  Text('No. of sellers'),
                  Text(sellersCount ?? ''),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text.rich(TextSpan(
          text: '${AppLocalizations.of(context)!.hello}, ',
          style: TextStyle(fontSize: 18),
          children: <InlineSpan>[
            TextSpan(
              text: name + ' !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ])),
    );
  }
}

class SubscriptionPlan extends StatelessWidget {
  const SubscriptionPlan(
      {Key? key,
      required this.selected,
      required this.title,
      required this.info,
      this.widget,
      this.icon})
      : super(key: key);

  final bool selected;
  final String title;
  final String info;
  final Widget? widget;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (icon != null) icon!,
              if (icon != null)
                SizedBox(
                  width: 4,
                ),
              Text(
                title,
                style: TextStyle(
                    color: selected ? RevmoColors.darkBlue : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          widget != null
              ? widget!
              : info == "-1"
                  ? Icon(
                      Iconsax.unlimited,
                      color: RevmoColors.darkBlue,
                    )
                  : Text(
                      info,
                      // "${subscriptions![index]
                      //      .annualPrice!
                      //      .toString()} EGP",
                      style: TextStyle(
                          color: selected ? RevmoColors.darkBlue : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
        ],
      ),
    );
  }
}
