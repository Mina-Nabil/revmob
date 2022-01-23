import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/display_photo_uploader.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/text_field.dart';
import 'package:revmo/shared/custom_validators.dart';
import 'dart:io';

class PersonalForm extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;
  const PersonalForm({this.animationsDuration = const Duration(milliseconds: 500), this.defaultCurve = Curves.slowMiddle});

  @override
  _PersonalFormState createState() => _PersonalFormState();
}

class _PersonalFormState extends State<PersonalForm> {
  //form Controllers
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileNumberController = new TextEditingController(text: "01");
  ValueNotifier<File?> _selectedImage = new ValueNotifier(null);

  GlobalKey<FormFieldState> _confirmPwKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _emailFieldKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _mobileNumberKey = new GlobalKey<FormFieldState>();

  bool isWaitingForResponse = false;
  bool isEmailTaken = false;
  bool isPhoneTaken = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isWaitingForResponse = true;
      });
      await loadSeller();
      if (Provider.of<AccountProvider>(context, listen: false).user != null &&
          Provider.of<AccountProvider>(context, listen: false).user is Seller) {
        moveBar();
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(AppLocalizations.of(context)!.alreadySignedIn)));
        movePage();
      }
      setState(() {
        isWaitingForResponse = false;
      });
    });

    super.initState();
  }

  Future loadSeller() async {
    await Provider.of<AccountProvider>(context, listen: false).loadUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: ListView(shrinkWrap: true, children: [
              DisplayPhotoUploader(_selectedImage),
              RevmoTextField(
                title: AppLocalizations.of(context)!.fullName,
                controller: _fullNameController,
                keyboardType: TextInputType.name,
                hintText: AppLocalizations.of(context)!.fullNameHint,
                validator: ValidationBuilder().fullName(context).build(),
              ),
              RevmoTextField(
                title: AppLocalizations.of(context)!.password,
                controller: _passwordController,
                onChangeValidation: (_) {
                  _confirmPwKey.currentState?.validate();
                },
                obscureText: true,
                hintText: AppLocalizations.of(context)!.passwordHint,
                validator: ValidationBuilder()
                    .required(AppLocalizations.of(context)!.fieldReqMsg)
                    .minLength(6, AppLocalizations.of(context)!.any6MinLength)
                    .build(),
              ),
              RevmoTextField(
                fieldKey: _confirmPwKey,
                title: AppLocalizations.of(context)!.confirmPassword,
                controller: _confirmPasswordController,
                obscureText: true,
                validateOnChange: true,
                hintText: AppLocalizations.of(context)!.passwordHint,
                validator: (input) {
                  if (input != _passwordController.text) return AppLocalizations.of(context)!.confirmPasswordMsg;
                },
              ),
              RevmoTextField(
                fieldKey: _emailFieldKey,
                title: AppLocalizations.of(context)!.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: AppLocalizations.of(context)!.emailHint,
                validator: ValidationBuilder()
                    .required(AppLocalizations.of(context)!.fieldReqMsg)
                    .email(AppLocalizations.of(context)!.emailMsg)
                    .add((value) {
                  if (isEmailTaken) return AppLocalizations.of(context)!.emailTaken;
                }).build(),
                onEditingComplete: checkEmail,
              ),
              RevmoTextField(
                fieldKey: _mobileNumberKey,
                title: AppLocalizations.of(context)!.mobNumber,
                controller: _mobileNumberController,
                hintText: AppLocalizations.of(context)!.mobNumberHint,
                keyboardType: TextInputType.phone,
                prefixText: "+2-",
                validator: ValidationBuilder()
                    .required(AppLocalizations.of(context)!.fieldReqMsg)
                    .minLength(11, AppLocalizations.of(context)!.any11MinLength)
                    .phone(AppLocalizations.of(context)!.mobInvalidMsg)
                    .add((value) {
                  if (isPhoneTaken) return AppLocalizations.of(context)!.phoneTaken;
                }).build(),
                onEditingComplete: checkPhone,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: MainButton(
                  callBack: isWaitingForResponse ? null : advanceForm,
                  text: AppLocalizations.of(context)!.next,
                  width: 320,
                ),
              ),
            ]),
          ),
          if (isWaitingForResponse) RevmoTheme.getLoadingContainer(context),
        ],
      ),
    );
  }

  checkEmail() async {
    var response = await AuthService.isEmailTaken(context, _emailController.text);
    try {
      if (response.body != null && response.body != isEmailTaken) {
        setState(() {
          isEmailTaken = response.body!;
        });
        _emailFieldKey.currentState!.validate();
      }
    } catch (e) {
      print(e);
    }
  }

  checkPhone() async {
    var response = await AuthService.isPhoneTaken(context, _mobileNumberController.text);
    if (response.body != null && response.body != isPhoneTaken) {
      setState(() {
        isPhoneTaken = response.body!;
      });
      _mobileNumberKey.currentState!.validate();
    }
  }

  moveBar() {
    SignUpSteps.of(context).animationController.reset();
    SignUpSteps.of(context).barTween.begin = 0;
    SignUpSteps.of(context).barTween.end = 1;
    SignUpSteps.of(context).animationController.forward();
  }

  movePage() {
    SignUpSteps.of(context).formsController.animateToPage(1, duration: widget.animationsDuration, curve: widget.defaultCurve);
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

  advanceForm() async {
    disableForm();
    await checkEmail();
    await checkPhone();
    print(_mobileNumberController.text);
    if (_formKey.currentState!.validate()) {
      ApiResponse<Seller?> response = await AuthService.registerSeller(context,
          email: _emailController.text,
          name: _fullNameController.text,
          mobNumber: _mobileNumberController.text,
          password: _passwordController.text);
      if (response.status == true && response.body != null) {
        moveBar();
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(response.msg)));
        movePage();
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
    } else
      enableForm();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _selectedImage.dispose();
    super.dispose();
  }
}
