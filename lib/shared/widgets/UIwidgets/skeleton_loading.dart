import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final Widget? child;

  SkeletonLoading({this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 2000),
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade200,
        child: child!);
  }
}
