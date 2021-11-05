import 'package:flutter/material.dart';
import 'package:revmo/screens/home/catalog_tab.dart';
import 'package:revmo/screens/home/customers_tab.dart';
import 'package:revmo/screens/home/dashboard_tab.dart';
import 'package:revmo/screens/home/notifications_tab.dart';
import 'package:revmo/screens/home/requests_tab.dart';


class TabsNavigator extends StatelessWidget {
  TabsNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (tabItem == CatalogTab.screenName)
      child = SafeArea(child: CatalogTab());
    else if (tabItem == RequestsTab.screenName)
      child = SafeArea(child: RequestsTab());
    else if (tabItem == DashboardTab.screenName)
      child = SafeArea(child: DashboardTab());
    else if (tabItem == CustomersTab.screenName)
      child = SafeArea(child: CustomersTab());
    else if (tabItem == NotificationsTab.screenName) child = SafeArea(child: NotificationsTab());

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
