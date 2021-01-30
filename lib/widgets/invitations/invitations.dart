import 'package:flutter/material.dart';
import 'package:three_chess/helpers/constants.dart';

import '../../providers/friends_provider.dart';
import '../../models/online_game.dart';
import '../basic/sorrounding_cart.dart';
import '../basic/decline_button.dart';
import '../basic/accept_button.dart';

class Invitations extends StatelessWidget {
  final List<OnlineGame> invitations;
  final Function acceptInvitation;
  final Function declineInvitation;
  final Size size;

  Invitations(
      {this.invitations,
      this.size,
      this.acceptInvitation,
      this.declineInvitation});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: ListView(
        children: invitations
            .map((invitation) => invitationTile(
                size: size,
                game: invitation,
                accept: (gameId) => acceptInvitation(gameId),
                theme: theme,
                decline: (gameId) => declineInvitation(gameId)))
            .toList(),
      ),
    );
  }

  static Widget invitationTile(
      {Size size,
      OnlineGame game,
      Function accept,
      Function decline,
      ThemeData theme}) {
    return SorroundingCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13),
            child: gameInfos(
                userName: game.player[0].user.userName,
                time: game.time,
                increment: game.increment,
                theme: theme,
                isRated: game.isRated),
          ),
          actionButtons(
            accept: accept,
            decline: decline,
            gameId: game.id,
            size: Size(size.width, size.height * 0.2),
            theme: theme,
          ),
        ],
      ),
    );
  }

  static Widget gameInfos(
      {String userName,
      int time,
      int increment,
      bool isRated,
      ThemeData theme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 4),
        Text(userName,
            style: theme.textTheme.bodyText1
                .copyWith(fontWeight: FontWeight.w700)),
        SizedBox(width: 30),
        Text(isRated ? 'Rated' : 'Casual', style: theme.textTheme.bodyText1),
        Text(time.toString() + ' + ' + increment.toString(),
            style: theme.textTheme.bodyText1),
        SizedBox(width: 4),
      ],
    );
  }

  static Widget actionButtons(
      {Function accept,
      Function decline,
      String gameId,
      ThemeData theme,
      Size size}) {
    Size buttonSize = Size(size.width * 0.3, size.height * 0.45);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AcceptButton(
          child: Text(
            'Join',
            style: theme.textTheme.bodyText1
                .copyWith(color: theme.colorScheme.onError),
          ),
          onAccept: () => accept(gameId),
          size: buttonSize,
          theme: theme,
        ),
        DeclineButton(
          child: Text(
            'Discard',
            style: theme.textTheme.bodyText1
                .copyWith(color: theme.colorScheme.onError),
          ),
          onDecline: () => decline(gameId),
          size: buttonSize,
          theme: theme,
        ),
      ],
    );
  }
}
