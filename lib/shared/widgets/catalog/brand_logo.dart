import 'package:flutter/material.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';

class BrandLogo extends StatelessWidget {
  final Brand _brand;
  final double _width;
  final double _height;
  const BrandLogo(this._brand, this._width, this._height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      alignment: Alignment.center,
      child: Image.network(
        _brand.logoURL,
        errorBuilder: (context, exception, _) => RevmoImagePlaceholder(height: _height, width: _width),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
