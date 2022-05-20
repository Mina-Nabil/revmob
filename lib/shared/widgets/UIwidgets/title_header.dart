import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
