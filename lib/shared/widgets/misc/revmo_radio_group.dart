import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoRadioGroupRow extends StatefulWidget {
  final List<String> options;
  final ValueNotifier<int> value;
  final Color labelColor;
  final Function(int?)? onValueChange;
  const RevmoRadioGroupRow(this.options, this.value, {this.onValueChange, this.labelColor = RevmoColors.darkBlue});

  @override
  State<RevmoRadioGroupRow> createState() => _RevmoRadioGroupRowState();
}

class _RevmoRadioGroupRowState extends State<RevmoRadioGroupRow> {
  @override
  Widget build(BuildContext context) {
    int i = 0;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.options
            .map((e) => Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<int>(
                          visualDensity: VisualDensity.compact,
                          fillColor: MaterialStateProperty.all(RevmoColors.originalBlue),
                          value: i++,
                          groupValue: widget.value.value,
                          toggleable: true,
                          onChanged: (val) {
                            if (val != null)
                              setState(() {
                                widget.value.value = val;
                                if (widget.onValueChange != null) widget.onValueChange!(val);
                              });
                          }),
                      RevmoTheme.getBody(e, 1, color: RevmoColors.darkBlue)
                    ],
                  ),
                ))
            .toList());
  }
}
