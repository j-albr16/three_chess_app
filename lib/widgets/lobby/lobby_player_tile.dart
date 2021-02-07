import 'package:flutter/material.dart';

import '../friends/friend_tile.dart';
import '../../models/player.dart';

typedef void FriendAction(Player friend);

class LobbyPlayerTile extends StatelessWidget {
  final Player model;
  final FriendAction onTap;
  final FriendAction onLongTap;
  final bool isPremade;

  LobbyPlayerTile({
    this.isPremade,
    this.model,
    this.onLongTap,
    this.onTap,
  });

  Widget leadingIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FriendTile.onlineIcon(model.isOnline),
        isPremade ? Icon(Icons.person) : Icon(Icons.person_outline),
        ],
    );
  }

  Widget userNameText(ThemeData theme) {
    return Center(
      child: Text(model.user.userName, style: theme.textTheme.bodyText1),
    );
  }

  Widget trailing(ThemeData theme) {
    return Center(child: Text('${model.user.score}'));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextButton(
      onPressed: () => onTap(model),
      onLongPress: () => onLongTap(model),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(4)),
      ),
      child: Row(
        children: <Widget>[
          Flexible(child: leadingIcons(), flex: 1),
          Flexible(child: userNameText(theme), flex: 1),
          Flexible(child: trailing(theme), flex: 1)
        ],
      ),
    );
  }
}
