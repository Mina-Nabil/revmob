import 'package:flutter/material.dart';
import 'package:revmo/models/brand.dart';
import 'package:revmo/screens/catalog/brand_models_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class BrandTile extends StatelessWidget {
  //dimensions
  final Brand? b;
  final bool isPlaceholder;
  const BrandTile(Brand b)
      : this.b = b,
        isPlaceholder = false;
  const BrandTile.placeholder()
      : isPlaceholder = true,
        b = null;

  final double _tileWidth = 110;
  final double _tileHeight = 74;
  final double _borderRadius = 5;
  final double _horizontalPadding = 20;
  final double _verticalPadding = 15;
  final double _textIconSpacing = 15;
  final double _bottomPadding = 14;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isPlaceholder) Navigator.pushNamed(context, BrandModelsScreen.ROUTE_NAME, arguments: b);
      },
      child: (isPlaceholder)
          ? Shimmer.fromColors(
              baseColor: RevmoColors.baseShimmer,
              highlightColor: RevmoColors.highlightShimmer,
              enabled: isPlaceholder,
              child: Container(
                  width: _tileWidth,
                  height: _tileHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
                    color: Colors.white,
                  )))
          : Container(
              width: _tileWidth,
              height: _tileHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: _horizontalPadding, right: _horizontalPadding, top: _verticalPadding),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: (isPlaceholder)
                              ? Container()
                              : Image.network(
                                  b!.logoURL,
                                  errorBuilder: (context, exception, _)  =>  RevmoImagePlaceholder(height: _tileHeight, width: _tileWidth),
                                  fit: BoxFit.fitWidth,
                                ),
                        )),
                  ),
                  SizedBox(
                    height: _textIconSpacing,
                  ),
                  FittedBox(
                    child: RevmoTheme.getSemiBold((isPlaceholder) ? " " : b!.name, 1, color: RevmoColors.darkBlue),
                  ),
                  SizedBox(
                    height: _bottomPadding,
                  ),
                ],
              )),
    );
  }
}
