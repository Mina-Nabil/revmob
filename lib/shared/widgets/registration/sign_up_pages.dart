import 'package:flutter/material.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/shared/widgets/registration/company_form.dart';
import 'package:revmo/shared/widgets/registration/payment_form.dart';
import 'package:revmo/shared/widgets/registration/personal_form.dart';
import 'package:revmo/shared/widgets/registration/verfiation_form.dart';

class SignUpPages extends StatefulWidget {
  final double horizontalPadding;
  final bool _isShowroom;

  const SignUpPages(this._isShowroom, {this.horizontalPadding = 10});

  @override
  _SignUpPagesState createState() => _SignUpPagesState();
}

class _SignUpPagesState extends State<SignUpPages> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: SignUpSteps.of(context).formsController,
      physics: NeverScrollableScrollPhysics(),
      children: !widget._isShowroom
          ? [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: PersonalForm(
                    defaultCurve: Curves.easeIn,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: VerficationForm(defaultCurve: Curves.easeIn)),
            ]
          : [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: PersonalForm(
                    defaultCurve: Curves.easeIn,
                    isShowroom: widget._isShowroom,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: VerficationForm(defaultCurve: Curves.easeIn, showRoom: widget._isShowroom,)),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: CompanyForm(defaultCurve: Curves.easeIn)),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding),
                  child: VerficationFormCompany(defaultCurve: Curves.easeIn)),
            ],
    );
  }
}
