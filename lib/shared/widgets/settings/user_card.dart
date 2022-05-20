import 'package:flutter/material.dart';
import 'package:revmo/models/accounts/profile.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';

class UserCard extends StatelessWidget {
  final Profile profile;
  final double _imageDiameter;
  const UserCard(this.profile, {double imageDiameter=64}) : _imageDiameter=imageDiameter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserImage(profile, _imageDiameter, fallbackTiInitials: false,),
        SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 25,
          child: RevmoTheme.getTitle(profile.fullName),
        ),
        SizedBox(
          height: 5,
        ),
        if (profile.showroom != null)
          SizedBox(
            height: 25,
            child: RevmoTheme.getCaption(profile.showroom!.fullName, 1),
          ),
      ],
    );
  }
}
