import 'package:flutter/material.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/registration/signin_form.dart';

class LoginScreen extends StatelessWidget {
  static const String ROUTE_NAME = "/login";
  // final double _bottomPadding = 28.0;

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: appbar,
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.bottomCenter,
                    image: AssetImage(
                      Paths.signInBG,
                    )),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [RevmoColors.darkBlue, RevmoColors.darkerBlue])),
            // constraints: BoxConstraints(maxWidth: RevmoTheme.FORMS_MAX_WIDTH),
            child: SignInForm()),
      ),
    );
  }
}
