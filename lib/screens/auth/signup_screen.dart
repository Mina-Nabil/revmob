import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/revmo_breadcrumb.dart';
import 'package:revmo/shared/widgets/registration/sign_up_pages.dart';

import 'pre_login_screen.dart';

class SignUpSteps extends InheritedWidget {
  //forms pages controller
  final PageController formsController;
  //top bar animation
  final Animation<double> stepsAnimator;
  final AnimationController animationController;
  final Tween<double> barTween;

  //default duration
  final Duration animationDuration = Duration(milliseconds: 500);

  SignUpSteps(
      {required this.stepsAnimator,
      required this.formsController,
      required this.animationController,
      required this.barTween,
      required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant SignUpSteps oldWidget) {
    return oldWidget.stepsAnimator.value != stepsAnimator.value;
  }

  static SignUpSteps of(BuildContext context) {
    final SignUpSteps? result = context.dependOnInheritedWidgetOfExactType<SignUpSteps>();
    assert(result != null, 'No SignUpStep found in context');
    return result!;
  }
}

class SignUp extends StatefulWidget {
  const SignUp.showroom() : _isShowroom = true, _mobNotVerified = false;
  const SignUp.seller() : _isShowroom = false, _mobNotVerified = false;
  const SignUp.showRoomNotVerified() : _isShowroom = true,_mobNotVerified = true ;


  final bool _isShowroom;
  final bool _mobNotVerified;

  static const SELLER_ROUTE_NAME = "/signUp/seller";
  static const SHOWROOM_ROUTE_NAME = "/signUp/showroom";

  //dimensions
  final double _horizontalPadding = 25;
  final double _titleBottomMargin = 35;
  final double _breadCrumbHeight = 90;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  late final Tween<double> barTween;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      if(Provider.of<AccountProvider>(context, listen: false).user != null ){
        print("user retreived");
        await Provider.of<AccountProvider>(context, listen: false).refresshUser(context, forceReload: true);
      }
      await Provider.of<AccountProvider>(context, listen: false).loadUser(context, forceReload: true);
      if (Provider.of<AccountProvider>(context, listen: false).showroom != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.ROUTE_NAME, ModalRoute.withName('/'));
      }
    });
    barTween = new Tween<double>(begin: 0, end: 1);
    animationController = new AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = barTween.animate(animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(onTap: (){
        Navigator.of(context)
            .pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
      },child: Icon(Icons.arrow_back_ios),),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appbar,
        body: SignUpSteps(
            stepsAnimator: animation,
            barTween: barTween,
            animationController: animationController,
            formsController: new PageController(initialPage: 0),
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [RevmoColors.darkBlue, RevmoColors.darkestBlue])),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RevmoTheme.getFormTitle(AppLocalizations.of(context)!.signUp),
                    SizedBox(
                      height: widget._titleBottomMargin,
                    ),
                    RevmoBreadcrumb(
                      animation: animation,
                      stepsList: (widget._isShowroom)
                          ? {
                              0: AppLocalizations.of(context)!.signUpStep_ContactInformation,
                              1: AppLocalizations.of(context)!.signUpStep_AccountVerfication,
                              2: AppLocalizations.of(context)!.signUpStep_CompanyDetails,
                              3: AppLocalizations.of(context)!.signUpStep_AccountVerfication
                            }
                          : {
                              0: AppLocalizations.of(context)!.signUpStep_ContactInformation,
                              1: AppLocalizations.of(context)!.signUpStep_AccountVerfication
                            },
                      width: MediaQuery.of(context).size.width,
                      height: widget._breadCrumbHeight,
                    ),
                    Expanded(
                      child: SignUpPages(
                        widget._isShowroom,
                        horizontalPadding: widget._horizontalPadding,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
