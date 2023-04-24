import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/auth/congratz_newaccount_screen.dart';
import 'package:revmo/screens/auth/login_screen.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/screens/auth/splash_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/screens/settings/join_showroom_screen.dart';
import 'package:revmo/screens/settings/settings_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:get_it/get_it.dart';
import 'Configurations/Extensions/loading_service.dart';
import 'Configurations/Routes/routes.dart';
import 'fixes/http_overrides.dart';
import 'services/firebase_notification.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  getIt.registerLazySingleton<ServerHandler>(() => new ServerHandler());

  HttpOverrides.global = MyHttpOverrides();
  runApp(RevmoSellerApp());
  configLoading();
}

class RevmoSellerApp extends StatefulWidget {
  const RevmoSellerApp({Key? key}) : super(key: key);

  @override
  State<RevmoSellerApp> createState() => _RevmoSellerAppState();
}

class _RevmoSellerAppState extends State<RevmoSellerApp> {
  FirebaseCustomNotification pushNotification = FirebaseCustomNotification();

  @override
  void initState() {
    pushNotification.firebaseSub();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //     statusBarBrightness:
    //         Platform.isIOS ? Brightness.light : Brightness.dark,
    //   ),
    // );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ChangeNotifierProvider<AccountProvider>(
            create: (cntxt) => AccountProvider(),
            child: MaterialApp(
              title: 'Revmo Pro',
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                }),
                buttonTheme: ButtonThemeData(
                    disabledColor: RevmoColors.greyishBlue,
                    buttonColor: RevmoColors.originalBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
              onGenerateRoute:
              // Routes.generateRoute,

                  (settings) {
                switch (settings.name) {
                  case HomeScreen.ROUTE_NAME:
                    return PageTransition(
                        child: HomeScreen(), type: PageTransitionType.fade);
                  case LoginScreen.ROUTE_NAME:
                    return PageTransition(
                        child: LoginScreen(), type: PageTransitionType.fade);
                  case NewAccountCongratzScreen.ROUTE_NAME:
                    return PageTransition(
                        child: NewAccountCongratzScreen(),
                        type: PageTransitionType.topToBottom);
                  case PreLoginScreen.ROUTE_NAME:
                    return PageTransition(
                        child: PreLoginScreen(), type: PageTransitionType.fade);
                  case SettingsScreen.ROUTE_NAME:
                    return PageTransition(
                        child: SettingsScreen(),
                        type: PageTransitionType.rightToLeft);
                  case SignUp.SELLER_ROUTE_NAME:
                    return PageTransition(
                        child: SignUp.seller(), type: PageTransitionType.fade);
                  case SignUp.SHOWROOM_ROUTE_NAME:
                    return PageTransition(
                        child: SignUp.showroom(),
                        type: PageTransitionType.fade);
                  case JoinShowroomScreen.ROUTE_NAME:
                    return PageTransition(
                        child: JoinShowroomScreen(),
                        type: PageTransitionType.fade);
                }
              },
              builder: EasyLoading.init(
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child ?? const Scaffold(),
                ),
              ),
              home: SplashScreen(),
            )));
  }
}
