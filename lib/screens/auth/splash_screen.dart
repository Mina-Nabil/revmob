import 'package:flutter/material.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/services/AuthService.dart';
import 'package:revmo/environment/paths.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_NAME = "splash";
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

    //if (await AuthService.isLoggedIn().timeout(Duration(minutes: 2))) {
    if(false) {
      Navigator.of(context).pushNamed(HomeScreen.ROUTE_NAME);
    } else {
      Navigator.of(context).pushNamed(PreLoginScreen.ROUTE_NAME);
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
