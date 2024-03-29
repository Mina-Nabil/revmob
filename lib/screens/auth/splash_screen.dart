import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/environment/paths.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/theme.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/splash";
  static const Duration fadeDuration = const Duration(milliseconds: 3000); //milliseconds

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _visible = true;
      });
    });
    Future.delayed(SplashScreen.fadeDuration).then((_) {
      checkLoggedIn();
    });
  }

  void checkLoggedIn() async {
    await (Provider.of<AccountProvider>(context, listen: false).loadUser(context, forceReload: true).onError((error, stackTrace) {
      RevmoTheme.showRevmoSnackbar(context, AppLocalizations.of(context)!.checkConnection + "!");
    }));
    Seller? seller = Provider.of<AccountProvider>(context, listen: false).user;
    if (seller != null && seller.hasShowroom) {
      FirebaseMessaging.instance.getToken().then((value) async {
        debugPrint("getToken FCM $value");
        await Provider.of<AccountProvider>(context, listen: false).setFcmToken(value!);
      });
      Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
    } else {
      Navigator.of(context).pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
    }
  }

  @override
  Widget build(BuildContext context) {
    double logoWidth = MediaQuery.of(context).size.width > 500 ? 200 : 150;

    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              Paths.splashImage,
              fit: BoxFit.fitWidth,
            )),
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: SplashScreen.fadeDuration,
          child: Container(
              alignment: Alignment.center,
              width: logoWidth,
              child: Image(image: AssetImage(Paths.splashLogo), width: logoWidth, fit: BoxFit.fitWidth)),
        ),
      ]),
    );
  }
}
