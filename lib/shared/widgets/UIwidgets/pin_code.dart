import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:revmo/shared/colors.dart';

class PinPutCode extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? callback;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  const PinPutCode(
      {Key? key,
      this.callback,
      this.controller,
      this.onCompleted,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width:0.5, color: RevmoColors.cyan
            // bottom: BorderSide(width: 0.5, color: RevmoColors.cyan),
          ),
        ),
    );



    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white.withOpacity(0.3)
        // color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    const borderColor = Colors.black;
    final cursor = Stack(
      alignment: Alignment.center,
      children: [
        Container(
   decoration:   BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width:0.5, color: RevmoColors.cyan
            ),
          ),

        ),
        Text("|", style: TextStyle(fontSize: 22, color: Colors.white),)
      ],
    );

    // Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     const Text(
    //       '|',
    //       style: TextStyle(color: Colors.white, fontSize: 24),
    //     ),
    //     SizedBox(height: 10,),
    //     Container(
    //       width: 56,
    //       height: 1,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //   ],
    // );
    // final preFilledWidget = Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     Container(
    //       width: 56,
    //       height: 1,
    //       decoration: BoxDecoration(
    //         color: Colors.white.withOpacity(0.2),
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //   ],
    // );
    return Pinput(
      controller: controller,
      enabled: !enabled,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
      // listenForMultipleSmsOnAndroid: true,
      length: 4,
      defaultPinTheme: defaultPinTheme,
      // focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp("[0123456789]"),
        ),
      ],
      pinAnimationType: PinAnimationType.fade,
      validator: (s) {},
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      cursor: cursor,
      separator: const SizedBox(width: 12,),
      // preFilledWidget: preFilledWidget,
      // const Text(
      //   '|',
      //   style: TextStyle(color: Colors.black, fontSize: 18),
      // ),
      onCompleted: onCompleted,
    );
  }
}
