import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/Seller/catalog_provider.dart';
import '../../shared/widgets/catalog/catalog_tile.dart';

import 'package:revmo/shared/widgets/UIwidgets/ui_widgets.dart';

class DashboardTab extends StatefulWidget {
  static const String screenName = "DashboardTab";

  const DashboardTab({Key? key}) : super(key: key);

  @override
  _DashboardTabState createState() => _DashboardTabState();
}


class _DashboardTabState extends State<DashboardTab> {
 @override


  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context, listen: false);
    final catalog = Provider.of<CatalogProvider>(context);
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: SingleChildScrollView(
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

              TitleHeader(
                title: AppLocalizations.of(context)!.topSales,
              ),
              TargetSalesBox(
                soldCarsCount: account.user?.carsSoldCount.toString(),
                achievedTarget: account.user?.salesTotal.toString(),
                sellersCount: '6',
              ),
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
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalog.filteredCatalog.length,
                  itemBuilder: (context, index) {
                    return FadeInLeft(
                      child: Container(
                          width: 336,
                          // margin: EdgeInsets.only(left: 10,right: 10),
                          child: CatalogTile(
                              catalog.filteredCatalog[index],
                              catalog.catalog.getCarColors(
                                  catalog.filteredCatalog[index]))),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 20,
                    );
                  },
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
                        imgUrl: catalog.catalog.models[index].imageUrl,
                        logoUrl: catalog.catalog.models[index].brand.logoURL,
                        name: catalog.catalog.models[index].fullName,
                        brand: catalog.catalog.models[index].type.name,
                        price: '500,000 ${AppLocalizations.of(context)!.egp}',
                        seller: 'Aly Mahmoud',
                        onTap: () {
                          print(catalog.catalog.models[index].fullName);
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
