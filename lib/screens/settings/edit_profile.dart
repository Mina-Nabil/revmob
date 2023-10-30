import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/Seller/account_provider.dart';
import '../../shared/colors.dart';
import '../../shared/widgets/UIwidgets/image_uploader.dart';
import '../../shared/widgets/UIwidgets/small_custom_indicator.dart';
import '../../shared/widgets/UIwidgets/success_message.dart';
import '../../shared/widgets/misc/revmo_text_field.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  ValueNotifier<File?> _selectedImage = new ValueNotifier(null);

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _phoneNumber2 = TextEditingController();
  final TextEditingController _date = TextEditingController();
  GlobalKey<FormState> editProfileFormState = GlobalKey<FormState>();

  bool loading = false;

  @override
  void initState() {
    _phoneNumber.text =
        Provider.of<AccountProvider>(context, listen: false).user!.mob;

    _userName.text = Provider.of<AccountProvider>(context, listen: false)
        .user!
        .fullName
        .toTitleCase();
    _phoneNumber2.text = Provider.of<AccountProvider>(context, listen: false)
        .user!
        .mob2 ?? "";


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        AppLocalizations.of(context)!.serverIssue,
        style: TextStyle(color: Colors.white),
      ),
    );
    final sellerProvider = Provider.of<AccountProvider>(context);

    return GestureDetector(

      onTap: (){

      },
      child: Scaffold(
        backgroundColor: RevmoColors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
          ),
          title:  Text( AppLocalizations.of(context)!.editProfile,
              style: TextStyle(
                  color: RevmoColors.darkBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: RevmoColors.darkBlue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            const SizedBox(
              width: 10,
            ),
            loading == false
                ? IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: RevmoColors.darkBlue,
                    ),
                    onPressed: () {
                      if (editProfileFormState.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });

                        sellerProvider
                            .editProfile(_userName.text, _phoneNumber.text,
                                _phoneNumber2.text, _selectedImage.value)
                            .then((value) async {
                          setState(() {
                            loading = false;
                          });
                          if (value) {
                            // await (Provider.of<AccountProvider>(context,
                            //         listen: false)
                            //     .refreshUser(context, forceReload: true));

                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 2), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return SuccessMessage(
                                    message:
                                    AppLocalizations.of(context)!.profileHasBeenEditedSuccessfully,
                                  );
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        });
                      }
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    width: 55,
                    child: smallCustomIndicator(context, color: Colors.black)),
            const SizedBox(
              width: 10,
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
          key: editProfileFormState,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                     Expanded(
                        flex: 2,
                        child: Text( AppLocalizations.of(context)!.photo,
                            style: TextStyle(
                                color: RevmoColors.darkBlue, fontSize: 18))),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PhotoUploader(_selectedImage),
                        ],
                      ),
                    ),
                  ],
                ),
                EditTile(
                  child: RevmoTextField(
                    // fieldMargin: 7,
                    addTitle: false,
                    darkMode: false,
                    // editing: true,
                    title: "",
                    controller: _userName,
                    validator: ValidationBuilder()
                        .required()
                        .maxLength(18)
                        .minLength(10)
                        .build(),
                    hintText: "Enter your full name here",
                  ),
                  title: AppLocalizations.of(context)!.fullName,
                ),
                EditTile(
                  child: RevmoTextField(
                    // fieldMargin: 7,
                    darkMode: false,
                    addTitle: false,

                    // editing: true,
                    title: "",
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumber,
                    validator: ValidationBuilder()
                        .required("required")
                        .phone()
                        .minLength(11)
                        .maxLength(11)
                        .build(),
                    hintText: "Enter your phone number here",
                  ),
                  title: AppLocalizations.of(context)!.yourPhoneNumber,
                ),
                EditTile(
                  child: RevmoTextField(
                    addTitle: false,
                    // optional: true,
                    // fieldMargin: 7,
                    // darkMode: false,
                    // editing: true,
                    title: "",
                    controller: _phoneNumber2,
                    // validator:
                    //     ValidationBuilder().optional = true,
                    hintText: "Enter your secondary phone number",
                  ),
                  title: AppLocalizations.of(context)!.yourSecondPhoneNumber,
                ),
                // EditTile(
                //   child: InkWell(
                //     onTap: () {
                //       DatePicker.showDatePicker(
                //         context,
                //         showTitleActions: true,
                //         maxTime: DateTime(2006, 12, 30),
                //         onChanged: (date) {
                //           print('change $date');
                //         },
                //         onConfirm: (date) {
                //           setState(() {
                //             _date.text = date.dateFormatter();
                //           });
                //           print('confirm ${date.dateFormatter()}');
                //         },
                //         currentTime: DateTime(1990, 3, 5),
                //       );
                //     },
                //     child: IgnorePointer(
                //       ignoring: true,
                //       child: RevmoTextField(
                //         // optional: true,
                //         // editing: true,
                //         addTitle: false,
                //
                //         // fieldMargin: 7,
                //         darkMode: false,
                //         title: "'sign_up.yourBirthDateHere'.tr()",
                //         controller: _date,
                //         validator:
                //             ValidationBuilder().required("required").build(),
                //         hintText: " 'sign_up.yourBirthDateHere'.tr()",
                //       ),
                //     ),
                //   ),
                //   title: "'sign_up.yourBirthDateHere'.tr()",
                // ),
              ],
            ).setPageHorizontalPadding(context),
          ),
        ),
      ),
    );
  }
}

class EditTile extends StatelessWidget {
  const EditTile({Key? key, required this.title, required this.child})
      : super(key: key);
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(title,
                  style: const TextStyle(
                      color: RevmoColors.darkBlue, fontSize: 18))),
          Expanded(flex: 4, child: child),
        ],
      ),
    );
  }
}
