import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoDropDownList extends StatefulWidget {
  final double _fieldMargin = 10;
  final String title;
  final Map<int, String> items;
  final String hint;
  final ValueNotifier<int?> selected;
  const RevmoDropDownList({required this.items, required this.title, required this.hint, required this.selected});

  @override
  _RevmoDropDownListState createState() => _RevmoDropDownListState();
}

class _RevmoDropDownListState extends State<RevmoDropDownList> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(vertical: widget._fieldMargin),
          child: RevmoTheme.getTextFieldLabel(widget.title)),
      Container(
        width: double.infinity,
        child: DropdownButtonFormField<int>(
          dropdownColor: RevmoColors.darkGrey,
          isDense: true,
          items: widget.items.entries
              .map((e) => DropdownMenuItem<int>(
                    value: e.key,
                    child: RevmoTheme.getBody(e.value, 2),
                  ))
              .toList(),
          selectedItemBuilder:  (BuildContext context) {
          return widget.items.entries.map<Widget>((e) {
            return RevmoTheme.getBody(e.value, 2, color: RevmoColors.darkBlue);
          }).toList();
          },

          value: selected,
          validator: (selected) {
            print(selected);
            if (selected == null) return "The field is required";
          },
          hint: Container(alignment: Alignment.center, child: RevmoTheme.getCaption(widget.hint, 2, color: RevmoColors.darkGrey)),
          onChanged: (int? key) {
            setState(() {
              widget.selected.value = key;
              selected = key;
            });
            print(widget.selected.value);
          },
          style: TextStyle(color: RevmoColors.darkBlue),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(color: RevmoColors.yellow),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)), borderSide: BorderSide(color: RevmoColors.yellow)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)), borderSide: BorderSide(color: RevmoColors.yellow, width: 2)),
            hintStyle: TextStyle(color: RevmoColors.greyishBlue),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
          ),
        ),
      )
    ]));
  }
}
