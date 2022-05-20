import 'package:flutter/material.dart';
import 'revmo_image.dart';

class ModelColor {
  static const String API_id_Key = "id";
  static const String API_color_red_Key = "COLR_RED";
  static const String API_color_blue_Key = "COLR_BLUE";
  static const String API_color_green_Key = "COLR_GREN";
  static const String API_color_hex_Key = "COLR_HEX";
  static const String API_color_alpha_Key = "COLR_ALPH";
  static const String API_name_Key = "COLR_NAME";
  static const String API_arbcName_Key = "COLR_ARBC_NAME";
  static const String API_image_Key = "image_url";

  int _id;
  String _name;
  String _arbcName;
  Color _color;
  // Color? _hexColor;
  String _imageUrl;
  RevmoCarImage _revmoImage;

  ModelColor.fromJson(Map<String, dynamic> json)
      : _id = json[API_id_Key],
        _name = json[API_name_Key],
        _arbcName = json[API_arbcName_Key],
        _color =
            Color.fromARGB(json[API_color_alpha_Key], json[API_color_red_Key], json[API_color_green_Key], json[API_color_blue_Key]),
        _imageUrl = json[API_image_Key],
        _revmoImage = RevmoCarImage(imageURL: json[API_image_Key], sortingValue: 500, isModelImage: true);

  int get id => _id;
  String get name => _name;
  String get arbcName => _arbcName;
  Color get color => _color;
  String get imageUrl => _imageUrl;
  RevmoCarImage get revmoImage => _revmoImage;
  // Color? get hexColor => _hexColor;

  operator ==(other) {
    if (other is ModelColor) {
      if (other.hashCode == this.hashCode) return true;
    }
    return false;
  }

  String toString() => name;

  int get hashCode => _color.hashCode * _name.hashCode;
}
