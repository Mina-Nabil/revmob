import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/revmo_breadcrumb.dart';
import 'package:revmo/shared/widgets/registration/sign_up_pages.dart';

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
  const SignUp.showroom() : _isShowroom = true;
  const SignUp.seller() : _isShowroom = false;

  final bool _isShowroom;

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
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, maxWidth: RevmoTheme.FORMS_MAX_WIDTH),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget._horizontalPadding),
                      child: RevmoBreadcrumb(
                        animation: animation,
                        stepsList: (widget._isShowroom)
                            ? {
                                0: AppLocalizations.of(context)!.signUpStep_ContactInformation,
                                1: AppLocalizations.of(context)!.signUpStep_CompanyDetails,
                                2: AppLocalizations.of(context)!.signUpStep_PaymentDetails,
                                3: AppLocalizations.of(context)!.signUpStep_AccountVerfication
                              }
                            : {
                                0: AppLocalizations.of(context)!.signUpStep_ContactInformation,
                                1: AppLocalizations.of(context)!.signUpStep_AccountVerfication
                              },
                        width: MediaQuery.of(context).size.width,
                        height: widget._breadCrumbHeight,
                      ),
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
