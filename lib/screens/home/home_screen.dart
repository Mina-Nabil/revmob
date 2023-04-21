import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/catalog/catalog_tab.dart';
import 'package:revmo/screens/home/customers_tab.dart';
import 'package:revmo/screens/home/dashboard_tab.dart';
import 'package:revmo/screens/home/notifications_tab.dart';
import 'package:revmo/screens/offers/requests_tab.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/home/single_nav_tab.dart';
import 'package:revmo/shared/widgets/home/tabs_nav.dart';
import 'package:revmo/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/Seller/brands_provider.dart';
import '../../providers/Seller/catalog_provider.dart';
import '../../providers/Seller/customers_provider.dart';
import '../../providers/Seller/models_provider.dart';
import '../../providers/Seller/offers_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/home";
  static const EdgeInsets HORIZONTAL_PADDING =
      const EdgeInsets.symmetric(horizontal: 15.0);

  // final double _navBarTopMargin = 2.0;
  // final double _navBarIconSize = 20.0;
  // final double _navBarHighlightCircleRadius = 5.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int _selectedIndex = 2;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //screen dimensions

  late String _currentPage = DashboardTab.screenName;
  final List<String> pageKeys = [
    CatalogTab.screenName,
    RequestsTab.screenName,
    DashboardTab.screenName,
    CustomersTab.screenName,
    NotificationsTab.screenName
  ];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    CatalogTab.screenName: new GlobalKey<NavigatorState>(),
    RequestsTab.screenName: new GlobalKey<NavigatorState>(),
    DashboardTab.screenName: new GlobalKey<NavigatorState>(),
    CustomersTab.screenName: new GlobalKey<NavigatorState>(),
    NotificationsTab.screenName: new GlobalKey<NavigatorState>(),
  };
  // late final PersistentTabController _controller;
  // late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _controller = PersistentTabController(initialIndex: 2);
    //
    // _tabController =
    //     TabController(length: pageKeys.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
              if (isFirstRouteInCurrentTab) {
                if (_currentPage != DashboardTab.screenName) {
                  _selectTab(2);
                  return false;
                }
              }
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider<BrandsProvider>(
                    create: (context) => new BrandsProvider(context)),
                ChangeNotifierProvider<ModelsProvider>(
                    create: (context) => new ModelsProvider(context)),
                ChangeNotifierProvider<CatalogProvider>(
                    create: (context) => new CatalogProvider(context)),
                ChangeNotifierProvider<OffersProvider>(
                    create: (context) => new OffersProvider(context)),
                ChangeNotifierProvider<CustomersProvider>(
                    create: (context) => new CustomersProvider(context)),
              ],
              child: Scaffold(
                  backgroundColor: RevmoColors.darkBlue,
                  body: SafeArea(
                      child: Container(
                          child: Stack(
                    children: [
                      OffStageTab((_selectedIndex == 0), CatalogTab.screenName,
                          _navigatorKeys[CatalogTab.screenName]),
                      OffStageTab((_selectedIndex == 1), RequestsTab.screenName,
                          _navigatorKeys[RequestsTab.screenName]),
                      OffStageTab(
                          (_selectedIndex == 2),
                          DashboardTab.screenName,
                          _navigatorKeys[DashboardTab.screenName]),
                      OffStageTab(
                          (_selectedIndex == 3),
                          CustomersTab.screenName,
                          _navigatorKeys[CustomersTab.screenName]),
                      OffStageTab(
                          (_selectedIndex == 4),
                          NotificationsTab.screenName,
                          _navigatorKeys[NotificationsTab.screenName]),
                    ],
                  ))),
                  appBar: RevmoAppBar(
                    addLogout: true,
                    showMenuIcon: true,
                    addSettings: true,
                  ),
                  bottomNavigationBar: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Transform(
                        transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                        child: PhysicalShape(
                          color: Color(0xff051224),
                          elevation: 16.0,
                          clipper: TabClipper(
                            radius: 40.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              color: const Color(0xff051224),
                              // height: MediaQuery.of(context).size.height * 0.07,
                              height: Platform.isIOS
                                  ? MediaQuery.of(context).size.height * 0.093
                                  : MediaQuery.of(context).size.height * 0.082,
                              // padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.topCenter,
                              child: Material(
                                color: Colors.transparent,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.white.withOpacity(0.1),
                                      highlightColor: Colors.grey.withOpacity(0.1),
                                      onTap: () {
                                        Platform.isAndroid
                                            ? debugPrint('')
                                            : HapticFeedback.lightImpact();
                                        SystemSound.play(
                                          SystemSoundType.click,
                                        );
                                        _selectTab(0);
                                      },
                                      child: SingleNavigationTabContainer(
                                          Paths.navCar,
                                          AppLocalizations.of(context)!.myCatalog,
                                          _selectedIndex == 0),
                                    ),
                                    InkWell(
                                      // padding: EdgeInsets.zero,
                                      // minWidth:
                                      //     MediaQuery.of(context).size.width * 0.2,
                                      onTap: () {
                                        Platform.isAndroid
                                            ? debugPrint('')
                                            : HapticFeedback.lightImpact();
                                        SystemSound.play(
                                          SystemSoundType.click,
                                        );
                                        _selectTab(1);
                                      },
                                      child: SingleNavigationTabContainer(
                                          Paths.navRequests,
                                          AppLocalizations.of(context)!.requests,
                                          _selectedIndex == 1),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                    ),
                                    InkWell(
                                      // padding: EdgeInsets.zero,
                                      // minWidth:
                                      //     MediaQuery.of(context).size.width * 0.2,
                                      onTap: () {
                                        Platform.isAndroid
                                            ? debugPrint('')
                                            : HapticFeedback.lightImpact();
                                        SystemSound.play(
                                          SystemSoundType.click,
                                        );
                                        _selectTab(3);
                                      },
                                      child: SingleNavigationTabContainer(
                                          Paths.navCustomers,
                                          AppLocalizations.of(context)!.customers,
                                          _selectedIndex == 3),
                                    ),
                                    InkWell(
                                      // padding: EdgeInsets.zero,
                                      // minWidth:
                                      //     MediaQuery.of(context).size.width * 0.2,
                                      onTap: () {
                                        Platform.isAndroid
                                            ? debugPrint('')
                                            : HapticFeedback.lightImpact();
                                        SystemSound.play(
                                          SystemSoundType.click,
                                        );
                                        _selectTab(4);
                                      },
                                      child: SingleNavigationTabContainer(
                                          Paths.navNotifications,
                                          AppLocalizations.of(context)!
                                              .notifications,
                                          _selectedIndex == 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -20,
                          child: SizedBox(
                            // width: 38 * 2.0,
                            height: Platform.isIOS
                                ? MediaQuery.of(context).size.height * 0.092
                                : MediaQuery.of(context).size.height * 0.082,
                            child: GestureDetector(
                                onTap: () {
                                  Platform.isAndroid
                                      ? debugPrint('')
                                      : HapticFeedback.lightImpact();
                                  SystemSound.play(
                                    SystemSoundType.click,
                                  );
                                  _selectTab(2);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _selectedIndex == 2
                                        ? Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.topCenter,

                                      children: [
                                            Container(
                                      padding:EdgeInsets.all(12),
                                      height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff051224),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      // blurRadius: 1
                                                    )
                                                  ]
                                                ),
                                              ),
                                            Positioned(
                                              right: 13,
                                              child: SvgPicture.asset(
                                                  "assets/icons/speedo.svg",
                                                  fit: BoxFit.cover,
                                                  height: 35,
                                                  color: RevmoColors
                                                      .navbarColorSelectedIcon),
                                            ),
                                          ],
                                        )
                                        : Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.topCenter,

                                      children: [
                                        Container(
                                          padding:EdgeInsets.all(12),
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  // blurRadius: 1
                                                )
                                              ],
                                            color: Color(0xff051224),
                                          ),
                                        ),
                                        Positioned(
                                          right: 13,
                                          child: SvgPicture.asset(
                                              "assets/icons/speedo.svg",
                                              fit: BoxFit.cover,
                                              height: 35,
                                              color: RevmoColors
                                                  .unSelectedTab),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: FittedBox(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .dashboard,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _selectedIndex == 2
                                                ? RevmoColors
                                                    .navbarColorSelectedIcon
                                                : RevmoColors.unSelectedTab,
                                          ),
                                        ),
                                      ),
                                    )

                                    // CircleAvatar(
                                    //         radius: 30,
                                    //         backgroundColor: Color(0xff051224),
                                    //         child: SvgPicture.asset(
                                    //             "assets/icons/speedo.svg",
                                    //             height: 30,
                                    //             color:
                                    //                 RevmoColors.unSelectedTab),
                                    //       ),

                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Container(
                                    //   child: FittedBox(
                                    //     child: Text(
                                    //       AppLocalizations.of(context)!
                                    //           .dashboard,
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: _selectedIndex == 2
                                    //             ? RevmoColors
                                    //                 .navbarColorSelectedIcon
                                    //             : RevmoColors.unSelectedTab,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                )),
                          )),
                    ],
                  )),
            )));
  }

  void _selectTab(int index) {
    String tabItem = pageKeys[index];
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }
}

class OffStageTab extends StatelessWidget {
  late final bool isOn;
  late final String tabItem;
  late final GlobalKey<NavigatorState>? navState;

  OffStageTab(this.isOn, this.tabItem, this.navState);

  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isOn,
      child: TabsNavigator(
        navigatorKey: navState ?? new GlobalKey<NavigatorState>(),
        tabItem: tabItem,
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2.5;
    path.lineTo(0, 0);
    // path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
    //     degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.03, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    // path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
    //     degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (pi / 180) * degree;
    return redian;
  }
}
