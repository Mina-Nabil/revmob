import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/screens/auth/login_screen.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/screens/settings/join_showroom_screen.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/secondary_button.dart';

class PreLoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/prelogin";

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  final double _buttonsWidth = 300;
  final double _mainContainerWidthRatio = .7;
  final double _mainContainerHeightRatio = .6;
  bool loading = true;

  bool logOutEnabled = true;
  bool waitingForLogout = false;

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<AccountProvider>(context, listen: false).loadUser(context, forceReload: true);
      if(Provider.of<AccountProvider>(context, listen: false).showroom!=null){
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.ROUTE_NAME, ModalRoute.withName('/'));
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  logOut() async {
    setState(() {
      logOutEnabled = false;
      waitingForLogout = true;
    });
    if (await AuthService.logOut(context))
      Navigator.of(context).pushNamed(LoginScreen.ROUTE_NAME);
    else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.serverIssue)));
    setState(() {
      logOutEnabled = true;
      waitingForLogout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  Paths.splashImage,
                  fit: BoxFit.fitWidth,
                )),
            SafeArea(
                child: Container(
              height: MediaQuery.of(context).size.height * _mainContainerHeightRatio,
              width: MediaQuery.of(context).size.width * _mainContainerWidthRatio,
              alignment: Alignment.center,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child:
                          RevmoTheme.getBody(AppLocalizations.of(context)!.welcomeTo, 3, isBold: true, weight: FontWeight.w600),
                    ),
                    Container(
                      child: RevmoTheme.getEuroStileTitle("REVMO"),
                      // child: SvgPicture.asset(Paths.logoSVG),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child:  RevmoTheme.getCaption(AppLocalizations.of(context)!.slogan, 1),
                    ),
                  ],
                )),
                Container(
                  child: Consumer<AccountProvider>(
                    builder: (cnxt, sellerProvider, _) {
                      print("Loading: " + loading.toString());
                      print("isUser: " + (sellerProvider.user != null).toString());
                      print("hasShowroom: " + (sellerProvider.user != null && sellerProvider.user!.hasShowroom).toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 56.0),
                        child: Column(
                          mainAxisAlignment: (loading) ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: (loading)
                              ? [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ]
                              : (sellerProvider.user != null)
                                  ? [
                                      MainButton(
                                        callBack: logOut,
                                        text: AppLocalizations.of(context)!.logout.toUpperCase(),
                                        width: _buttonsWidth,
                                      ),
                                      SecondaryButton(
                                        callBack: () {
                                          Navigator.of(context).pushNamed(JoinShowroomScreen.ROUTE_NAME);
                                        },
                                        text: AppLocalizations.of(context)!.joinShowroom.toUpperCase(),
                                        width: _buttonsWidth,
                                      ),
                                      SecondaryButton(
                                        callBack: () {
                                          Navigator.of(context).pushNamed(SignUp.SHOWROOM_ROUTE_NAME);
                                        },
                                        text: AppLocalizations.of(context)!.signUpShowroom.toUpperCase(),
                                        width: _buttonsWidth,
                                      ),
                                    ]
                                  : [
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
                                    ],
                        ),
                      );
                    },
                  ),
                )
              ]),
            )),
          ]),
          if (waitingForLogout) RevmoTheme.getLoadingContainer(context)
        ],
      ),
    );
  }
}
