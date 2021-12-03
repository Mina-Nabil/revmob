import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:revmo/screens/auth/login_screen.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/screens/auth/splash_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

void main() {
  runApp(RevmoSellerApp());
}

class RevmoSellerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: MaterialApp(
          title: 'Revmo Pro', 
          theme: ThemeData(
            buttonTheme: ButtonThemeData(
              disabledColor: RevmoColors.greyishBlue,
              buttonColor: RevmoColors.originalBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
             splashColor: Colors.white),
            brightness: Brightness.dark,
            
            fontFamily: RevmoTheme.FONT_GIBSON_LIGHT,
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('ar', ''), // Arabic, no country code
          ],
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case HomeScreen.ROUTE_NAME:
                return PageTransition(child: HomeScreen(), type: PageTransitionType.fade);
              case LoginScreen.ROUTE_NAME:
                return PageTransition(child: LoginScreen(), type: PageTransitionType.fade);
              case PreLoginScreen.ROUTE_NAME:
                return PageTransition(child: PreLoginScreen(), type: PageTransitionType.fade);
              case SignUp.SELLER_ROUTE_NAME:
                return PageTransition(child: SignUp.seller(), type: PageTransitionType.fade);
              case SignUp.SHOWROOM_ROUTE_NAME:
                return PageTransition(child: SignUp.showroom(), type: PageTransitionType.fade);
            }
          },
          home: SplashScreen(),
        ));
  }
}
