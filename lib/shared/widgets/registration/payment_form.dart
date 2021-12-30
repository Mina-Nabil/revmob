import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/services/seller_profile_service.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/secondary_button.dart';
import 'package:revmo/shared/widgets/misc/text_field.dart';

class PaymentForm extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;
  const PaymentForm({this.animationsDuration = const Duration(milliseconds: 500), this.defaultCurve = Curves.slowMiddle});
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool isWaitingForResponse = false;
  final Tween<double> barTween = new Tween<double>(begin: 1, end: 2);
  //form Controllers
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _bankNameController = new TextEditingController();
  TextEditingController _accountNameController = new TextEditingController();
  TextEditingController _ibanController = new TextEditingController();
  TextEditingController _accountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              child: ListView(
                children: [
                  RevmoTextField(
                    title: AppLocalizations.of(context)!.bank,
                    controller: _bankNameController,
                    hintText: AppLocalizations.of(context)!.bankHint,
                    validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(3).build(),
                  ),
                  RevmoTextField(
                    title: AppLocalizations.of(context)!.bankAccountName,
                    controller: _accountNameController,
                    hintText: AppLocalizations.of(context)!.bankAccountNameHint,
                    validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(3).build(),
                  ),
                  RevmoTextField(
                    title: AppLocalizations.of(context)!.iban,
                    controller: _ibanController,
                    hintText: AppLocalizations.of(context)!.ibanHint,
                    validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(3).build(),
                  ),
                  RevmoTextField(
                    title: AppLocalizations.of(context)!.bankAccountNumber,
                    controller: _accountController,
                    hintText: AppLocalizations.of(context)!.bankAccountNumberHint,
                    validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(3).build(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: MainButton(
                      callBack: (isWaitingForResponse) ? null : advanceForm,
                      text: AppLocalizations.of(context)!.next,
                      width: 320,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: SecondaryButton(
                      callBack: skipForm,
                      text: AppLocalizations.of(context)!.skip,
                      width: 320,
                    ),
                  ),
                ],
              ),
            ),
            if (isWaitingForResponse) RevmoTheme.getLoadingContainer(context),
          ],
        ));
  }

  advanceForm() async {
    disableForm();
    if (_formKey.currentState!.validate()) {
      ApiResponse<bool> isSetResponse = await SellerProfileService.setBankInfo(context,
          accountHolderName: _accountNameController.text,
          accountNumber: _accountController.text,
          accountbankName: _bankNameController.text,
          iban: _ibanController.text);
      if (isSetResponse.status) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(isSetResponse.msg)));
        moveBar();
        movePage();
      } else {
        enableForm();
      }
    } else
      enableForm();
  }

  skipForm() {
    moveBar();
    movePage();
  }

  moveBar() {
    SignUpSteps.of(context).animationController.reset();
    SignUpSteps.of(context).barTween.begin = 2;
    SignUpSteps.of(context).barTween.end = 3;
    SignUpSteps.of(context).animationController.forward();
  }

  movePage() {
    SignUpSteps.of(context).formsController.animateToPage(3, duration: widget.animationsDuration, curve: widget.defaultCurve);
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
}
