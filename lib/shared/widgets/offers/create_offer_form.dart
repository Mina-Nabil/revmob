import 'dart:collection';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/revmo_image.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/providers/Seller/offers_provider.dart';
import 'package:revmo/shared/custom_validators.dart';
import 'package:revmo/providers/Seller/catalog_provider.dart';
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
import 'package:revmo/Configurations/Extensions/extensions.dart';

import '../../../models/cars/available_options.dart';
import '../../../providers/Seller/account_provider.dart';
import '../Customers/detail_text.dart';
import '../UIwidgets/checkBox_revmo.dart';
import '../UIwidgets/custom_cachedNetwork.dart';
import '../UIwidgets/success_message.dart';
import '../misc/revmo_checkbox.dart';

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
  List<int> _selectedColorss = [];
  ValueNotifier<bool> _isDefaultOffer = new ValueNotifier(false);
  ValueNotifier<bool> _isLoan = new ValueNotifier(false);

  GlobalKey<FormState> _createFormKey = new GlobalKey<FormState>();

  HashMap<String, HashSet<String>> selectedOptionMap =
      HashMap<String, HashSet<String>>();

  addMapOptions(Option option) {
    print("adding");
    if (!selectedOptionMap.containsKey(option.adopAdjtId.toString())) {
      selectedOptionMap[option.adopAdjtId.toString()] = HashSet<String>();
    }
    selectedOptionMap[option.adopAdjtId!.toString()]?.add(option.id.toString());
  }

  removeMapOptions(Option option) {
    print("removing");
    selectedOptionMap[option.adopAdjtId!.toString()]
        ?.remove(option.id.toString());
  }

  isOptionAvailable(Option option) {
    print("is Avail");
    return selectedOptionMap.containsKey(option.adopAdjtId.toString()) &&
        (selectedOptionMap[option.adopAdjtId.toString()]
                ?.contains(option.id.toString()) ??
            false);
  }

  mapOptionsIDs(HashMap<String, HashSet<String>> selected) {
    Map selectedIDs = Map<String, String>();
    selected.forEach((catgID, selectedOptions) {
      selectedOptions.forEach((element) {
        selectedIDs[element] = catgID;
      });
    });
    return selectedIDs;
  }

  @override
  void initState() {
    _selectedColors.value = widget.request.colors.map((e) => e.id).toList();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<CatalogProvider>(context, listen: false);
    });
    super.initState();
  }

  bool colorValidator = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: UserImage(
                            widget.request.buyer,
                            userImageDiameter,
                            fallbackTiInitials: true,
                          ),
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
                                alignment:            AppLocalizations.of(context)!.localeName == "en"
