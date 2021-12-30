import 'package:flutter/material.dart';
import 'package:revmo/models/model_color.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_checkbox.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_placeholder.dart';
import 'package:revmo/shared/widgets/misc/revmo_image_widget.dart';

class ModelColorSelector extends StatefulWidget {
  final ModelColor modelColor;
  final ValueNotifier<bool> isSelected;

  const ModelColorSelector({required this.modelColor, required this.isSelected});

  @override
  _ModelColorSelectorState createState() => _ModelColorSelectorState();
}

class _ModelColorSelectorState extends State<ModelColorSelector> {
  final double _imageWidth = 150;
  final double _tileHeight = 100;
  final double _imageHeight = 70;
  final double _colorTextHeight = 16;
  late final double _checkboxHeight;

  toggleValue() {
    if (widget.isSelected.value) {
      setState(() {
        widget.isSelected.value = false;
      });
    } else {
      setState(() {
        widget.isSelected.value = true;
      });
    }
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
              onTap: toggleValue,
              child: Container(
                width: _imageWidth,
                height: _imageHeight,
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: (widget.modelColor.imageUrl != null)
                    ? RevmoCarImageWidget(
                        revmoImage: widget.modelColor.revmoImage,
                        imageHeight: _imageHeight,
                        imageWidth: _imageWidth,
                      )
                    : RevmoImagePlaceholder(height: _imageHeight, width: _imageWidth),
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
                onTap: toggleValue,
              ))
        ],
      ),
    );
  }
}
