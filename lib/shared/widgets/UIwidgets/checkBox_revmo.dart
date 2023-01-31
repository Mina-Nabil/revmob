import 'package:flutter/material.dart';


class CheckBoxMickeyRevmo extends StatelessWidget {
  final double _diameter = 24;
  final bool isSelected;
  final Function()? onTap;
  const CheckBoxMickeyRevmo({required bool initialValue, Function()? onTap})
      : isSelected = initialValue,
        onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
      AnimatedContainer(
        duration:
        const Duration(milliseconds: 500),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff167A5D)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                color: Colors.transparent)
                : Border.all(
                color: Colors.grey.shade400),
            borderRadius:
            BorderRadius.circular(3)),
        child: Center(
          child: Icon(
            Icons.check,
            color: isSelected ==
                false
                ? Colors.grey
                : Colors.white,
            size: 15,
          ),
        ),
      ),


      // Container(
      //   decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       border: Border.all(color: RevmoColors.originalBlue),
      //       color: (isSelected) ? RevmoColors.originalBlue : Colors.white),
      //   width: _diameter,
      //   alignment: Alignment.center,
      //   padding: const EdgeInsets.all(1),
      //   child: const FittedBox(
      //     child: Icon(
      //       Icons.check,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }
}
