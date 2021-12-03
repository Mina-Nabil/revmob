import 'package:flutter/material.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/main_button.dart';
import 'package:revmo/shared/widgets/text_field.dart';
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

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void submitForm() {
    _formState.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget._formPadding),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(alignment: Alignment.topLeft, child: RevmoTheme.getFormTitle(AppLocalizations.of(context)!.signIn)),
            SizedBox(
              height: widget._titlePadding,
            ),
            RevmoTextField(
                title: AppLocalizations.of(context)!.email,
                controller: _emailController,
                validator: ValidationBuilder().email(AppLocalizations.of(context)!.emailMsg).build(),
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
            MainButton(callBack: submitForm, width: widget._formButtonsWidth, text: AppLocalizations.of(context)!.continueText),
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
            RevmoTheme.getCaption(AppLocalizations.of(context)!.noAccountQ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.signUp),
              onPressed: () {
                Navigator.of(context).pushNamed(PreLoginScreen.ROUTE_NAME);
              },
            ),
          ],
        ),
      ),
    );
  }
}
