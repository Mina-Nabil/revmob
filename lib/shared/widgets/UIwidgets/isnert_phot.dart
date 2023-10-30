import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../models/offers/docs_model.dart';
import '../../../screens/offers/RequestDocuments/request_documents_service.dart';
import '../../colors.dart';

class InsertPhotosCard extends StatefulWidget {
  final int id;
  Docs doc;
  final String? title, description, startUploadText;
  final void Function()? onAddPhotoPressed;
  final void Function(int index)? onDeletePhotoPressed;
  final Color? color;
  final bool showAddAfterAdding;

  InsertPhotosCard({
    Key? key,
    this.onAddPhotoPressed,
    required this.doc,
    this.onDeletePhotoPressed,
    this.color,
    required this.id,
    this.description,
    this.title,
    this.startUploadText,
    this.showAddAfterAdding = true,
  }) : super(key: key);

  @override
  State<InsertPhotosCard> createState() => _InsertPhotosCardState();
}

class _InsertPhotosCardState extends State<InsertPhotosCard> {
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerDelete =
      RoundedLoadingButtonController();
  final ImagePicker _picker = ImagePicker();

  File? _photo;
  bool loading = false;
  bool ignoring = false;

  @override
  void dispose() {
    // TODO: implement dis
    setState(() {
      _photo = null;
    });
    super.dispose();
  }

  // bool uploaded

  void addPhoto() async {
    try {
      Future.delayed(const Duration(milliseconds: 300), () {
        loading = true;
        setState(() {});
      });

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          loading = false;
        });
        File photo = File(image.path);

