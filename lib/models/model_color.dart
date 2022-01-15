import 'package:flutter/material.dart';
import 'package:revmo/models/revmo_image.dart';

class ModelColor {
  static const String DB_id_KEY = "id";
  static const String DB_color_red_KEY = "COLR_RED";
  static const String DB_color_blue_KEY = "COLR_BLUE";
  static const String DB_color_green_KEY = "COLR_GREN";
  static const String DB_color_hex_KEY = "COLR_HEX";
  static const String DB_color_alpha_KEY = "COLR_ALPH";
  static const String DB_name_KEY = "COLR_NAME";
  static const String DB_arbcName_KEY = "COLR_ARBC_NAME";
  static const String DB_image_KEY = "image_url";

  int _id;
  String _name;
  String _arbcName;
  Color _color;
  // Color? _hexColor;
  String _imageUrl;
  RevmoCarImage _revmoImage;

  ModelColor.fromJson(Map<String, dynamic> json)
      : _id = json[DB_id_KEY],
        _name = json[DB_name_KEY],
        _arbcName = json[DB_arbcName_KEY],
        _color =
            Color.fromARGB(json[DB_color_alpha_KEY], json[DB_color_red_KEY], json[DB_color_green_KEY], json[DB_color_blue_KEY]),
        _imageUrl = json[DB_image_KEY],
        _revmoImage = RevmoCarImage(imageURL: json[DB_image_KEY], sortingValue: 500, isModelImage: true);

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
