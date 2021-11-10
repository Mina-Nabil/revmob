import 'package:flutter/material.dart';
import 'package:revmo/services/AuthService.dart';
import 'package:revmo/environment/paths.dart';

class SplashScreen extends StatefulWidget {
  static const Duration fadeDuration = const Duration(milliseconds: 1500); //milliseconds

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
    if (await AuthService.isLoggedIn()) {
      Navigator.of(context).pushNamed("home");
    } else {
      Navigator.of(context).pushNamed("login");
    }
  }

  @override
  Widget build(BuildContext context) {
    double logoWidth = MediaQuery.of(context).size.width > 500 ? 200 : 150;

    return Stack(alignment: AlignmentDirectional.center, children: [
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
    ]);
  }
}
