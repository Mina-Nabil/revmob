import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../screens/auth/congratz_newaccount_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/pre_login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/settings/join_showroom_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/subscriptions_screen.dart';
import 'PageRouteName.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRouteName.initial:
        return MaterialPageRoute<dynamic>(
            builder: (_) => SplashScreen(), settings: settings);
      case PageRouteName.home:
        return PageTransition(
            child: HomeScreen(), type: PageTransitionType.fade);

      case PageRouteName.login:
        return PageTransition(
            child: LoginScreen(), type: PageTransitionType.fade);

      case PageRouteName.NewAccountCongratzScreen:
        return PageTransition(
            child: NewAccountCongratzScreen(),
            type: PageTransitionType.topToBottom);

      case PageRouteName.preLoginScreen:
        return PageTransition(
            child: PreLoginScreen(), type: PageTransitionType.fade);

      case PageRouteName.settingScreen:
        return PageTransition(
            child: SettingsScreen(), type: PageTransitionType.rightToLeft);

      // case PageRouteName.SignUpSeller:
      //   return PageTransition(
      //       child: SignUp.seller(), type: PageTransitionType.fade);
      // case PageRouteName.SignUpShowRoom:
      //   return PageTransition(
      //       child: SignUp.showroom(), type: PageTransitionType.fade);

      case PageRouteName.JoinShowroomScreen:
        return PageTransition(
            child: JoinShowroomScreen(), type: PageTransitionType.fade);

      case PageRouteName.subscriptions:
        return PageTransition(
          type: PageTransitionType.fade,
          child: JoinShowroomScreen(),
          // settings: settings,
        );

      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => SplashScreen(), settings: settings);
    }
  }
}
