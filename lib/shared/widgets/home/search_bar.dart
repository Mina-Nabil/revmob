import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/theme.dart';

class SearchBar extends StatelessWidget {
  final double _barHeight;
  final TextEditingController _textController;
  final double _iconPadding = 13;
  final Function()? _searchFunction;

  bool _isUserWriting = false;

  SearchBar({required TextEditingController textEditingController, required double height, Function()? searchCallback})
      : _textController = textEditingController,
        _searchFunction = searchCallback,
        _barHeight = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _barHeight,
      decoration: BoxDecoration(color: RevmoColors.darkerBlue, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextField(
        onChanged: (_searchFunction != null)
            ? (input) async {
                if (!_isUserWriting) {
                  _isUserWriting = true;
                  await Future.delayed(Duration(seconds: 1));
                  print("abuse");
                  _searchFunction!();
                  _isUserWriting = false;
                }
              }
            : null,
        controller: _textController,
        style: RevmoTheme.getTextFieldStyle(),
        keyboardAppearance: Brightness.light,
        decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: _iconPadding),
                child: SvgPicture.asset(
                  Paths.searchSVG,
                  color: RevmoColors.white.withAlpha(128),
                )),
            hintText: AppLocalizations.of(context)!.search,
            hintStyle: TextStyle(color: RevmoColors.white.withAlpha(128), fontSize: RevmoTheme.getFontSize(1))),
      ),
    );
  }
}
