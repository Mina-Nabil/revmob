import 'package:flutter/material.dart';
import 'package:revmo/models/accounts/profile.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class UserImage extends StatelessWidget {
  final Profile profile;
  final double diameter;
  final bool isShowroom;
  final bool fallbackTiInitials;

  const UserImage(this.profile, this.diameter, {this.isShowroom = false, this.fallbackTiInitials = false});

  @override
  Widget build(BuildContext context) {
    Widget fallbackOption = (fallbackTiInitials)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            child: FittedBox(
              child: RevmoTheme.getBody(profile.initials, 2, color: RevmoColors.originalBlue),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(
                child: Icon(
              (isShowroom) ? Icons.car_repair_sharp : Icons.person,
              color: Colors.white,
            )));

    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, color: RevmoColors.lightBlue),
      child: (profile.image != null)
          ? Image.network(
              profile.image!,
              height: diameter,
              width: diameter,
              cacheHeight: diameter.toInt(),
              cacheWidth: diameter.toInt(),
              errorBuilder: (cnxt, _, __) => fallbackOption,
            )
          : fallbackOption,
    );
  }
}
