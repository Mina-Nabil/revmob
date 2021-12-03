import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/showroom.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/services/SellerProfileService.dart';
import 'package:revmo/shared/widgets/display_photo_uploader.dart';
import 'package:revmo/shared/widgets/dropdown_list.dart';
import 'package:revmo/shared/widgets/main_button.dart';
import 'package:revmo/shared/widgets/secondary_button.dart';
import 'package:revmo/shared/widgets/text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompanyForm extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;
  const CompanyForm({this.animationsDuration = const Duration(milliseconds: 500), this.defaultCurve = Curves.slowMiddle});

  @override
  _CompanyFormState createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  //form Controllers
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _companyNameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileNumberController = new TextEditingController();
  ValueNotifier<File?> _selectedImage = new ValueNotifier(null);
  ValueNotifier<int?> _selectedCity = new ValueNotifier(null);

  final Tween<double> barTween = new Tween<double>(begin: 2, end: 3);

  bool isWaitingForResponse = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: ListView(shrinkWrap: true, children: [
          DisplayPhotoUploader(_selectedImage),
          RevmoTextField(
            title: AppLocalizations.of(context)!.companyName,
            controller: _companyNameController,
            hintText: AppLocalizations.of(context)!.companyNameHint,
            validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(3).build(),
          ),
          RevmoTextField(
            title: AppLocalizations.of(context)!.address,
            controller: _addressController,
            hintText: AppLocalizations.of(context)!.addressHint,
            validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).minLength(6, AppLocalizations.of(context)!.any6MinLength).build(),
            maxLines: 4,
          ),
          RevmoDropDownList(
            items: {1: "Alex", 2: "Cairo"},
            title: AppLocalizations.of(context)!.city,
            hint: AppLocalizations.of(context)!.cityHint,
            selected: _selectedCity,
          ),
          RevmoTextField(
            title: AppLocalizations.of(context)!.email,
            controller: _emailController,
            hintText: AppLocalizations.of(context)!.emailHint,
            validator: ValidationBuilder().required(AppLocalizations.of(context)!.fieldReqMsg).email(AppLocalizations.of(context)!.emailMsg).build(),
          ),
          RevmoTextField(
            title: AppLocalizations.of(context)!.mobNumber,
            controller: _mobileNumberController,
            hintText: AppLocalizations.of(context)!.mobNumberHint,
            prefixText: "+2-",
            validator: ValidationBuilder()
            .required(AppLocalizations.of(context)!.fieldReqMsg)
                .minLength(11, AppLocalizations.of(context)!.any11MinLength)
                .phone(AppLocalizations.of(context)!.mobInvalidMsg)
                .build(),
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
        ]),
      ),
    );
  }

  advanceForm() async {
    disableForm();
    print(_selectedCity.value);
    if (_formKey.currentState!.validate()) {
      ApiResponse<Showroom?> newShowroom = await SellerProfileService.createShowroom(context,
          name: _companyNameController.text,
          address: _addressController.text,
          cityID: _selectedCity.value!,
          email: _emailController.text,
          mobNumber: _mobileNumberController.text,
          image: _selectedImage.value);
      moveBar();
      movePage();
    } else
      enableForm();
  }

  skipForm() {
    moveBar();
    movePage();
  }

  moveBar() {
    SignUpSteps.of(context).animationController.reset();
    SignUpSteps.of(context).barTween.begin = 1;
    SignUpSteps.of(context).barTween.end = 2;
    SignUpSteps.of(context).animationController.forward();
  }

  movePage() {
    SignUpSteps.of(context)
        .formsController
        .animateTo(600, duration: SignUpSteps.of(context).animationDuration, curve: widget.defaultCurve);
  }

  disableForm() {
    setState(() {
      isWaitingForResponse = true;
    });
  }

  enableForm() {
    setState(() {
      isWaitingForResponse = false;
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _selectedCity.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _selectedImage.dispose();
    super.dispose();
  }
}
