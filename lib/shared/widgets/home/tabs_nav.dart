import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/screens/catalog/brand_models_screen.dart';
import 'package:revmo/screens/catalog/car_details_screen.dart';
import 'package:revmo/screens/catalog/catalog_tab.dart';
import 'package:revmo/screens/home/customers_tab.dart';
import 'package:revmo/screens/home/dashboard_tab.dart';
import 'package:revmo/screens/home/notifications_tab.dart';
import 'package:revmo/screens/offers/requests_tab.dart';

class TabsNavigator extends StatelessWidget {
  TabsNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (tabItem == CatalogTab.screenName)
      child = CatalogTab();
    else if (tabItem == RequestsTab.screenName)
      child = RequestsTab();
    else if (tabItem == DashboardTab.screenName)
      child = DashboardTab();
    else if (tabItem == CustomersTab.screenName)
      child = CustomersTab();
    else if (tabItem == NotificationsTab.screenName) child = NotificationsTab();

    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            case BrandModelsScreen.ROUTE_NAME:
              return PageTransition(
                  child: BrandModelsScreen(
                    brand: routeSettings.arguments as Brand,
                  ),
                  type: PageTransitionType.rightToLeft);
            case CarDetailsScreen.ROUTE_NAME:
              return PageTransition(
                  child: CarDetailsScreen(
                    routeSettings.arguments as CarDetailsScreenArguments,
                  ),
                  type: PageTransitionType.rightToLeft);

            default:
              return MaterialPageRoute(builder: (context) => child);
          }
        });
  }
}