?                                Alignment.centerLeft: Alignment.centerRight,
                                child: RevmoTheme.getBody(
                                    widget.request.buyer.fullName, 1,
                                    color: RevmoColors.lightPetrol),
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              BrandLogo(widget.request.car.model.brand, 26, 26),
                              SizedBox(
                                height: 5,
                              ),
                              RevmoTheme.getSemiBold(
                                  widget.request.car.model.fullName, 1,
                                  color: RevmoColors.lightPetrol),
                              RevmoTheme.getBody(widget.request.car.desc1, 1,
                                  color: RevmoColors.lightPetrol),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              DateRow(widget.request.createdDate),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: RevmoCarImageWidget(
                                  revmoImage: RevmoCarImage(
                                      imageURL:
                                          widget.request.car.model.imageUrl,
                                      isModelImage: true,
                                      sortingValue: 1),
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
                  ExpandablePageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [mainPage1(context), mainPage2(context)],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MainButton(
              text: currentPage == 0
                  ? AppLocalizations.of(context)!.createOffer
                  : 'Confirm Offer',
              callBack: () {
                if (currentPage == 0 &&
                    _createFormKey.currentState!.validate()) {
                  if (widget.request
                          .validateSelectedOptions(selectedOptionMap) ==
                      false) {
                    RevmoTheme.showRevmoSnackbar(context, 'Please select car options');
                    print("select options");
                  } else {
                    print('this is page 0');
                    jumpToPage(1);
                  }
                } else {
                  submitOffer();
                }
              }),
          SizedBox(
            height: 40,
          )
        ],
      ).setPageHorizontalPadding(context),
    );
  }

  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  var formatter = NumberFormat();

  Widget mainPage1(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Form Title
        RevmoTheme.getTitle(AppLocalizations.of(context)!.createOffer,
            color: RevmoColors.darkBlue),
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
            if (price != null &&
                minDownPayment != null &&
                minDownPayment > price) {
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
        // Container(
        //     alignment: Alignment.topLeft,
        //     margin:
        //         EdgeInsets.symmetric(vertical: RevmoTheme.FIELDS_VER_MARGIN),
        //     child: RevmoTheme.getTextFieldLabel(
        //         AppLocalizations.of(context)!.colors,
        //         color: RevmoColors.darkBlue)),
        //
        //
        // MultiSelectChipField(
        //   items: widget.request.colors
        // .map((e) => MultiSelectItem(e.id, e.toString()))
        // .toList(),
        //   // initialValue: [_animals[4], _animals[7], _animals[9]],
        //   // title: Text("Animals"),
        //   // headerColor: Colors.blue.withOpacity(0.5),
        //   // decoration: BoxDecoration(
        //   //   border: Border.all(color: Colors.blue[700], width: 1.8),
        //   // ),
        //   selectedChipColor: Colors.blue.withOpacity(0.5),
        //   selectedTextStyle: TextStyle(color: Colors.blue[800]),
        //   onTap: (values) {
        //     //_selectedAnimals4 = values;
        //   },
        // ),
        // MultiSelectChipDisplay(
        //   items: widget.request.colors
        //       .map((e) => MultiSelectItem(e.id, e.toString()))
        //       .toList(),
        //   onTap: (value) {
        //     print(value);
        //     setState(() {
        //       _selectedColors.value.remove(value);
        //     });
        //   },
        // ),
        RevmoMultiSelectt(
          items: {
            for (var color in widget.request.colors) color.id : color.name
          },
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

        SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, indexx) {
                return Container(
                    margin:
                        const EdgeInsets.only(bottom: 20.0, left: 0, right: 0),
                    // padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.topCenter,
                    child: ExpandedField(
                      title: widget.request.availableOptions[indexx].adjtName!,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          widget.request.availableOptions.isNotEmpty
                              ? SizedBox(
                                  height: 170,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var option = widget
                                          .request
                                          .availableOptions[indexx]
                                          .options![index];

                                      return InkWell(
                                        onTap: () {
                                          if (isOptionAvailable(option)) {
                                            print('condition1');
                                            setState(() {
                                              removeMapOptions(option);
                                            });
                                            print(selectedOptionMap.length);
                                          } else {
                                            print('condition2');
                                            setState(() {
                                              addMapOptions(option);
                                            });
                                            print(selectedOptionMap.length);
                                          }
                                        },
                                        child: _selectWidget(
                                            selected: isOptionAvailable(option),
                                            imgUrl: widget
                                                .request
                                                .availableOptions[indexx]
                                                .options![index]
                                                .imageUrl,
                                            // widget.colors[index].imageUrl!,
                                            title: widget
                                                .request
                                                .availableOptions[indexx]
                                                .options![index]
                                                .adopName!),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width: 10,
                                      );
                                    },
                                    itemCount: widget
                                        .request
                                        .availableOptions[indexx]
                                        .options!
                                        .length,
                                  ),
                                )
                              : SizedBox(
                                  height: 80,
                                  child: Center(
                                      child: Text(
                                    "no Data",
                                    style: const TextStyle(
                                        color: RevmoColors.darkBlue),
                                  ))),
                        ],
                      ),
                    )
                    // child: RevmoExpandableInfoCard(
                    //   body: Column(
                    //     children: [
                    //       widget.car.availableOptions!.isNotEmpty
                    //           ? GridView.builder(
                    //           padding: const EdgeInsets.only(
                    //               top: 20,
                    //               bottom: 20,
                    //               left: 20,
                    //               right: 20),
                    //           shrinkWrap: true,
                    //           physics:
                    //           const NeverScrollableScrollPhysics(),
                    //           gridDelegate:
                    //           const SliverGridDelegateWithFixedCrossAxisCount(
                    //               crossAxisCount: 2,
                    //               crossAxisSpacing: 10,
                    //               mainAxisSpacing: 10
                    //             //
                    //           ),
                    //           itemCount: widget
                    //               .car
                    //               .availableOptions![indexx]
                    //               .options!
                    //               .length,
                    //           itemBuilder: (BuildContext ctx, index) {
                    //             var option = widget
                    //                 .car
                    //                 .availableOptions![indexx]
                    //                 .options![index];
                    //             return GestureDetector(
                    //               onTap: () {
                    //
                    //                 if (isOptionAvailable(option)) {
                    //                   print('condition1');
                    //                   setState(() {
                    //                     removeMapOptions(option);
                    //                   });
                    //                   print(selectedOptionMap.length);
                    //                 } else {
                    //                   print('condition2');
                    //                   setState(() {
                    //                     addMapOptions(option);
                    //                   });
                    //                   print(selectedOptionMap.length);
                    //                 }
                    //               },
                    //               child: _selectWidget(
                    //                   selected: isOptionAvailable(option) ,
                    //                   imgUrl: widget
                    //                       .car
                    //                       .availableOptions![indexx]
                    //                       .options![index]
                    //                       .imageUrl,
                    //                   // widget.colors[index].imageUrl!,
                    //                   title: widget
                    //                       .car
                    //                       .availableOptions![indexx]
                    //                       .options![index]
                    //                       .adopName!),
                    //             );
                    //           })
                    //           : SizedBox(
                    //           height: 80,
                    //           child: Center(
                    //               child: Text(
                    //                 "global.noColorAv".tr(),
                    //                 style: const TextStyle(
                    //                     color: RevmoColors.darkBlue),
                    //               ))),
                    //     ],
                    //   ),
                    //   title: widget.car.availableOptions![indexx].adjtName!,
                    //   initialStateExpanded: false,
                    //   minHeight: RevmoTheme.DETAILS_BOXES_MIN,
                    //   maxHeight:  widget
                    //       .car
                    //       .availableOptions![indexx]
                    //       .options!
                    //       .length  < 3 ?  250 : 370,
                    // )

                    );
              },
              itemCount: widget.request.availableOptions.length),
        ),

        // ExpandedField(
        //   validatorColor: colorValidator,
        //   selectedItems: _selectedColors,
        //   validator: (selectedItems) {
        //     print(selectedItems);
        //     if (selectedItems == null || selectedItems.length == 0) {
        //       setState(() {
        //         colorValidator = true;
        //         print(colorValidator);
        //       });
        //       return AppLocalizations.of(context)!.fieldReqMsg;
        //     }
        //   },
        //   items: {
        //     for (var color in widget.request.colors) color.id: color.name
        //   },
        // ),
        // RevmoMultiSelectt(
        //   items: {
        //     for (var color in widget.request.colors) color.id: color.name
        //   },
        //   title: AppLocalizations.of(context)!.colors,
        //   hint: AppLocalizations.of(context)!.pickColors,
        //   selectedItems: _selectedColors,
        //   darkMode: false,
        //   validator: (selectedItems) {
        //     if (selectedItems == null || selectedItems.length == 0) {
        //       return AppLocalizations.of(context)!.fieldReqMsg;
        //     }
        //   },
        // ),
        //dates row
        Row(
          children: [
            Expanded(
              child: RevmoDateField(
                title: AppLocalizations.of(context)!.from,
                controller: _startDateController,
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
                controller: _expiryDateController,
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
        RevmoCheckboxRow(
            AppLocalizations.of(context)!.setAsDefaultOffer, _isDefaultOffer),
      ],
    ).setOnlyPadding(context, top: 0, bottom: 0, left: 0.02, right: 0.02);
  }

  Widget mainPage2(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Form Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RevmoTheme.getTitle(AppLocalizations.of(context)!.details,
                color: RevmoColors.darkBlue),
            MainButton(
                width: 100,
                text: 'Edit offer',
                // AppLocalizations.of(context)!.,
                callBack: () {
                  jumpToPage(0);
                }),
          ],
        ),
        SizedBox(
          height: 20,
        ),

        DetailText(
          fontSize: 16,
          title: 'Price',
          info: formatter
                  .format(double.parse(_priceController.text.isNotEmpty
                      ? _priceController.text
                      : '0'))
                  .toString() +
              ' EGP',
        ),
        DetailText(
          topPadding: 20,
          fontSize: 16,
          title: 'Min Reservation Payment',
          info: formatter
                  .format(double.parse(_minDownpaymentController.text.isNotEmpty
                      ? _minDownpaymentController.text
                      : '0'))
                  .toString() +
              ' EGP',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DetailText(
              topPadding: 20,
              fontSize: 16,
              title: 'Offer Start Date',
              info: _startDateController.text,
              icon: Icon(
                Icons.calendar_month_rounded,
                color: RevmoColors.darkBlue,
                size: 18,
              ),
            ),
            DetailText(
              topPadding: 20,
              fontSize: 16,
              title: 'Offer end Date',
              info: _expiryDateController.text,
              icon: Icon(
                Icons.calendar_month_rounded,
                color: RevmoColors.darkBlue,
                size: 18,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Option Included ?',
              style: TextStyle(fontSize: 16, color: RevmoColors.darkBlue),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                child: Icon(
              _isLoan.value == false ? Icons.close : Icons.check_circle,
              color: _isLoan.value == false
                  ? Colors.red
                  : RevmoColors.originalBlue,
              size: 19,
            )),
          ],
        ),

        _commentController.text.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Comment',
                    style: TextStyle(fontSize: 16, color: RevmoColors.darkBlue),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: RevmoColors.darkBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _commentController.text,
                          style: TextStyle(color: RevmoColors.darkBlue),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    ).setOnlyPadding(context, top: 0, bottom: 0, left: 0.02, right: 0.02);
  }

  jumpToPage(int? pageNumber) async {
    _pageController.jumpToPage(pageNumber!);
    setState(() {
      currentPage = pageNumber;
    });

    print('$currentPage  current page');
  }

  submitOffer() {
    print(widget.request.id);

    if (_createFormKey.currentState!.validate()) {
      EasyLoading.show();
      print(_selectedColors.value);
      Provider.of<OffersProvider>(context, listen: false)
          .submitOfferNetworkLayer(
              widget.request,
              double.parse(_priceController.text),
              double.parse(_minDownpaymentController.text),
              _selectedColors.value,
              // DateFormat('dd-MM-yyyy').format(DateTime.parse(_startDateController.text)).toString(),
              // DateFormat('dd-MM-yyyy').format(DateTime.parse(_expiryDateController.text)).toString(),
              _startDateController.text,
              _expiryDateController.text,
              _isLoan.value,
              mapOptionsIDs(selectedOptionMap),
              _commentController.text,
              _isDefaultOffer.value)
          .then((value) async {
        EasyLoading.dismiss();
        await Provider.of<AccountProvider>(context, listen: false)
            .loadCurrentPlan();
        refreshPendingRequests();

        if (value) {
          Navigator.pop(context, widget.request.id);
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return SuccessMessage(
                  message: 'Offer Created Successfully',
                );
              });
        } else {
          EasyLoading.dismiss();
          RevmoTheme.showRevmoSnackbar(context, 'Something went wrong');
        }
        print('hereeeee');
        print(value);
      });
      // EasyLoading.dismiss();

    }
  }
  Future refreshPendingRequests() async {
    await Provider.of<OffersProvider>(context, listen: false).loadPendingOffers(forceReload: true);
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

class ExpandedField extends StatefulWidget {
  final Widget child;
  final String title;

  ExpandedField({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  @override
  State<ExpandedField> createState() => _ExpandedFieldState();
}

class _ExpandedFieldState extends State<ExpandedField> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.symmetric(vertical: RevmoTheme.FIELDS_VER_MARGIN),
            child: RevmoTheme.getTextFieldLabel(widget.title,
                color: RevmoColors.darkBlue)),
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: AnimatedContainer(
            padding: EdgeInsets.all(10),
            duration: Duration(milliseconds: 300),
            // margin: EdgeInsets.only(bottom: 10),
            // height: expanded == true
            //     ? mediaQuery.size.height * 0.07
            //     : mediaQuery.size.height * 0.18,
            width: mediaQuery.size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: RevmoColors.darkGrey, width: .35),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                // !expanded ? SizedBox.shrink() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pick ${widget.title}",
                      style: RevmoTheme.getBodyStyle(1,
                          color: RevmoColors.darkBlue),
                    ),
                    !expanded
                        ? Icon(
                            Iconsax.arrow_up_15,
                            color: RevmoColors.darkBlue,
                          )
                        : Icon(
                            Iconsax.arrow_down5,
                            color: RevmoColors.darkBlue,
                          ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                expanded ? SizedBox.shrink() : widget.child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _selectWidget extends StatelessWidget {
  _selectWidget(
      {Key? key,
      required this.title,
      required this.imgUrl,
      required this.selected})
      : super(key: key);
  String? imgUrl;
  String title;
  bool selected;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // imgUrl == null
        //     ? Lottie.asset('assets/images/gear_loading.json',
        //     height: mediaQuery.size.height * 0.1,
        //     frameRate: FrameRate.composition,
        //     repeat: true)
        //     :

        imgUrl != null
            ? SizedBox(
                height: mediaQuery.size.height * 0.1,
                child: Image.network(imgUrl!),
              )
            : SizedBox(
                height: mediaQuery.size.height * 0.1,
              ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.25,
          child: Text(
            title,
            style: const TextStyle(
              color: RevmoColors.darkBlue,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CheckBoxMickeyRevmo(
          initialValue: selected,
        )
      ],
    );
  }
}
