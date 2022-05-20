import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoMultiSelect<T> extends StatefulWidget {
  final String title;
  final Map<int, T> items;
  final String hint;
  final ValueNotifier<List<int>> selectedItems;
  final bool darkMode;
  final String? Function(List<T?>?)? validator;
  const RevmoMultiSelect(
      {required this.items,
      required this.title,
      required this.hint,
      required this.selectedItems,
      this.darkMode = true,
      this.validator});

  @override
  _RevmoMultiSelectState createState() => _RevmoMultiSelectState();
}

class _RevmoMultiSelectState  extends State<RevmoMultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(vertical: RevmoTheme.FIELDS_VER_MARGIN),
          child: RevmoTheme.getTextFieldLabel(widget.title, color: (widget.darkMode) ? Colors.white : RevmoColors.darkBlue)),
      ValueListenableBuilder<List<int>>(
        valueListenable: widget.selectedItems,
        builder: (context, updatedItems, _) {
          print(updatedItems);
          
          return MultiSelectChipField(
            items: widget.items.entries.map((e) => MultiSelectItem(e.key, e.value.toString())).toList(),
            showHeader: false,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.fromBorderSide(
                    (widget.darkMode) ? const BorderSide() : const BorderSide(color: RevmoColors.darkGrey, width: .25))),
            initialValue: updatedItems,
            validator: widget.validator,
            
            title: RevmoTheme.getBody(widget.hint, 1),
            itemBuilder: chipBuilder,
            textStyle: RevmoTheme.getBodyStyle(1, color: RevmoColors.darkBlue),
          
          );
        }
      ),
    ]));
  }

  Widget chipBuilder(MultiSelectItem<int?> selectItem, FormFieldState<List<int?>> formState) {
    bool isSelected = (formState.value != null) && (formState.value!.contains(selectItem.value));
    toggleItem() {
      if (isSelected) {
        setState(() {
          formState.value!.remove(selectItem.value);
        });
      } else {
        setState(() {
          formState.value!.add(selectItem.value);
        });
      }
    }

    return GestureDetector(
      onTap: toggleItem,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,

        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            boxShadow: isSelected
                ? [
                    BoxShadow(color: Colors.grey[500]!, offset: const Offset(4, 4), blurRadius: 15, spreadRadius: 1),
                    BoxShadow(color: Colors.white, offset: const Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
                  ]
                : null,
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: RevmoTheme.getBody(selectItem.label, 1, color: RevmoColors.darkBlue),
      ),
    );
  }
}
