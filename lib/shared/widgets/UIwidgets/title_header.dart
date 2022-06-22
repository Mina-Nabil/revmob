import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({Key? key, required this.title , this.color = Colors.white}) : super(key: key);
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18, color: color),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
