import 'package:flutter/material.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/registration/signin_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  static const String ROUTE_NAME = "login";
  final double _bottomPadding = 28.0;

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          constraints: BoxConstraints(maxWidth: RevmoTheme.FORMS_MAX_WIDTH),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [RevmoColors.darkBlue, RevmoColors.darkerBlue])),
              ),
              Container(
                  child: Image.asset(
                Paths.signInBG,
                fit: BoxFit.fitWidth,
              )),
              SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  resizeToAvoidBottomInset: true,
                  appBar: appbar,
                  body: Container(
                    child: SignInForm(),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
