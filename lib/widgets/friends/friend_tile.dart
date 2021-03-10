import 'package:flutter/material.dart';

import '../basic/message_count.dart';
import '../../helpers/constants.dart';
import '../../models/friend.dart';

typedef void FriendDialog(Friend model);

class FriendTile extends StatelessWidget {
  final double height;
  final Friend model;
  final FriendDialog onLongTap;
  final FriendDialog onTap;

  FriendTile({this.onLongTap, this.onTap, this.height, this.model});

  static Widget onlineIcon(bool isOnline, bool isAfk) {
    return Icon(
      isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: isAfk ? Colors.red : Colors.green,
    );
  }

  static Widget playingIcon(bool isPlaying) {
    return Icon(isPlaying ? Icons.live_tv : Icons.tv_off,
        color: isPlaying ? Colors.red : Colors.black);
  }

  static Widget usernameText(String username, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        username,
        style: theme.textTheme.bodyText1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FlatButton(
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      child: Container(
        padding: EdgeInsets.all(mainBoxPadding),
        margin: EdgeInsets.zero,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 0.5, color: Colors.black26),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  onlineIcon(model.isOnline, model.isAfk),
                  SizedBox(width: 10),
                  playingIcon(model.isPlaying),

                  // TODO for now just print out new Messages as Tetx WIdget.. Will be removed
                ],
              ),
            ),
            if (model.newMessages > 0)
              Align(
                alignment: Alignment.topRight,
                child: MessageCount(model.newMessages),
              ),
            Center(child: usernameText(model.user.userName, theme)),
          ],
        ),
      ),
      onPressed: () => onTap(model),
      onLongPress: () => onLongTap(model),
      hoverColor: Colors.grey,
    );
  }
}
