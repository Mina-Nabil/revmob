import 'package:flutter/material.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/screens/catalog/model_colors_selection_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_checkbox.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';

class ModelColorSelector extends StatefulWidget {
  final ModelColor modelColor;
  final Car car;
  final ValueNotifier<bool> isSelected;

  const ModelColorSelector({required this.car, required this.modelColor, required this.isSelected});

  @override
  _ModelColorSelectorState createState() => _ModelColorSelectorState();
}

class _ModelColorSelectorState extends State<ModelColorSelector> {
  final double _imageWidth = 150;
  final double _tileHeight = 100;
  final double _imageHeight = 70;
  final double _colorTextHeight = 16;
  late final double _checkboxHeight;

  toggleColorFunc(context, color) {
    ModelColorsSelectionWidget.of(context).toggleColor(widget.car, color);
    setState(() {
      widget.isSelected.value = !widget.isSelected.value;
    });
  }

  @override
  void initState() {
    _checkboxHeight = _imageHeight - _colorTextHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _imageWidth,
      height: _tileHeight,
      color: Colors.transparent,
      child: Column(
        children: [
          //Image Container
          GestureDetector(
              onTap: () => toggleColorFunc(context, widget.modelColor),
              child: Container(
                width: _imageWidth,
                height: _imageHeight,
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: RevmoCarImageWidget(
                  revmoImage: widget.modelColor.revmoImage,
                  imageHeight: _imageHeight,
                  imageWidth: _imageWidth,
                ),
              )),

          Container(
            height: _colorTextHeight,
            padding: EdgeInsets.only(top: 2),
            child: FittedBox(
              child: RevmoTheme.getBody(widget.modelColor.name, 1, color: RevmoColors.darkBlue),
            ),
          ),

          Container(
              height: _checkboxHeight,
              alignment: Alignment.center,
              child: RevmoCheckbox(
                initialValue: widget.isSelected.value,
                onTap: () => toggleColorFunc(context, widget.modelColor),
              ))
        ],
      ),
    );
  }
}
