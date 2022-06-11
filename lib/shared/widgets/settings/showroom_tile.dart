import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/showroom.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/danger_button.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/success_button.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowroomTile extends StatefulWidget {
  final Showroom showroom;
  const ShowroomTile(this.showroom);

  @override
  State<ShowroomTile> createState() => _ShowroomTileState();
}

class _ShowroomTileState extends State<ShowroomTile> {
  final double _cardHeight = 60;
  final double _buttonsWidth = 60;

  bool isButtonsDisabled = false;

  disableButtons() {
    setState(() {
      isButtonsDisabled = true;
    });
  }

  enableButtons() {
    setState(() {
      isButtonsDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
      height: _cardHeight,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        minVerticalPadding: 0,
        dense: true,
        horizontalTitleGap: 5,
        leading: UserImage(widget.showroom, 40, isShowroom: true,),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: FittedBox(
                  child: RevmoTheme.getSemiBold(
                widget.showroom.fullName,
                1,
                color: RevmoColors.darkestBlue,
              ))),
          SizedBox(
            width: 25,
          ),
          if (widget.showroom.owner != null) ...[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FittedBox(
                        child: RevmoTheme.getBody(
                      AppLocalizations.of(context)!.owner,
                      0,
                      color: RevmoColors.darkestBlue,
                    )),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                          child: RevmoTheme.getSemiBold(
                        widget.showroom.owner!.fullName,
                        1,
                        color: RevmoColors.darkestBlue,
                      ))),
                ),
              ],
            )),
            SizedBox(
              width: 25,
            ),
          ],
          if (widget.showroom.requestedStatus == JoinRequestStatus.InvitedByShowroom) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: _buttonsWidth,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SuccessButton(
                    text: AppLocalizations.of(context)!.accept,
                    callBack: (isButtonsDisabled) ? null : () async => await acceptRequest(context),
                    width: _buttonsWidth,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: _buttonsWidth,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DangerButton(
                    text: AppLocalizations.of(context)!.cancel,
                    callBack: (isButtonsDisabled) ? null : () async => await cancelRequest(context),
                    width: _buttonsWidth,
                  ),
                )
              ],
            )
          ] else if (widget.showroom.requestedStatus == JoinRequestStatus.RequestedBySeller)
            Container(
              alignment: Alignment.centerRight,
              width: _buttonsWidth,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DangerButton(
                text: AppLocalizations.of(context)!.cancelRequest,
                callBack: (isButtonsDisabled) ? null : () async => await cancelRequest(context),
                width: _buttonsWidth,
              ),
            )
          else
            Container(
              alignment: Alignment.centerRight,
              width: _buttonsWidth,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MainButton(
                text: AppLocalizations.of(context)!.submitJoinRequest,
                callBack: (isButtonsDisabled) ? null : () async => await sendInvitation(context),
                width: _buttonsWidth,
              ),
            )
        ]),
      ),
    );
  }

  cancelRequest(BuildContext context) async {
    disableButtons();
    await Provider.of<AccountProvider>(context, listen: false).declineInvitation(context, widget.showroom);
    enableButtons();
  }

  acceptRequest(BuildContext context) async {
    disableButtons();
    bool res = await Provider.of<AccountProvider>(context, listen: false).acceptInvitation(context, widget.showroom);
    if (res) {
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.ROUTE_NAME, ModalRoute.withName('/'));
    }
    enableButtons();
  }

  sendInvitation(BuildContext context) async {
    disableButtons();
    await Provider.of<AccountProvider>(context, listen: false).sendJoinRequest(context, widget.showroom);
    enableButtons();
  }
}
