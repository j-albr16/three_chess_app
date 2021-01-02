import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import './friend_tile.dart';
import './friend_tile.dart';
import '../../helpers/constants.dart';
import '../basic/accept_button.dart';
import '../basic/decline_button.dart';

class PendingFriendTile extends StatelessWidget {
  final double height;
  final FriendTileModel model;
  final FriendDialog onAccept;
  final FriendDialog onReject;
  final FriendDialog onSelected;
  final bool isSelected;

  PendingFriendTile(
      {this.onAccept,
      this.onReject,
      this.height,
      this.model,
      this.isSelected,
      this.onSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: FriendTile.usernameText(model.username)),
                if (isSelected) Flexible(
                  flex: 3,
                  child: confirmButtons(Size(screenWidth / 2,height), theme)),
              ],
            )),
        onPressed: () => onSelected(model),
        hoverColor: Colors.grey,
      );
    });
  }

  Widget confirmButtons(Size size, ThemeData theme) {
    Size buttonSize = Size(size.width / 2.5, size.height);
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AcceptButton(
            onAccept: onAccept,
            size: buttonSize,
            theme: theme,
          ),
          DeclineButton(
            onDecline: onReject,
            size: buttonSize,
            theme: theme,
          ),
        ],
      ),
    );
  }
}
