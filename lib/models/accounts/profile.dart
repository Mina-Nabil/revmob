import 'package:revmo/models/accounts/showroom.dart';

abstract class Profile {
  String get fullName;
  String get initials;
  String get email;
  String get mob;
  String? get image;
  Showroom? get showroom;
}
