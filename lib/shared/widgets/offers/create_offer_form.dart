import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/revmo_image.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/providers/offers_provider.dart';
import 'package:revmo/shared/custom_validators.dart';
import 'package:revmo/providers/catalog_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/brand_logo.dart';
import 'package:revmo/shared/widgets/misc/date_row.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/page_break.dart';
import 'package:revmo/shared/widgets/misc/revmo_checkbox_row.dart';
import 'package:revmo/shared/widgets/misc/revmo_date_field.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/revmo_multi_select.dart';
import 'package:revmo/shared/widgets/misc/revmo_text_field.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';

class NewOfferForm extends StatefulWidget {
  final OfferRequest request;
  const NewOfferForm(this.request);

  @override
  _NewOfferFormState createState() => _NewOfferFormState();
}

class _NewOfferFormState extends State<NewOfferForm> {
  final double userImageDiameter = 30;

  TextEditingController _priceController = new TextEditingController();
  TextEditingController _minDownpaymentController = new TextEditingController();
  TextEditingController _commentController = new TextEditingController();
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _expiryDateController = new TextEditingController();
  ValueNotifier<List<int>> _selectedColors = new ValueNotifier([]);
  ValueNotifier<bool> _isDefaultOffer = new ValueNotifier(false);
  ValueNotifier<bool> _isLoan = new ValueNotifier(false);

  GlobalKey<FormState> _createFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _selectedColors.value = widget.request.colors.map((e) => e.id).toList();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<CatalogProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Form(
            key: _createFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Car details
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserImage(
                        widget.request.buyer,
                        userImageDiameter,
                        fallbackTiInitials: true,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: userImageDiameter,
                              alignment: Alignment.centerLeft,
                              child: RevmoTheme.getBody(widget.request.buyer.fullName, 1, color: RevmoColors.lightPetrol),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            BrandLogo(widget.request.car.model.brand, 26, 26),
                            SizedBox(
                              height: 5,
                            ),
                            RevmoTheme.getSemiBold(widget.request.car.model.fullName, 1, color: RevmoColors.lightPetrol),
                            RevmoTheme.getBody(widget.request.car.desc1, 1, color: RevmoColors.lightPetrol),
                            SizedBox(
                              height: 5,
                            ),
                            // UserImage(
                            //   Provider.of<AccountProvider>(context, listen: false).user!,
                            //   userImageDiameter,
                            // ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 120,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            DateRow(DateTime.now()),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: RevmoCarImageWidget(
                                revmoImage: RevmoCarImage(
                                    imageURL: widget.request.car.model.imageUrl, isModelImage: true, sortingValue: 1),
                                imageHeight: 70,
                                imageWidth: 120,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //Page Break
                PageBreak(),
                SizedBox(
                  height: 12,
                ),
                //Form Title
                RevmoTheme.getTitle(AppLocalizations.of(context)!.createOffer, color: RevmoColors.darkBlue),
                SizedBox(
                  height: 20,
                ),
                RevmoTextField(
                  controller: _priceController,
                  title: AppLocalizations.of(context)!.price,
                  darkMode: false,
                  hintText: AppLocalizations.of(context)!.priceFormHint,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: ValidationBuilder().number(context).build(),
                ),
                RevmoTextField(
                  controller: _minDownpaymentController,
                  title: AppLocalizations.of(context)!.minDownpayment,
                  darkMode: false,
                  hintText: AppLocalizations.of(context)!.minDownpaymentHint,
                  keyboardType: TextInputType.number,
                  validator: ValidationBuilder().number(context).add((input) {
                    int? price = int.tryParse(_priceController.text);
                    int? minDownPayment = int.tryParse(input);
                    if (price != null && minDownPayment != null && minDownPayment > price) {
                      return AppLocalizations.of(context)!.downPaymentLessThanPriceMsg;
                    }
                  }).build(),
                ),
                // RevmoRadioGroupRow(
                //     [AppLocalizations.of(context)!.sameColor, AppLocalizations.of(context)!.otherColors], _colorOption,
                //     onValueChange: (selected) {
                //   print(selected);
                //   if (selected == 0) {
                //     _selectedColors.value = widget.request.colors.map((e) => e.id).toList();
                //   } else if (selected == 1) {
                //     _selectedColors.value = [];
                //   }
                // }),
                //colors multiselect
                RevmoMultiSelect(
                  items: {for (var color in widget.request.colors) color.id: color.name},
                  title: AppLocalizations.of(context)!.colors,
                  hint: AppLocalizations.of(context)!.pickColors,
                  selectedItems: _selectedColors,
                  darkMode: false,
                  validator: (selectedItems) {
                    if (selectedItems == null || selectedItems.length == 0) {
                      return AppLocalizations.of(context)!.fieldReqMsg;
                    }
                  },
                ),
                //dates row
                Row(
                  children: [
                    Expanded(
                      child: RevmoDateField(
                        title: AppLocalizations.of(context)!.from,
                        controller: new TextEditingController(),
                        darkMode: false,
                        defaultValue: DateTime.now(),
                        validator: ValidationBuilder().required().build(),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: RevmoDateField(
                        title: AppLocalizations.of(context)!.to,
                        controller: new TextEditingController(),
                        darkMode: false,
                        validator: ValidationBuilder().required().build(),
                        defaultValue: DateTime.now().add(Duration(days: 7)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                RevmoCheckboxRow(AppLocalizations.of(context)!.isloan, _isLoan),
                PageBreak(),
                RevmoTextField(
                  controller: _commentController,
                  title: AppLocalizations.of(context)!.comment,
                  darkMode: false,
                  maxLines: 3,
                  hintText: AppLocalizations.of(context)!.commentHint,
                ),
                SizedBox(
                  height: 10,
                ),
                RevmoCheckboxRow(AppLocalizations.of(context)!.setAsDefaultOffer, _isDefaultOffer),
              ],
            ),
          ),
        ),
        MainButton(
          text: AppLocalizations.of(context)!.createOffer,
          callBack: submitOffer,
        ),
      ],
    );
  }

  submitOffer() {
    if (_createFormKey.currentState!.validate()) {
      Provider.of<OffersProvider>(context).submitOffer(
          widget.request,
          double.parse(_priceController.text),
          double.parse(_minDownpaymentController.text),
          _selectedColors.value,
          DateTime.parse(_startDateController.text),
          DateTime.parse(_expiryDateController.text),
          _commentController.text,
          _isDefaultOffer.value);
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _minDownpaymentController.dispose();
    _selectedColors.dispose();
    _commentController.dispose();
    _startDateController.dispose();
    _expiryDateController.dispose();
    _isDefaultOffer.dispose();
    super.dispose();
  }
}
