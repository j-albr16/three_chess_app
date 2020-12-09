import 'package:flutter/material.dart';

import '../providers/friends_provider.dart';
import '../models/game.dart';

class Invitations extends StatelessWidget {
  List<Game> invitations;
  Function acceptInvitation;
  Function declineInvitation;
  Size size;

  Invitations(
      {this.invitations,
      this.size,
      this.acceptInvitation,
      this.declineInvitation});

  @override
  Widget build(BuildContext context) {
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
                decline: () => declineInvitation()))
            .toList(),
      ),
    );
  }

  static Widget invitationTile(
      {Size size, Game game, Function accept, Function decline}) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(13),
      child: Column(
        children: [
          Text(
            'Game Invitation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          gameInfos(game.player[0].user.userName, game.time, game.increment),
          actionButtons(accept, decline, game.id),
        ],
      ),
    );
  }

  static Widget gameInfos(String userName, int time, int increment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(userName),
        Text(time.toString() + ' + ' + increment.toString()),
      ],
    );
  }

  static Widget actionButtons(
      Function accept, Function decline, String gameId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
          padding: EdgeInsets.all(6),
          child: Text('Join'),
          color: Colors.green,
          onPressed: () => accept(gameId),
        ),
        FlatButton(
          padding: EdgeInsets.all(6),
          child: Text('Discard'),
          color: Colors.red,
          onPressed: () => decline(),
        ),
      ],
    );
  }
}
