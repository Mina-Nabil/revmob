import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/Configurations/Extensions/capitalize_extension.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/services/toast_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../models/offers/offer.dart';
import '../../../shared/colors.dart';
import '../../../shared/theme.dart';
import '../../../shared/widgets/home/revmo_appbar.dart';
import '../../../shared/widgets/misc/revmo_text_field.dart';
import 'extras_viewmodel.dart';

class Extras extends StatelessWidget {
  final Offer offer;

  const Extras({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => ExtrasView(),
      viewModel: ExtraViewModel(offer: offer),
    );
  }
}

class ExtrasView extends HookView<ExtraViewModel> {
  @override
  Widget render(BuildContext context, ExtraViewModel viewModel) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              useRootNavigator: true,
              enableDrag: false,
              shape: const RoundedRectangleBorder(
                // <-- SEE HERE
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              isDismissible: false,
              builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: mediaQuery.size.height * 0.8,
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom * 0.8),
                        child: GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: ListView(
                            children: [
                              IgnorePointer(
                                ignoring: viewModel.ignoring,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: mediaQuery.size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            "Add Extras",
                                            style: TextStyle(
                                                color: RevmoColors.darkBlue,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            padding: const EdgeInsets.all(3),
                                            child: MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    // viewModel.noteController.clear();
                                                    // viewModel.titleController.clear();
                                                    viewModel.picture = null;
                                                    viewModel.notifyListeners();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: RevmoColors.darkBlue,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: RevmoTextField(
                                          controller: viewModel.titleController,
                                          // controller: TextEditingController(),
                                          title: "Title",
                                          darkMode: false,
                                          hintText:
                                              "Wheel Rims, mirrors, seats...",
                                          keyboardType:
                                              TextInputType.text
                                          // validator: ValidationBuilder().number(context).build(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: RevmoTextField(
                                          controller: viewModel.noteController,
                                          title: "Accessory type",
                                          darkMode: false,
                                          hintText:
                                              "Spare parts, Accessories, Entertainment  ",
                                          keyboardType:
                                          TextInputType.text

                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: RevmoTextField(
                                          controller: viewModel.priceController,
                                          // controller: TextEditingController(),
                                          title: "Price",
                                          darkMode: false,
                                          hintText: "10,000",
                                          keyboardType: TextInputType.number,
                                          // validator: ValidationBuilder().number(context).build(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: RevmoTheme.getTextFieldLabel(
                                              "Add photo",
                                              color: RevmoColors.darkBlue)),
                                      viewModel.loading
                                          ? const FadeShimmer(
                                              width: 150,
                                              height: 80,
                                              radius: 15,
                                              highlightColor: Color(0xffF9F9FB),
                                              baseColor: Color(0xffE6E8EB),
                                            )
                                          : viewModel.picture != null
                                              ? FadeIn(
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.file(
                                                          viewModel.picture!,
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.5,
                                                          height: mediaQuery
                                                                  .size.height *
                                                              0.2,
                                                          fit: BoxFit.cover,
                                                          // height: mediaQuery.size.height * 0.13,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          right: -5,
                                                          top: -2,
                                                          child: InkWell(
                                                            onTap: () {
                                                              HapticFeedback
                                                                  .lightImpact();
                                                              viewModel
                                                                      .picture =
                                                                  null;
                                                              setState(() {
                                                                viewModel
                                                                        .picture =
                                                                    null;
                                                                viewModel
                                                                    .notifyListeners();
                                                              });

                                                              // _photo!.delete();
                                                              // widget.onDeletePhotoPressed!(index);
                                                            },
                                                            child: Container(
                                                                height: 20,
                                                                width: 20,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: viewModel
                                                                          .ignoring
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Icon(
                                                                  Iconsax
                                                                      .gallery_remove,
                                                                  size: 10,
                                                                )),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  width: mediaQuery.size.width,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: RevmoColors
                                                            .darkBlue,
                                                        width: 0.2),
                                                    color: Colors.white,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      viewModel
                                                          .addPhoto()
                                                          .then((value) {
                                                        if (value != null) {
                                                          var photo =
                                                              value as XFile;
                                                          File photoSelected =
                                                              File(photo.path);

                                                          viewModel.picture =
                                                              photoSelected;
                                                          viewModel
                                                              .notifyListeners();
                                                          setState(() {});
                                                          print(viewModel
                                                              .picture!.path);
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Iconsax.export,
                                                            color: Colors.black,
                                                          ).setOnlyPadding(
                                                              context,
                                                              right: 0.02),
                                                          Text(
                                                            "Upload (PNG,JPG)",
                                                            style: RevmoTheme
                                                                .getBodyStyle(1,
                                                                    color: RevmoColors
                                                                        .greyishBlue),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RoundedLoadingButton(
                                        borderRadius: 50,
                                        errorColor: Colors.red,
                                        width: mediaQuery.size.width * 0.3,
                                        height: 40,
                                        elevation: 0,
                                        loaderSize: 15,
                                        color: RevmoColors.originalBlue,
                                        successColor: Colors.green,
                                        successIcon: Icons.check,
                                        failedIcon: Icons.close,
                                        child: Text(
                                          "Start Upload",
                                          style: TextStyle(
                                              fontSize: 12,
                                              // fontFamily: context.locale.toString() == "en"
                                              //     ? 'Gibson-Light.otf'
                                              //     : "Noto",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200),
                                        ),
                                        controller: viewModel.btnController,
                                        onPressed: () {
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }

                                          if(viewModel.picture != null && viewModel.titleController.text.isNotEmpty && viewModel.priceController.text.isNotEmpty && viewModel.noteController.text.isNotEmpty ) {
                                            setState(() {
                                              viewModel.ignoring = true;
                                              viewModel.notifyListeners();
                                            });
                                            viewModel
                                                .uploadDocument()
                                                .then((value) {
                                              setState(() {
                                                viewModel.ignoring = false;
                                                viewModel.notifyListeners();
                                              });
                                              if (value) {
                                                viewModel.fetchExtras();

                                                setState(() {
                                                  viewModel.noteController
                                                      .clear();
                                                  viewModel.titleController
                                                      .clear();
                                                  viewModel.priceController
                                                      .clear();
                                                  viewModel.picture = null;
                                                  viewModel.notifyListeners();
                                                });
                                                Navigator.pop(context);
                                              } else {}
                                              Future.delayed(Duration(seconds: 1),
                                                      () {
                                                    viewModel.btnController.reset();
                                                  });
                                            });
                                          } else {
                                            // RevmoTheme.showRevmoSnackbar(context,"Please fill all data");
ToastService.showErrorToast("Please fill all data");
                                            viewModel.btnController.reset();
                                          }

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ));
        },
        backgroundColor: RevmoColors.originalBlue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: RevmoColors.darkBlue,
      appBar: RevmoAppBar(
        title: 'Extras',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: viewModel.getExtrasFuture,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    print("con1 sellerDocuments");
                    if (viewModel.extras.isEmpty) {
                      print("con2 sellerDocuments");
                      return SizedBox(
                        height: mediaQuery.size.height * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Icon(
                                Iconsax.timer_14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                "No Extras Please add Extra products to the offer",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ).setPageHorizontalPadding(context),
                      );                  } else {
                      print("con3 sellerDocuments");

                      return
                          // Center(child: Text("no Data", style: TextStyle(color: Colors.black),));
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your Uploaded Extras",
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 3,
                            width: 10,
                            decoration: BoxDecoration(
                                color: RevmoColors.originalBlue,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.extras.length,
                            itemBuilder: (context, index) {
                              final RoundedLoadingButtonController deletebtnController =
                              RoundedLoadingButtonController();

                              return Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  // color: const Color(0xffF5F5F1),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        height: 100,
                                        width: 150,
                                        child: Image.network(
                                          viewModel.extras[index].fullUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viewModel.extras[index].note.capitalize(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                           viewModel.extras[index].title.capitalize(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${NumberFormat().format(int.parse(viewModel.extras[index].price))} EGP',
                                          style: TextStyle(
                                              color: RevmoColors.darkBlue,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RoundedLoadingButton(
                                          borderRadius: 50,
                                          errorColor: Colors.red,
                                          width: mediaQuery.size.width * 0.19,
                                          height: 30,
                                          elevation: 0,
                                          loaderSize: 15,
                                          color: RevmoColors.pinkishRed,
                                          successColor: Colors.green,
                                          successIcon: Icons.check,
                                          failedIcon: Icons.close,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 12,
                                                // fontFamily: context.locale.toString() == "en"
                                                //     ? 'Gibson-Light.otf'
                                                //     : "Noto",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          controller: deletebtnController,
                                          onPressed: () {
                                            FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }


                                            viewModel
                                                .deleteDocument(viewModel.extras[index].id)
                                                .then((value) {

                                              if (value) {
                                                viewModel.extras.removeAt(index);
                                                viewModel.notifyListeners();

                                              } else {}
                                              Future.delayed(Duration(seconds: 0),
                                                      () {
                                                    deletebtnController.reset();
                                                  });
                                            });
                                          },
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            shrinkWrap: true,
                          )
                        ],
                      ).setPageHorizontalPadding(context);
                    }
                  } else {
                    return ListView.separated(
                        padding: const EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              FadeShimmer(
                                height: mediaQuery.size.height * 0.15,
                                width: mediaQuery.size.width * 0.48,
                                highlightColor: const Color(0xffF9F9FB),
                                baseColor: const Color(0xffE6E8EB),
                                radius: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const FadeShimmer(
                                    height: 10,
                                    width: 40,
                                    highlightColor: Color(0xffF9F9FB),
                                    baseColor: Color(0xffE6E8EB),
                                    radius: 10,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  const FadeShimmer(
                                    height: 10,
                                    width: 100,
                                    highlightColor: Color(0xffF9F9FB),
                                    baseColor: Color(0xffE6E8EB),
                                    radius: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: 6)
                        .setPageHorizontalPadding(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
