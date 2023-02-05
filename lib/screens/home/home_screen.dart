import 'dart:io';

import 'package:flutter/material.dart';
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
  static const EdgeInsets HORIZONTAL_PADDING = const EdgeInsets.symmetric(horizontal: 15.0);

  // final double _navBarTopMargin = 2.0;
  // final double _navBarIconSize = 20.0;
  // final double _navBarHighlightCircleRadius = 5.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int _selectedIndex = 2;

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
  late final PersistentTabController _controller;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);

    _tabController = TabController(length: pageKeys.length, vsync: this, initialIndex: 0);
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
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
                ChangeNotifierProvider<BrandsProvider>(create: (context) => new BrandsProvider(context)),
                ChangeNotifierProvider<ModelsProvider>(create: (context) => new ModelsProvider(context)),
                ChangeNotifierProvider<CatalogProvider>(create: (context) => new CatalogProvider(context)),
                ChangeNotifierProvider<OffersProvider>(create: (context) => new OffersProvider(context)),
                ChangeNotifierProvider<CustomersProvider>(create: (context) => new CustomersProvider(context)),
              ],
              child: Scaffold(
                backgroundColor: RevmoColors.darkBlue,

                body: SafeArea(
                    child: Container(
                        child: Stack(
                          children: [
                            OffStageTab((_selectedIndex == 0),  CatalogTab.screenName, _navigatorKeys[CatalogTab.screenName]),
                            OffStageTab((_selectedIndex == 1), RequestsTab.screenName, _navigatorKeys[RequestsTab.screenName]),
                            OffStageTab((_selectedIndex == 2), DashboardTab.screenName, _navigatorKeys[DashboardTab.screenName]),
                            OffStageTab((_selectedIndex == 3), CustomersTab.screenName, _navigatorKeys[CustomersTab.screenName]),
                            OffStageTab((_selectedIndex == 4), NotificationsTab.screenName, _navigatorKeys[NotificationsTab.screenName]),
                          ],
                        ))),
                appBar: RevmoAppBar(
                  addLogout: true,
                  showMenuIcon: true,
                  addSettings: true,
                ),
                bottomNavigationBar: Container(
                  // height: MediaQuery.of(context).size.height * 0.07,
                  padding: Platform.isIOS ? EdgeInsets.only(bottom: 15) : EdgeInsets.zero,
                  decoration: BoxDecoration(
                      color: RevmoColors.navbarColorBG,
                      border: Border(top: BorderSide(width: 0.25, color: RevmoColors.navbarBorder))),
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    padding: EdgeInsets.only(bottom: 8),

                    enableFeedback: true,
                    controller: _tabController,
                    onTap: _selectTab,
                    tabs: [
                      SingleNavigationTabContainer(Paths.navCar, AppLocalizations.of(context)!.myCatalog, _selectedIndex == 0),
                      SingleNavigationTabContainer(Paths.navRequests, AppLocalizations.of(context)!.requests, _selectedIndex == 1),
                      SingleNavigationTabContainer(Paths.rimsSVG, AppLocalizations.of(context)!.dashboard, _selectedIndex == 2),
                      SingleNavigationTabContainer(Paths.navCustomers, AppLocalizations.of(context)!.customers, _selectedIndex == 3),
                      SingleNavigationTabContainer(Paths.navNotifications, AppLocalizations.of(context)!.notifications, _selectedIndex == 4),
                    ],
                  ),
                ),
              ),
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