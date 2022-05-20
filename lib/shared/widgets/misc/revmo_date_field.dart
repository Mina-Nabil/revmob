import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_date_picker.dart';

class RevmoDateField extends StatefulWidget {
  final double _fieldMargin = 10;

  final TextEditingController controller;
  final String title;
  final String? hintText;
  final String? prefixText;
  final String? Function(String?)? validator;
  final GlobalKey<FormFieldState>? fieldKey;
  final bool validateOnChange;
  final Function(String)? onChangeValidation;
  final Function()? onEditingComplete;
  final bool darkMode;
  final DateTime? defaultValue;

  const RevmoDateField(
      {required this.controller,
      required this.title,
      this.hintText,
      this.validator,
      this.validateOnChange = false,
      this.prefixText,
      this.onChangeValidation,
      this.fieldKey,
      this.darkMode = true,
      this.defaultValue,
      this.onEditingComplete});

  @override
  State<RevmoDateField> createState() => _RevmoDateFieldState();
}

class _RevmoDateFieldState extends State<RevmoDateField> {
  final GlobalKey<FormFieldState> _fieldKey = new GlobalKey<FormFieldState>();

  bool isObscureState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultValue != null) widget.controller.text = DateFormat('dd-MMM-y').format(widget.defaultValue!);
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
                    readOnly: true,
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
                      prefixText: widget.prefixText,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: widget.hintText,
                      errorStyle: TextStyle(color: RevmoColors.yellow),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)), borderSide: BorderSide(color: RevmoColors.yellow)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          borderSide: BorderSide(color: RevmoColors.yellow, width: 2)),
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
                    keyboardAppearance: Brightness.light,
                    onTap: () {
                      DatePicker.showPicker(context,
                          showTitleActions: true,
                          pickerModel: RevmoDatePicker(currentTime: DateTime.now()),
                          theme: DatePickerTheme(
                              headerColor: RevmoColors.greyishBlue,
                              backgroundColor: RevmoColors.white,
                              itemStyle: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 18),
                              doneStyle: TextStyle(color: RevmoColors.darkBlue, fontSize: 16)), onChanged: (date) {
                        widget.controller.value = TextEditingValue(text: DateFormat('dd-MMM-y').format(date));
                      }, onConfirm: (date) {
                        widget.controller.value = TextEditingValue(text: DateFormat('dd-MMM-y').format(date));
                      });
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
