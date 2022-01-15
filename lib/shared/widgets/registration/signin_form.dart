import 'package:flutter/material.dart';
import 'package:revmo/models/seller.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/text_field.dart';
import 'package:form_validator/form_validator.dart';

class SignInForm extends StatefulWidget {
  final double _formPadding = 25;
  final double _formButtonsWidth = 326;
  final double _buttonPadding = 50;
  final double _titlePadding = 35;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();

  TextEditingController _identifierController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool isWaitingForResponse = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            padding: EdgeInsets.symmetric(horizontal: widget._formPadding),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(alignment: Alignment.topLeft, child: RevmoTheme.getFormTitle(AppLocalizations.of(context)!.signIn)),
                SizedBox(
                  height: widget._titlePadding,
                ),
                RevmoTextField(
                    title: AppLocalizations.of(context)!.email + " / " + AppLocalizations.of(context)!.mobNumber,
                    controller: _identifierController,
                    validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).build(),
                    hintText: AppLocalizations.of(context)!.emailHint),
                RevmoTextField(
                    title: AppLocalizations.of(context)!.password,
                    controller: _passwordController,
                    obscureText: true,
                    validator: ValidationBuilder().minLength(6, AppLocalizations.of(context)!.any6MinLength).build(),
                    hintText: AppLocalizations.of(context)!.passwordHint),
                SizedBox(
                  height: widget._buttonPadding,
                ),
                MainButton(
                    callBack: (isWaitingForResponse) ? null : submitForm,
                    width: widget._formButtonsWidth,
                    text: AppLocalizations.of(context)!.continueText),
                Container(
                  constraints: BoxConstraints(maxHeight: 100),
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.forgotPasswordMsg.toUpperCase(),
                    style: TextStyle(color: RevmoColors.white),
                  ),
                  onPressed: () {},
                ),
                RevmoTheme.getCaption(AppLocalizations.of(context)!.noAccountQ, 2),
                Center(
                    child: Wrap(alignment: WrapAlignment.center, children: [
                  TextButton(
                    child: FittedBox(child: Text(AppLocalizations.of(context)!.signUp)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(PreLoginScreen.ROUTE_NAME);
                    },
                  )
                ])),
              ],
            ),
          ),
          if (isWaitingForResponse) RevmoTheme.getLoadingContainer(context),
        ],
      ),
    );
  }

  submitForm() async {
    disableForm();
    if (_formState.currentState!.validate()) {
      var response = await AuthService.login(context, identifier: _identifierController.text, password: _passwordController.text);
      if (response.status == true && response.body is Seller) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(response.msg)));
        if (response.body!.hasShowroom)
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.ROUTE_NAME, ModalRoute.withName('/'),);
        else
          Navigator.of(context).pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
      } else {
        enableForm();
        print(response.msg);
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(response.msg)));
        if (response.errors != null && response.errors!.length > 0) {
          response.errors!.forEach((field, msg) {
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(msg.toString())));
          });
        }
      }
    } else {
      enableForm();
    }
  }

  enableForm() {
    setState(() {
      isWaitingForResponse = false;
    });
  }

  disableForm() {
    setState(() {
      isWaitingForResponse = true;
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