        _photo = photo;
      } else {
        setState(() {
          loading = false;
        });
        // ToastService.showErrorToast("no photo selected");
      }
    } catch (e) {}
  }

  final RequestDocumentsService _offerServices = RequestDocumentsService();

  //
  Future<bool> uploadDocumentImage(int offerId, File image) {
    btnController.start();

    try {
      setState(() {
        ignoring = true;
      });
      return _offerServices
          .uploadDocumentFieldImage(offerId, image)
          .then((value) {
        setState(() {
          ignoring = false;
        });
        if (value.statusCode == 200) {
          btnController.success();
          setState(() {
            widget.doc = Docs.fromJson(value.data["body"]);
          });

          return Future.value(true);
        } else {
          setState(() {
            ignoring = false;
          });
          btnController.error();

          Future.delayed(const Duration(seconds: 1), () {
            btnController.reset();
          });
          // ToastService.showErrorToast("Something went wrong please try again");
          return Future.value(false);
        }
      });
    } catch (e) {
      btnController.error();

      Future.delayed(const Duration(seconds: 1), () {
        btnController.reset();
      });
      return Future.value(false);
    }
  }

  Future<bool> deleteDocumentUrl() {
    try {
      return _offerServices.deleteImageUrl(widget.doc.id).then((value) {
        if (value.statusCode == 200) {
          setState(() {
            widget.doc.fullUrl = null;
            _photo = null;
          });
          return Future.value(true);
        } else {
          // ToastService.showUnExpectedErrorToast();
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> deleteDocument() {
    try {
      return _offerServices.deleteImageUrl(widget.doc.id).then((value) {
        if (value.statusCode == 200) {
          setState(() {
            widget.doc.fullUrl = null;
            _photo = null;
          });
          return Future.value(true);
        } else {
          // ToastService.showUnExpectedErrorToast();
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    if (widget.doc.fullUrl != null) {}
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.doc.isSeller == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!.toUpperCase(),
                    style: theme.textTheme.labelMedium
                        ?.copyWith(fontSize: 16, color: Colors.white),
                  ).setOnlyPadding(context, top: 0.03, bottom: 0.005),
                  Text(
                    widget.description ??
                        "You can upload up to 10 photos each time",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff6E6E6E),
                      fontSize: 12,
                    ),
                  ).setOnlyPadding(context, bottom: 0.015),
                ],
              )
            : const SizedBox(
                height: 20,
              ),
        Container(
          width: mediaQuery.size.width,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loading == true
                  ? const FadeShimmer(
                      width: 150,
                      height: 80,
                      radius: 15,
                      highlightColor: Color(0xffF9F9FB),
                      baseColor: Color(0xffE6E8EB),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.doc.fullUrl != null && widget.doc.isSeller == 0

                            /// seller = true and have image
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FadeIn(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        widget.doc.fullUrl!,
                                        fit: BoxFit.cover,
                                        height: mediaQuery.size.height * 0.2,
                                        width: mediaQuery.size.width * 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Center(
                                    child: Container(
                                      height: 45,
                                      width: 3,
                                      decoration: BoxDecoration(
                                          color: RevmoColors.originalBlue,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.title ?? "Upload Photos",
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                      ).setOnlyPadding(context,
                                          top: 0.015, bottom: 0.005),
                                      Text(
                                        widget.description ??
                                            "You can upload up to 10 photos each time",
                                        textAlign: TextAlign.center,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff6E6E6E),
                                          fontSize: 12,
                                        ),
                                      ).setOnlyPadding(context, bottom: 0.015),
                                    ],
                                  )
                                ],
                              )
                            : widget.doc.fullUrl != null &&
                                    widget.doc.isSeller == 1
                                ? Row(
                                    children: [
                                      FadeIn(
                                        child: SizedBox(
                                          width: mediaQuery.size.width * 0.5,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              widget.doc.fullUrl!,
                                              // height: mediaQuery.size.height * 0.13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Iconsax.cloud_remove,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Delete Image from\n server ",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          RoundedLoadingButton(
                                            borderRadius: 50,
                                            errorColor: Colors.red,
                                            width: 80,
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
                                                  // fontFamily: context.locale
                                                  //     .toString() ==
                                                  //     "en"
                                                  //     ? 'Gibson-Light.otf'
                                                  //     : "Noto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            controller: btnController,
                                            onPressed: () async {
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              await deleteDocumentUrl();

                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                btnController.reset();
                                              });
                                              // uploadDocument(widget.id, _photo!).then((value) {
                                              //   Future.delayed(Duration(seconds: 1), () {
                                              //     btnController.reset();
                                              //   });
                                              // });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : _photo != null
                                    ? FadeIn(
                                        child: SizedBox(
                                          width: mediaQuery.size.width * 0.5,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.file(
                                                  _photo!,
                                                  // height: mediaQuery.size.height * 0.13,
                                                ),
                                              ),
                                              Positioned(
                                                  right: -5,
                                                  top: -2,
                                                  child: IgnorePointer(
                                                    ignoring: ignoring,
                                                    child: InkWell(
                                                      onTap: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        setState(() {
                                                          _photo = null;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ignoring
                                                                ? Colors.grey
                                                                : Colors.black,
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
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      )
                                    : widget.doc.isSeller == 0
                                        ? SizedBox(
                                            width: mediaQuery.size.width * 0.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Iconsax.timer_14,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "User didnt upload any documents yet,\n please comeback later...",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                  child: Container(
                                                    height: 3,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                        color: RevmoColors
                                                            .originalBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.title ??
                                                          "Upload Photos",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: theme
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ).setOnlyPadding(context,
                                                        bottom: 0.005),
                                                    Text(
                                                      widget.description ??
                                                          "You can upload up to 10 photos each time",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: theme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff6E6E6E),
                                                        fontSize: 12,
                                                      ),
                                                    ).setOnlyPadding(context,
                                                        bottom: 0.015),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              addPhoto();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.export,
                                                    color: Colors.black,
                                                  ).setOnlyPadding(context,
                                                      right: 0.02),
                                                  Text(
                                                    widget.startUploadText ??
                                                        'Start Uploading Photos',
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color: widget
                                                                    .color ??
                                                                Colors.black,
                                                            fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                      ],
                    ),
              if (_photo != null &&
                  widget.doc.fullUrl == null &&
                  widget.doc.isSeller == 1)
                Column(
                  children: [
                    const Icon(
                      Iconsax.export,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ignoring
                        ? Text(
                            "Please wait   \nfor uploading       ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text(
                            "Upload document\nimage to seller",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundedLoadingButton(
                      borderRadius: 50,
                      errorColor: Colors.red,
                      width: 80,
                      height: 30,
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
                      controller: btnController,
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        uploadDocumentImage(widget.id, _photo!).then((value) {
                          Future.delayed(Duration(seconds: 1), () {
                            btnController.reset();
                          });
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
