import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../misc/revmo_text_icon_button.dart';

class PhotoUploader extends StatefulWidget {
  final double _pickerPlaceholderWidth = 175;
  final double _cameraLogoPadding = 60;
  final ValueNotifier<File?> _selectedImage;

  const PhotoUploader(
    this._selectedImage,
  );

  @override
  _PhotoUploaderState createState() => _PhotoUploaderState();
}

class _PhotoUploaderState extends State<PhotoUploader> {
  String? lastUploadedImagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: widget._pickerPlaceholderWidth,
            decoration: BoxDecoration(
              // color: Colors.red,
              shape: BoxShape.circle,
              // border: Border.all(
              //   color: RevmoColors.cyan,
              // ),
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipOval(
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child: widget._selectedImage.value != null
                              ? GestureDetector(
                                  onTap: cropThenSetImage,
                                  child: Image.file(
                                    widget._selectedImage.value!,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle_rounded,
                                  size: widget._pickerPlaceholderWidth,
                                  color: const Color(0xffb7bac6),
                                ))),
                ),
              ],
            ),
          ),
        ),
        Center(
            child: RevmoTextIconButton(
              color: Colors.white,
                iconWidget: SvgPicture.asset(
                  Paths.cameraSVG,
                  color: RevmoColors.cyan,
                ),
                width: widget._pickerPlaceholderWidth,
                text: AppLocalizations.of(context)!.addPhoto,
                callback: _addProfilePicture)),
      ],
    );
  }

  void _addProfilePicture() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
              decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_upload,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upload Photo",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10, bottom: 20),
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Take Photo",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        getImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ));
        });
  }

  getImage(ImageSource source) async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      lastUploadedImagePath = image.path;
      await cropThenSetImage();
    }
  }

  Future<File?> cropImage() async {
    if (lastUploadedImagePath != null)
      return await ImageCropper().cropImage(
          sourcePath: lastUploadedImagePath!,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(),
          iosUiSettings: IOSUiSettings(
            showCancelConfirmationDialog: true,
          ));
    else
      RevmoTheme.showRevmoSnackbar(
          context, AppLocalizations.of(context)!.reuploadMsg);
  }

  setImage(File? image) {
    if (image != null) {
      setState(() {
        widget._selectedImage.value = image;
      });
    }
  }

  Future<void> cropThenSetImage() async {
    File? croppedImage = await cropImage();
    setImage(croppedImage);
  }
}

class SignUpUpload extends StatefulWidget {
  final double _pickerPlaceholderWidth = 175;
  final double _cameraLogoPadding = 60;
  final ValueNotifier<File?> _selectedImage;

  const SignUpUpload(this._selectedImage);

  @override
  _SignUpUploadState createState() => _SignUpUploadState();
}

class _SignUpUploadState extends State<SignUpUpload> {
  String? lastUploadedImagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget._pickerPlaceholderWidth,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xfff3f4f6)),
          child: ClipOval(
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: widget._selectedImage.value != null
                      ? GestureDetector(
                          onTap: cropThenSetImage,
                          child: Image.file(
                            widget._selectedImage.value!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Icon(
                          Icons.account_circle_rounded,
                          size: widget._pickerPlaceholderWidth,
                          color: const Color(0xffb7bac6),
                        ))),
        ),
        // const SizedBox(
        //   height: 20,
        // ),

        // Center(
        //   child: Container(
        //     height: widget._pickerPlaceholderWidth,
        //     decoration: BoxDecoration(
        //       color: Colors.transparent,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.1),
        //           spreadRadius: 3,
        //           blurRadius: 5,
        //         )
        //       ],
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         width: 0.5,
        //         color: const Color(0xff26AEE4),
        //       ),
        //     ),
        //     child: Stack(
        //       children: [
        //         Center(
        //           child: ClipOval(
        //               child: AspectRatio(
        //                 aspectRatio: 1.0,
        //                 child: widget._selectedImage.value != null
        //                     ? GestureDetector(
        //                   onTap: cropThenSetImage,
        //                   child: Image.file(
        //                     widget._selectedImage.value!,
        //                     fit: BoxFit.fill,
        //                   ),
        //                 )
        //                     : Container(
        //                   color: RevmoColors.lightBlue,
        //                   padding: EdgeInsets.symmetric(horizontal: widget._cameraLogoPadding),
        //                   child: SvgPicture.asset(Paths.cameraSVG, color: RevmoColors.cyan),
        //                 ),
        //               )),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Center(
        //     child: RevmoTextIconButton(
        //         iconWidget: SvgPicture.asset(
        //           Paths.cameraSVG,
        //           color: RevmoColors.cyan,
        //         ),
        //         width: widget._pickerPlaceholderWidth,
        //         text: 'addPhoto',
        //         callback: _addProfilePicture)),

        ElevatedButton(
            onPressed: _addProfilePicture, child: const Text('Upload Image'))
      ],
    );
  }

  void _addProfilePicture() {
    getImage(ImageSource.gallery);

    // showModalBottomSheet(
    //
    //     backgroundColor: Colors.transparent,
    //     context: context,
    //     builder: (_) {
    //       return Container(
    //           padding: const EdgeInsets.all(10),
    //           height: MediaQuery.of(context).size.height * 0.2,
    //           decoration: const BoxDecoration(
    //               color: Colors.white,
    //               borderRadius:
    //               BorderRadius.only(topLeft:  Radius.circular(25.0), topRight:  Radius.circular(25.0))),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //
    //               ListTile(
    //                 leading:  const Icon(
    //                   Icons.file_upload,
    //                   size: 20,
    //                   color: Colors.black,
    //                 ),
    //                 title:const Text(
    //                   "Upload Photo",
    //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //                 ),
    //                 onTap: (){
    //                   getImage(ImageSource.gallery);
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //               ListTile(
    //                 leading:  const Icon(
    //                   Icons.camera_alt,
    //                   size: 20,
    //                   color: Colors.black,
    //                 ),
    //                 title:const Text( "Take Photo",
    //
    //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //                 ),
    //                 onTap: (){
    //                   getImage(ImageSource.gallery);
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           ));
    //     });
  }

  getImage(ImageSource source) async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      lastUploadedImagePath = image.path;
      await cropThenSetImage();
    }
  }

  Future<File?> cropImage() async {
    if (lastUploadedImagePath != null) {
      return await ImageCropper().cropImage(
          sourcePath: lastUploadedImagePath!,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: const AndroidUiSettings(),
          iosUiSettings: const IOSUiSettings(
            showCancelConfirmationDialog: true,
          ));
    } else {
      // ToastService.showErrorToast("reUpload message");
    }
  }

  setImage(File? image) {
    if (image != null) {
      setState(() {
        widget._selectedImage.value = image;
      });
    }
  }

  Future<void> cropThenSetImage() async {
    File? croppedImage = await cropImage();
    setImage(croppedImage);
  }
}
