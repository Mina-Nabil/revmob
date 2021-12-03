import 'package:flutter/material.dart';
import 'package:revmo/screens/home/catalog_tab.dart';
import 'package:revmo/screens/home/customers_tab.dart';
import 'package:revmo/screens/home/dashboard_tab.dart';
import 'package:revmo/screens/home/notifications_tab.dart';
import 'package:revmo/screens/home/requests_tab.dart';

import 'package:flutter_svg/svg.dart';
import 'package:revmo/screens/home/single_nav_tab.dart';
import 'package:revmo/screens/home/tabs_nav.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/environment/paths.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = "home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int _selectedIndex = 2;

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin  {
  //screen dimensions
  static const double navBarTopMargin = 2.0;
  static const double navBarIconSize = 20.0;
  static const double navBarHighlightCircleRadius = 5.0;

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

  late final TabController _tabController;
 @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pageKeys.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: GestureDetector(
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
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      OffStageTab((_selectedIndex == 0), CatalogTab.screenName, _navigatorKeys[CatalogTab.screenName]),
                      OffStageTab((_selectedIndex == 1), RequestsTab.screenName, _navigatorKeys[RequestsTab.screenName]),
                      OffStageTab((_selectedIndex == 2), DashboardTab.screenName, _navigatorKeys[DashboardTab.screenName]),
                      OffStageTab((_selectedIndex == 3), CustomersTab.screenName, _navigatorKeys[CustomersTab.screenName]),
                      OffStageTab((_selectedIndex == 4), NotificationsTab.screenName, _navigatorKeys[NotificationsTab.screenName]),
                    ],
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                        color: RevmoColors.navbarColorBG,
                        border: Border(top: BorderSide(width: 0.25, color: RevmoColors.navbarBorder))),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      controller: _tabController,
                      onTap: _selectTab,
                      tabs: [
                        SingleNavigationTabContainer("aa", AppLocalizations.of(context)!.myCatalog, _selectedIndex == 0),
                        SingleNavigationTabContainer("aa", AppLocalizations.of(context)!.requests, _selectedIndex == 1),
                        SingleNavigationTabContainer("aa", AppLocalizations.of(context)!.dashboard, _selectedIndex == 2),
                        SingleNavigationTabContainer("aa", AppLocalizations.of(context)!.customers, _selectedIndex == 3),
                        SingleNavigationTabContainer("aa", AppLocalizations.of(context)!.notifications, _selectedIndex == 4),
                      ],
                    ),
                  ),
                ))));
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
        navigatorKey: navState ?? GlobalKey<NavigatorState>(),
        tabItem: tabItem,
      ),
    );
  }
}
