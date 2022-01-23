import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/danger_button.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/success_button.dart';
import 'package:revmo/shared/widgets/settings/user_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTile extends StatefulWidget {
  final Seller seller;
  const UserTile(this.seller);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
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
        leading: UserImage(widget.seller, 40),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FittedBox(
                            child: RevmoTheme.getBody(
                          (widget.seller.isOwner)
                              ? AppLocalizations.of(context)!.owner
                              : (widget.seller.managerNotOwner)
                                  ? AppLocalizations.of(context)!.admin
                                  : (widget.seller.inTeam)
                                      ? AppLocalizations.of(context)!.teamMember
                                      : (widget.seller.requestedStatus == JoinRequestStatus.InvitedByShowroom)
                                          ? AppLocalizations.of(context)!.invitedToJoin
                                          : (widget.seller.requestedStatus == JoinRequestStatus.RequestedBySeller)
                                              ? AppLocalizations.of(context)!.requestedToJoin
                                              : AppLocalizations.of(context)!.seller,
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
                            widget.seller.fullName,
                            1,
                            color: RevmoColors.darkestBlue,
                          ))),
                    ),
                  ]),
            ),
            SizedBox(
              width: 5,
            ),
            if (widget.seller.inTeam) ...[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                          child: RevmoTheme.getBody(
                        AppLocalizations.of(context)!.totalCarsSold,
                        0,
                        color: RevmoColors.darkestBlue,
                      )),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                            child: RevmoTheme.getSemiBold(
                          widget.seller.carsSoldCount.toString(),
                          1,
                          color: RevmoColors.darkestBlue,
                        ))),
                  ),
                ],
              )),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                          child: RevmoTheme.getBody(
                        AppLocalizations.of(context)!.totalSales,
                        0,
                        color: RevmoColors.darkestBlue,
                      )),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                            child: RevmoTheme.getSemiBold(
                          widget.seller.salesTotalFormatted + " " + AppLocalizations.of(context)!.egCurrency,
                          1,
                          color: RevmoColors.darkestBlue,
                        ))),
                  ),
                ],
              )),
            ] else ...[
              if (widget.seller.requestedStatus == JoinRequestStatus.RequestedBySeller) ...[
                Row(
                  children: [
                    Container(
                      width: _buttonsWidth,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SuccessButton(
                        text: AppLocalizations.of(context)!.accept,
                        callBack: (isButtonsDisabled || (widget.seller.isOwner || widget.seller.inTeam))
                            ? null
                            : () async => await acceptRequest(context),
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
              ] else if (widget.seller.requestedStatus == JoinRequestStatus.InvitedByShowroom)
                Container(
                  width: _buttonsWidth,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DangerButton(
                    text: AppLocalizations.of(context)!.cancelRequest,
                    callBack: (isButtonsDisabled) ? null : () async => await cancelRequest(context),
                    width: _buttonsWidth,
                  ),
                )
              else
                Container(
                  width: _buttonsWidth,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MainButton(
                    text: AppLocalizations.of(context)!.inviteToTeam,
                    callBack: (isButtonsDisabled || (widget.seller.isOwner || widget.seller.inTeam))
                        ? null
                        : () async => await sendInvitation(context),
                    width: _buttonsWidth,
                  ),
                )
            ]
          ],
        ),
      ),
    );
  }

  cancelRequest(BuildContext context) async {
    disableButtons();
    await Provider.of<AccountProvider>(context, listen: false).cancelInvitationRequest(context, widget.seller);
    enableButtons();
  }

  acceptRequest(BuildContext context) async {
    disableButtons();
    await Provider.of<AccountProvider>(context, listen: false).acceptJoinRequest(context, widget.seller);
    enableButtons();
  }

  sendInvitation(BuildContext context) async {
    disableButtons();
    await Provider.of<AccountProvider>(context, listen: false).sendInvitation(context, widget.seller);
    enableButtons();
  }
}
