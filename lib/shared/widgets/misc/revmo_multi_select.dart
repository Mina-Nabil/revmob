import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoMultiSelectt<T> extends StatefulWidget {
  final String title;
  final Map<int, T> items;
  final String hint;
  final ValueNotifier<List<int>> selectedItems;
  final bool darkMode;
  final String? Function(List<T?>?)? validator;

  const RevmoMultiSelectt(
      {required this.items,
      required this.title,
      required this.hint,
      required this.selectedItems,
      this.darkMode = true,
      this.validator});

  @override
  _RevmoMultiSelecttState createState() => _RevmoMultiSelecttState();
}

class _RevmoMultiSelecttState extends State<RevmoMultiSelectt> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Container(
              alignment: Alignment.topLeft,
              margin:
                  EdgeInsets.symmetric(vertical: RevmoTheme.FIELDS_VER_MARGIN),
              child: RevmoTheme.getTextFieldLabel(widget.title,
                  color:
                      (widget.darkMode) ? Colors.white : RevmoColors.darkBlue)),
          ValueListenableBuilder<List<int>>(
              valueListenable: widget.selectedItems,
              builder: (context, updatedItems, _) {
                print(updatedItems);

                return MultiSelectChipField(
                  items: widget.items.entries
                      .map((e) => MultiSelectItem(e.key, e.value.toString()))
                      .toList(),
                  showHeader: false,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.fromBorderSide((widget.darkMode)
                          ? const BorderSide()
                          : const BorderSide(
                              color: RevmoColors.darkGrey, width: .25))),
                  initialValue: updatedItems,
                  validator: widget.validator,
                  title: RevmoTheme.getBody(widget.hint, 1),
                  itemBuilder: chipBuilder,
                  textStyle:
                      RevmoTheme.getBodyStyle(1, color: RevmoColors.darkBlue),
                );
              }),
        ]));
  }

  Widget chipBuilder(
      MultiSelectItem<int?> selectItem, FormFieldState<List<int?>> formState) {
    bool isSelected = (formState.value != null) &&
        (formState.value!.contains(selectItem.value));
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [


          GestureDetector(
            onTap: toggleItem,
            child: Container(
              width:70,
              height: 30,
              // duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
constraints: BoxConstraints(maxWidth: 100,maxHeight: 30),
              // margin: EdgeInsets.all(10),
              // padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  // border: Border.all(color:isSelected? const Color(0xff167A5D):  RevmoColors.darkGrey, width: .25),
                  // boxShadow: isSelected
                  //     ? [
                  //         BoxShadow(color: Colors.grey[500]!, offset: const Offset(4, 4), blurRadius: 15, spreadRadius: 1),
                  //         BoxShadow(color: Colors.white, offset: const Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
                  //       ]
                  //     : null,
                  color: isSelected ? const Color(0xff167A5D) : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: RevmoTheme.getBody(selectItem.label, 1,
                  color:isSelected ?  Colors.white: RevmoColors.darkBlue),
            ),
          ),
          SizedBox(width: 5,),

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
        ],
      ),
    );
  }
}
