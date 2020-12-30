import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../basic/sorrounding_cart.dart';
import '../basic/decline_button.dart';
import '../basic/accept_button.dart';

class InvitationHead extends StatelessWidget {
  final Function declineAll;
  final Function confirmDeclineAll;
  final Function cancelDeclineAll;
  final int invitationCount;
  final Size size;

  InvitationHead(
      {this.size,
      this.declineAll,
      this.invitationCount,
      this.cancelDeclineAll,
      this.confirmDeclineAll});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return invitationHead(theme, invitationCount);
  }

  Widget invitationHead(ThemeData theme, int invitationCount) {
    return SorroundingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('You have $invitationCount pending Invitation(s)',
              style: theme.textTheme.bodyText1),
          SizedBox(
            height: 5,
          ),
          deleteButton(theme, Size(size.width * 0.9, size.height * 0.15))
        ],
      ),
    );
  }

  Widget deleteButton(ThemeData theme, Size size) {
    return FlatButton(
        onPressed: declineAll,
        child: Text(
          'Decline All Invitations',
          style: theme.textTheme.bodyText1.copyWith(
              color: theme.colorScheme.onError, fontWeight: FontWeight.w600),
        ),
        height: size.height,
        minWidth: size.width,
        color: theme.colorScheme.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        padding: EdgeInsets.all(mainBoxPadding));
  }

  Widget confirmDelete(ThemeData theme, Size size) {
    Size buttonSize = Size(size.width * 0.3, size.height * 0.9);
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(mainBoxPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        color: Colors.red[900].withOpacity(0.1),
      ),
      child: Row(
        children: <Widget>[
          AcceptButton(
            onAccept: () => confirmDeclineAll(),
            size: buttonSize,
            theme: theme,
          ),
          DeclineButton(
            onDecline: () => cancelDeclineAll(),
            size: buttonSize,
            theme: theme,
          ),
        ],
      ),
    );
  }
}
