import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/settings/settings_screen.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/revmo_icon_only_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevmoAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool _showMenuIcon;
  final bool _addLogout;
  final bool _addSettings;
  final Iterable<PopupMenuItem<String>> _buttonsToAdd;
  final String? title;
  final String? subtitle;
 final  bool centerTitle;

  RevmoAppBar(
      {Iterable<PopupMenuItem<String>> buttonsToAdd = const [],
      bool addLogout = false,
      bool addSettings = false,
      bool showMenuIcon = false,
      this. centerTitle = true,
      this.title,
      this.subtitle})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        this._showMenuIcon = showMenuIcon,
        this._addLogout = addLogout,
        this._addSettings = addSettings,
        this._buttonsToAdd = buttonsToAdd;
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
      centerTitle: widget.centerTitle,
      titleSpacing: 0,
      title: widget.title != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RevmoTheme.getTitle(widget.title!),
                if (widget.subtitle != null) ...[
                  SizedBox(
                    height: 5,
                  ),
                  RevmoTheme.getCaption(widget.subtitle!, 0)
                ]
              ],
            )
          : null,
      actions: [
        if (widget._showMenuIcon)
          Container(
            margin: EdgeInsets.only(right: _actionIconMargin),
            child: RevmoIconButton(
              width: _actionIconWidth,
              callback: () => showMenu(
                  context: context,
                  color: RevmoColors.darkGrey,
                  position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width,
                      kToolbarHeight,
                      40.0,
                      0),
                  items: [
                    if (widget._addSettings)
                      PopupMenuItem<String>(
                        child: ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            title: new FittedBox(
                                child: Text(
                                    AppLocalizations.of(context)!.settings))),
                        onTap: () async {
                          await Future.delayed(Duration.zero);
                          Navigator.of(context)
                              .pushNamed(SettingsScreen.ROUTE_NAME);
                        },
                      ),
                    if (widget._addLogout)
                      PopupMenuItem<String>(
                        child: ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            title: new FittedBox(
                                child: Text(
                                    AppLocalizations.of(context)!.logout))),
                        onTap: () async {
                          await AuthService.logOut(context);
                          Navigator.of(context)
                              .popAndPushNamed(PreLoginScreen.ROUTE_NAME);
                        },
                      ),
                  ]..addAll(widget._buttonsToAdd)),
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
