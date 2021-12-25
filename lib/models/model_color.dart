import 'package:flutter/material.dart';

class ModelColor {
  static const String DB_color_red_KEY = "COLR_RED";
  static const String DB_color_blue_KEY = "COLR_BLUE";
  static const String DB_color_green_KEY = "COLR_GREN";
  static const String DB_color_hex_KEY = "COLR_HEX";
  static const String DB_color_alpha_KEY = "COLR_ALPH";
  static const String DB_name_KEY = "COLR_NAME";
  static const String DB_arbcName_KEY = "COLR_ARBC_NAME";
  static const String DB_image_KEY = "COLR_IMGE";

  String _name;
  String _arbcName;
  Color _color;
  // Color? _hexColor;
  String? _imageUrl;

  ModelColor.fromJson(Map<String, dynamic> json)
      : _name = json[DB_name_KEY],
        _arbcName = json[DB_arbcName_KEY],
        _color =
            Color.fromARGB(json[DB_color_alpha_KEY], json[DB_color_red_KEY], json[DB_color_green_KEY], json[DB_color_blue_KEY]),
        _imageUrl = json[DB_image_KEY];

  String get name => _name;
  String get arbcName => _arbcName;
  Color get color => _color;
  String? get imageUrl => _imageUrl;
  // Color? get hexColor => _hexColor;

}
