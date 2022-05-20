import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoTextField extends StatefulWidget {
  final double _fieldMargin = 10;

  final TextEditingController controller;
  final String title;
  final String? hintText;
  final String? prefixText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool validateOnChange;
  final GlobalKey<FormFieldState>? fieldKey;
  final Function(String)? onChangeValidation;
  final int maxLines;
  final TextInputType keyboardType;
  final Function()? onEditingComplete;
  final bool darkMode;

  const RevmoTextField(
      {required this.controller,
      required this.title,
      this.hintText,
      this.validator,
      this.obscureText = false,
      this.prefixText,
      this.onChangeValidation,
      this.fieldKey,
      this.maxLines = 1,
      this.validateOnChange = false,
      this.darkMode = true,
      this.keyboardType = TextInputType.text,
      this.onEditingComplete});

  @override
  State<RevmoTextField> createState() => _RevmoTextFieldState();
}

class _RevmoTextFieldState extends State<RevmoTextField> {
  final GlobalKey<FormFieldState> _fieldKey = new GlobalKey<FormFieldState>();

  bool isObscureState = false;

  @override
  void initState() {
    isObscureState = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: widget._fieldMargin),
              child: RevmoTheme.getTextFieldLabel(widget.title, color: (widget.darkMode) ? Colors.white : RevmoColors.darkBlue)),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              FocusScope(
                onFocusChange: (widget.onEditingComplete != null) ? (_) => widget.onEditingComplete!() : null,
                child: TextFormField(
                  key: widget.fieldKey,
                  validator: widget.validator,
                  obscureText: isObscureState,
                  onChanged: (widget.validateOnChange)
                      ? (_) {
                          (widget.fieldKey != null)
                              ? widget.fieldKey?.currentState?.validate()
                              : _fieldKey.currentState?.validate();
                        }
                      : widget.onChangeValidation,
                  style: RevmoTheme.getBodyStyle(1, color: RevmoColors.darkBlue),
                  decoration: InputDecoration(
                    suffixIcon: (widget.obscureText)
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isObscureState = !isObscureState;
                              });
                            },
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: (isObscureState) ? Colors.grey : RevmoColors.darkBlue,
                            ))
                        : null,
                    prefixText: widget.prefixText,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: widget.hintText,
                    errorStyle: TextStyle(color: (widget.darkMode) ? RevmoColors.yellow : RevmoColors.darkRed),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(color: (widget.darkMode) ? RevmoColors.yellow : RevmoColors.darkRed)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(color: (widget.darkMode) ? RevmoColors.yellow : RevmoColors.darkRed, width: 2)),
                    hintStyle: TextStyle(color: RevmoColors.greyishBlue),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide:
                            (widget.darkMode) ? const BorderSide() : const BorderSide(color: RevmoColors.grey, width: .25)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide:
                            (widget.darkMode) ? const BorderSide() : const BorderSide(color: RevmoColors.grey, width: .25)),
                  ),
                  controller: widget.controller,
                  maxLines: widget.maxLines,
                  keyboardAppearance: Brightness.light,
                  keyboardType: widget.keyboardType,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
