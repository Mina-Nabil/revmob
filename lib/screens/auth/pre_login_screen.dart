import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/auth/login_screen.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/main_button.dart';
import 'package:revmo/shared/widgets/secondary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreLoginScreen extends StatelessWidget {
  static const String ROUTE_NAME = "prelogin";
  final double _buttonsWidth = 300;
  final double _mainContainerWidthRatio = .7;
  final double _mainContainerHeightRatio = .6;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Paths.splashImage,
                fit: BoxFit.fitWidth,
              )),
          Container(
            height: MediaQuery.of(context).size.height * _mainContainerHeightRatio,
            width: MediaQuery.of(context).size.width * _mainContainerWidthRatio,
            alignment: Alignment.center,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: RevmoTheme.getbody1(AppLocalizations.of(context)!.welcomeTo, isBold: true),
                  ),
                  Container(
                  child: RevmoTheme.getEuroStileTitle("REVMO"),
                    // child: SvgPicture.asset(Paths.logoSVG),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: RevmoTheme.getCaption(AppLocalizations.of(context)!.slogan),
                  ),
                ],
              )),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainButton(
                      callBack: () {
                          Navigator.of(context).pushNamed(LoginScreen.ROUTE_NAME);
                      },
                      text: AppLocalizations.of(context)!.signIn.toUpperCase(),
                      width: _buttonsWidth,
                    ),
                    SecondaryButton(
                      callBack: () {
                          Navigator.of(context).pushNamed(SignUp.SELLER_ROUTE_NAME);
                      },
                      text: AppLocalizations.of(context)!.signUpSeller.toUpperCase(),
                      width: _buttonsWidth,
                    ),
                    SecondaryButton(
                      callBack: () {
                          Navigator.of(context).pushNamed(SignUp.SHOWROOM_ROUTE_NAME);
                      },
                      text: AppLocalizations.of(context)!.signUpShowroom.toUpperCase(),
                      width: _buttonsWidth,
                    ),
                    SizedBox(height: 56,)
                  ],
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
