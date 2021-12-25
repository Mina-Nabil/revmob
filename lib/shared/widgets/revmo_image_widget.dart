import 'package:flutter/material.dart';
import 'package:revmo/models/revmo_image.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/revmo_image_placeholder.dart';

class RevmoCarImageWidget extends StatelessWidget {
  const RevmoCarImageWidget({
    required this.revmoImage,
    required double imageHeight,
    required double imageWidth,
  })  : _imageHeight = imageHeight,
        _imageWidth = imageWidth;

  final RevmoCarImage revmoImage;
  final double _imageHeight;
  final double _imageWidth;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      revmoImage.url,
      height: _imageHeight,
      cacheHeight: _imageHeight.toInt(),
      width: _imageWidth,
      cacheWidth: _imageWidth.toInt(),
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return RevmoImagePlaceholder(height: _imageHeight, width: _imageWidth);
      },
      loadingBuilder: (context, child, progress) {
        return (progress != null)
            ? Container(
                height: _imageHeight,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    RevmoImagePlaceholder(height: _imageHeight, width: _imageWidth),
                    Container(
                      width: _imageWidth - 5,
                      padding: EdgeInsets.only(bottom: 5),
                      margin: EdgeInsets.all(2.0), //must match ShopImagePlaceholder
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: LinearProgressIndicator(
                          backgroundColor: RevmoColors.originalBlue.withAlpha((255 * 0.3).toInt()),
                          color: RevmoColors.darkBlue,
                          value: (progress.cumulativeBytesLoaded / progress.expectedTotalBytes!.toDouble()),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.all(2.0), //must match ShopImagePlaceholder child;
                child: child);
      },
    );
  }
}
