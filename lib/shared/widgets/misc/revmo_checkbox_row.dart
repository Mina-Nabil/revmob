import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoCheckboxRow extends StatefulWidget {
  final String label;
  final ValueNotifier<bool> value;
  final Color labelColor;
  const RevmoCheckboxRow(this.label, this.value, {this.labelColor = RevmoColors.darkBlue});

  @override
  State<RevmoCheckboxRow> createState() => _RevmoCheckboxRowState();
}

class _RevmoCheckboxRowState extends State<RevmoCheckboxRow> {
  toggleCheckbox() {
    setState(() {
      widget.value.value = !widget.value.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCheckbox,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration:
                  BoxDecoration(border: Border.all(color: RevmoColors.grey), borderRadius: BorderRadius.all(Radius.circular(2))),
              child: Checkbox(
                  fillColor: MaterialStateProperty.all((widget.value.value) ? RevmoColors.darkBlue : Colors.white),
                  value: widget.value.value,
                  onChanged: (bool? val) {
                    setState(() {
                      widget.value.value = val ?? false;
                    });
                  }),
            ),
            SizedBox(
              width: 5,
            ),
            RevmoTheme.getBody(widget.label, 1, color: widget.labelColor)
          ],
        ),
      ),
    );
  }
}
