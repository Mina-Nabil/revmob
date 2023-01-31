import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: non_constant_identifier_names
Widget CustomCachedImageNetwork(
    {required String imageUrl,
      double padding = 0,
      double errorPadding = 0,
      double height = 20,
      double errorSize = 30,
      Widget error = const Icon(Icons.error)}) {
  return SizedBox(
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        // placeholder: (context, url) => SizedBox(
        //   height: height,
        //   child: Padding(
        //     padding: EdgeInsets.only(right: padding),
        //     child: Lottie.asset('assets/images/loading.json',
        //         frameRate: FrameRate.composition, repeat: true),
        //   ),
        // ),
        errorWidget: (context, url, error) => Padding(
          padding:  EdgeInsets.only(right: errorPadding,left: errorPadding),
          child: Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: errorSize,
          ),
        ),
      ));
}
