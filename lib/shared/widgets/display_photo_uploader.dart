import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/revmo_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisplayPhotoUploader extends StatefulWidget {
  final double _pickerPlaceholderWidth = 175;
  final double _cameraLogoPadding = 60;
  final ValueNotifier<File?> _selectedImage;
  const DisplayPhotoUploader(this._selectedImage);

  @override
  _DisplayPhotoUploaderState createState() => _DisplayPhotoUploaderState();
}

class _DisplayPhotoUploaderState extends State<DisplayPhotoUploader> {
  String? lastUploadedImagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: widget._pickerPlaceholderWidth,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(
                color: RevmoColors.cyan,
              ),
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
                        : Container(
                            color: RevmoColors.lightBlue,
                            padding: EdgeInsets.symmetric(horizontal: widget._cameraLogoPadding),
                            child: SvgPicture.asset(Paths.cameraSVG, color: RevmoColors.cyan),
                          ),
                  )),
                ),
              ],
            ),
          ),
        ),
        Center(
            child: RevmoIconButton(
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
                  borderRadius:
                      new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
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
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
      return await ImageCropper.cropImage(
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
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(AppLocalizations.of(context)!.reuploadMsg)));
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
