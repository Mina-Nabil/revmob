import 'package:flutter/material.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';

class UserCard extends StatelessWidget {
  final Seller seller;
  const UserCard(this.seller);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserImage(seller, 64),
        SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 25,
          child: RevmoTheme.getTitle(seller.fullName),
        ),
        SizedBox(
          height: 5,
        ),
        if (seller.showroom != null)
          SizedBox(
            height: 25,
            child: RevmoTheme.getCaption(seller.showroom!.name, 1),
          ),
      ],
    );
  }
}
