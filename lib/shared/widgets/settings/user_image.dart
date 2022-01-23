import 'package:flutter/material.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/accounts/showroom.dart';
import 'package:revmo/shared/colors.dart';

class UserImage extends StatelessWidget {
  final Seller? seller;
  final Showroom? showroom;
  final double radius;
  final bool isShowroom;
  const UserImage(Seller this.seller, this.radius)
      : showroom = null,
        isShowroom = false;
  const UserImage.showroom(Showroom this.showroom, this.radius)
      : seller = null,
        isShowroom = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(shape: BoxShape.circle, color: RevmoColors.lightBlue),
      child: ((!isShowroom && seller!.image != null) || (isShowroom && showroom!.image != null))
          ? Image.network(
              (isShowroom) ? showroom!.image! : seller!.image!,
              height: radius,
              width: radius,
              cacheHeight: radius.toInt(),
              cacheWidth: radius.toInt(),
              errorBuilder: (cnxt, _, __) => Icon(
                (isShowroom) ? Icons.car_repair_sharp : Icons.person,
                color: Colors.white,
              ),
            )
          : Icon(
              (isShowroom) ? Icons.car_repair_sharp : Icons.person,
              color: Colors.white,
            ),
    );
  }
}
