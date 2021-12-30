import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/misc/revmo_icon_only_button.dart';

class RevmoAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function()? _menuBarAction;
  final bool _showMenuIcon;
  RevmoAppBar({bool showMenuIcon = false, Function()? menuIconAction})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        this._showMenuIcon = showMenuIcon,
        this._menuBarAction = menuIconAction {
    assert(_showMenuIcon == false || _menuBarAction != null, "Please add a callback to show the menu action button");
  }
  @override
  final Size preferredSize;

  @override
  State<RevmoAppBar> createState() => _RevmoAppBarState();
}

class _RevmoAppBarState extends State<RevmoAppBar> {
  final double _actionIconMargin = 10;
  final double _actionIconPadding = 10;
  final double _actionIconWidth = 50;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: RevmoColors.darkBlue,
      elevation: 0.0,
      actions: [
        if (widget._showMenuIcon)
          Container(
            margin: EdgeInsets.only(right: _actionIconMargin),
            child: RevmoIconButton(
              width: _actionIconWidth,
              callback: widget._menuBarAction!,
              iconWidget: SvgPicture.asset(
                Paths.menuSVG,
                fit: BoxFit.fill,
              ),
              color: Colors.transparent,
              iconPadding: _actionIconPadding,
            ),
          ),
      ],
    );
  }
}
