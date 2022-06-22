import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../environment/paths.dart';
import '../../../shared/colors.dart';
import '../../providers/Buyer/home_provider.dart';
import '../../shared/widgets/misc/revmo_icon_only_button.dart';
import '../Dashboard/dashboard_tab_view.dart';



class HomeViewBuyer extends StatefulWidget {
  @override
  _HomeViewBuyerState createState() => _HomeViewBuyerState();
}

class _HomeViewBuyerState extends State<HomeViewBuyer> {

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: RevmoColors.navbarColorSelectedIcon,
        inactiveColorPrimary: Colors.grey,
        title: "Search",
        inactiveIcon: SvgPicture.asset(
          Paths.searchSVG,
          height: 30,
          color:  RevmoColors.unSelectedTab ,
        ),


        icon: SvgPicture.asset(
        Paths.searchSVG,
          height: 30,
          color: RevmoColors.navbarColorSelectedIcon ,
      ),
      ),
      PersistentBottomNavBarItem(
      activeColorPrimary: RevmoColors.navbarColorSelectedIcon,
        inactiveColorPrimary: Colors.grey,
        title: "Requests",
        inactiveIcon: SvgPicture.asset(
          Paths.navRequests,
          color:  RevmoColors.unSelectedTab ,
        ),
        icon: SvgPicture.asset(
          Paths.navRequests,
          color: RevmoColors.navbarColorSelectedIcon,
        ),
      ), PersistentBottomNavBarItem(
        activeColorPrimary: RevmoColors.darkBlue,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: RevmoColors.navbarColorSelectedIcon,
        inactiveColorSecondary: RevmoColors.unSelectedTab,
        title: "Dashboard",
        contentPadding: 0,
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SvgPicture.asset(
            Paths.dashboardSpeed,
            height: 30,
            color:  RevmoColors.unSelectedTab ,
          ),
        ),
        textStyle: TextStyle(color: Colors.white),
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SvgPicture.asset(
            Paths.dashboardSpeed,
            height: 30,
            color: RevmoColors.navbarColorSelectedIcon,
          ),
        ),
      ), PersistentBottomNavBarItem(
        activeColorPrimary: RevmoColors.navbarColorSelectedIcon,
        inactiveColorPrimary: Colors.grey,
        title: "Offers",
        inactiveIcon: Icon(Icons.local_offer_outlined,
          size: 17,

          color:  RevmoColors.unSelectedTab ,
        ),


        icon: Icon(Icons.local_offer_outlined,
size: 17,
          color: RevmoColors.navbarColorSelectedIcon ,
        ),
      ), PersistentBottomNavBarItem(
        activeColorPrimary: RevmoColors.navbarColorSelectedIcon,
        inactiveColorPrimary: Colors.grey,
        title: "Offers",
        inactiveIcon :Icon(Icons.notifications_none_rounded,
    size: 20,
          color:  RevmoColors.unSelectedTab ,
        ),

        icon: Icon(Icons.notifications_none_rounded,
          size: 20,
          color: RevmoColors.navbarColorSelectedIcon ,
        ),
      ),
    ];
  }

  List<Widget> buildScreens() {
    return [
      Center(child: Text('home'),),
      Center(child: Text('search'),),
      DashboardBuyerView(),
      Center(child: Text('offers'),),
      Center(child: Text('settings'),),
    ];
  }

  late final  PersistentTabController _controller;
@override
  void initState() {
  _controller = PersistentTabController(initialIndex: 0);

  super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(create: (context) => new HomeProvider(context)),

      ],
      builder: (context, provider) {
        final customerProvider = Provider.of<HomeProvider>(context);
        return Scaffold(
          appBar: customerProvider.appBar ? AppBar(
            backgroundColor: RevmoColors.darkBlue,
            elevation: 0.0,
            centerTitle: false,
            titleSpacing: 0,
            actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RevmoIconButton(
                    width: 50,
                    callback: () => showMenu(
                        context: context,
                        color: RevmoColors.darkGrey,
                        position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width, kToolbarHeight, 40.0, 0),
                        items: [
                          // if (widget._addSettings)
                            PopupMenuItem<String>(
                              child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  title: new FittedBox(child: Text(AppLocalizations.of(context)!.settings))),
                              onTap: () async {
                                await Future.delayed(Duration.zero);
                                // Navigator.of(context).pushNamed(SettingsScreen.ROUTE_NAME);
                              },
                            ),
                          // if (widget._addLogout)
                            PopupMenuItem<String>(
                              child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  title: new FittedBox(child: Text(AppLocalizations.of(context)!.logout))),
                              onTap: () async {
                                // await AuthService.logOut(context);
                                // Navigator.of(context).popAndPushNamed(PreLoginScreen.ROUTE_NAME);
                              },
                            ),
                        ]),
                    iconWidget: SvgPicture.asset(
                      Paths.menuSVG,
                      fit: BoxFit.fill,
                    ),
                    color: Colors.transparent,
                    iconPadding: 10,
                  ),
                ),
            ],
          ) : null,
          body: PersistentTabView(
            context,
            controller: _controller,
            screens: buildScreens(),
            items: _navBarsItems(),
            // hideNavigationBar: false,
            confineInSafeArea: true,
            backgroundColor: RevmoColors.darkBlue,
            // Default is Colors.white.
            handleAndroidBackButtonPress: true,
            // Default is true.
            resizeToAvoidBottomInset: true,
            // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true,
            // Default is true.
            hideNavigationBarWhenKeyboardShows: false,
            // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              // colorBehindNavBar: ,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                ),
              ],
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 100),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 100),
            ),
            navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
          ),
        );
      },
    );
  }
}
