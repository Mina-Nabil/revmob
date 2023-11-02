import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/services/toast_service.dart';
import 'package:revmo/shared/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../shared/theme.dart';
import '../../../shared/widgets/UIwidgets/isnert_phot.dart';
import '../../../shared/widgets/home/revmo_appbar.dart';
import '../../../shared/widgets/misc/revmo_text_field.dart';
import 'request_documents_viewmodel.dart';

class RequestDocuments extends StatelessWidget {
  final Offer offer;

  const RequestDocuments({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => RequestDocumentsView(),
      viewModel: RequestDocumentsViewModel(offer: offer),
    );
  }
}

class RequestDocumentsView extends HookView<RequestDocumentsViewModel> {
  @override
  Widget render(BuildContext context, RequestDocumentsViewModel viewModel) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              useRootNavigator: true,
              shape: const RoundedRectangleBorder(
                // <-- SEE HERE
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              isDismissible: false,
              builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return GestureDetector(
                        onTap: () {},
                        child: IgnorePointer(
                          ignoring: viewModel.ignoring,
                          child: Wrap(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.695,
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
                                          AppLocalizations.of(context)!.addDocumentRequest,
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
                                                  viewModel.noteController.clear();
                                                  viewModel.titleController.clear();
                                                  viewModel.photoFromDevice = null;
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
                                        title: AppLocalizations.of(context)!.title,
                                        darkMode: false,
                                        hintText: AppLocalizations.of(context)!.documentsRequiredlabel,
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
                                        title: AppLocalizations.of(context)!.note,
                                        darkMode: false,
                                        hintText: AppLocalizations.of(context)!.notesForBuyer,
                                        keyboardType:
                                            TextInputType.text
                                        // validator: ValidationBuilder().number(context).build(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: RevmoTheme.getTextFieldLabel(
                                            AppLocalizations.of(context)!.addPhoto,
                                            color: RevmoColors.darkBlue)),
                                    viewModel.loading
                                        ? const FadeShimmer(
                                            width: 150,
                                            height: 80,
                                            radius: 15,
                                            highlightColor: Color(0xffF9F9FB),
                                            baseColor: Color(0xffE6E8EB),
                                          )
                                        : viewModel.photoFromDevice != null
                                            ? FadeIn(
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.centerLeft,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.file(
                                                        viewModel
                                                            .photoFromDevice!,
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
                                                                    .photoFromDevice =
                                                                null;
                                                            setState(() {
                                                              viewModel
                                                                      .photoFromDevice =
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
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: RevmoColors.darkBlue,
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

                                                        viewModel
                                                                .photoFromDevice =
                                                            photoSelected;
                                                        viewModel
                                                            .notifyListeners();
                                                        setState(() {});
                                                        print(viewModel
                                                            .photoFromDevice!
                                                            .path);
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Iconsax.export,
                                                          color: Colors.black,
                                                        ).setOnlyPadding(context,
                                                            right: 0.02),
                                                        Text(
                                                          AppLocalizations.of(context)!.upload,
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
                                        AppLocalizations.of(context)!.startUpload,
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

                                        if( viewModel.titleController.text.isNotEmpty &&
                                        viewModel.noteController.text.isNotEmpty &&
                                        viewModel.photoFromDevice != null ){
                                          setState(() {
                                            viewModel.ignoring = true;
                                            viewModel.notifyListeners();
                                          });
                                          viewModel.uploadDocument().then((value) {
                                            setState(() {
                                              viewModel.ignoring = false;
                                              viewModel.notifyListeners();

                                            });
                                            if (value) {
                                              viewModel.fetchDocuments();

                                              setState(() {
                                                viewModel.noteController.clear();
                                                viewModel.titleController.clear();
                                                viewModel.photoFromDevice = null;
                                                viewModel.notifyListeners();
                                              });
                                              Navigator.pop(context);

                                            } else {
                                            }
                                            Future.delayed(Duration(seconds: 1),
                                                    () {
                                                  viewModel.btnController.reset();
                                                });
                                          });
                                        }else {
                                          ToastService.showErrorToast(AppLocalizations.of(context)!.pleaseFillAllData);
                                        }
                                      },
                                    ),
                                  ],
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
        title: AppLocalizations.of(context)!.requestDocuments,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   // height: mediaQuery.size.height * 0.16,
            //   padding: const EdgeInsets.all(20),
            //   color: const Color(0xffEBE4D1),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Terms and Condition",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Text(
            //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean quis leo non metus pharetra bibendum ut a arcu. Phasellus lobortis magna lacus, vitae elementuget lectus. Aenean quis varius velit. Nam dictum nisl sit amet justo euismod porttitor. Nulla luct. Cras dictum metus odio, ut viverra purus iaculis vitae.",
            //         style: TextStyle(color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                FutureBuilder(
                    future: viewModel.getDocsFuture,
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.done) {
                        print("con1 documents");
                        if (viewModel.documents.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Text(
                                AppLocalizations.of(context)!.requestDocuments,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                height:3, width: 20,
                                decoration:  BoxDecoration(color: RevmoColors.originalBlue, borderRadius: BorderRadius.circular(20)),
                              ),
                              const SizedBox(height: 30,),
                              const   Center(
                                child: Icon(
                                  Iconsax.timer_14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10,),

                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noDocumentsUploadedYet,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ).setPageHorizontalPadding(context);
                        } else {
                          print("con3 documents");
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                Text(
                                  AppLocalizations.of(context)!.requestDocuments,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  height:3, width: 10,
                                  decoration:  BoxDecoration(color: RevmoColors.originalBlue, borderRadius: BorderRadius.circular(20)),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.documents.length,
                                  itemBuilder: (context, index) {
                                    return InsertPhotosCard(
                                      doc: viewModel.documents[index],
                                      id: viewModel.documents[index].id,
                                      color: Colors.black,
                                      title: viewModel.documents[index].title,
                                      description:
                                      viewModel.documents[index].note,
                                      startUploadText: AppLocalizations.of(context)!.upload,
                                      showAddAfterAdding: true,
                                      onAddPhotoPressed: () {},
                                      onDeletePhotoPressed: (index) {},
                                    );
                                  },
                                  shrinkWrap: true,
                                )
                              ],
                            ).setPageHorizontalPadding(context);
                        }
                      } else {
                        return SizedBox(
                            height: mediaQuery.size.height * 0.7,
                            child: Center(child: const CircularProgressIndicator()));
                      }
                    }),
                const SizedBox(height: 25,),
                FutureBuilder(
                    future: viewModel.getDocsFuture,
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.done) {
                        print("con1 sellerDocuments");
                        if (viewModel.sellerDocuments.isEmpty) {
                          print("con2 sellerDocuments");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Text(
                                AppLocalizations.of(context)!.yourUploadedDocuments,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                height:3, width: 20,
                                decoration:  BoxDecoration(color: RevmoColors.originalBlue, borderRadius: BorderRadius.circular(20)),
                              ),
                              const SizedBox(height: 30,),
                              const   Center(
                                child: Icon(
                                  Iconsax.timer_14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10,),

                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noDocumentsUploadedYet,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ).setPageHorizontalPadding(context);

                        } else {
                          print("con3 sellerDocuments");

                          return
                            // Center(child: Text("no Data", style: TextStyle(color: Colors.black),));
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),

                                SizedBox(height: 10,),
                                Text(
                                  AppLocalizations.of(context)!.yourUploadedDocuments,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  height:3, width: 10,
                                  decoration:  BoxDecoration(color: RevmoColors.originalBlue, borderRadius: BorderRadius.circular(20)),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.sellerDocuments.length,
                                  itemBuilder: (context, index) {
                                    return InsertPhotosCard(
                                      doc: viewModel.sellerDocuments[index],
                                      id: viewModel.sellerDocuments[index].id,
                                      color: Colors.black,
                                      title: viewModel.sellerDocuments[index].title,
                                      description:
                                      viewModel.sellerDocuments[index].note,
                                      startUploadText: AppLocalizations.of(context)!.upload,
                                      showAddAfterAdding: true,
                                      onAddPhotoPressed: () {},
                                      onDeletePhotoPressed: (index) {},
                                    );
                                  },
                                  shrinkWrap: true,
                                )
                              ],
                            ).setPageHorizontalPadding(context);
                        }
                      } else {
                        return Container();
                      }
                    }),
                const SizedBox(height: 30,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
