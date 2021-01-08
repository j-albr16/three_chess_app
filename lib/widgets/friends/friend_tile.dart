import 'package:flutter/material.dart';

import '../basic/message_count.dart';
import '../../helpers/constants.dart';

typedef void FriendDialog(FriendTileModel model);

class FriendTileModel {
  bool isOnline = false;
  final String username;
  bool isPlaying = false;
  final String chatId;
  final String userId;
  final int newMessages;

  FriendTileModel(
      {this.chatId,
      this.newMessages,
      this.isPlaying,
      this.isOnline,
      @required this.username,
      @required this.userId});
}

class FriendTile extends StatelessWidget {
  final double height;
  final FriendTileModel model;
  final FriendDialog onLongTap;
  final FriendDialog onTap;

  FriendTile({this.onLongTap, this.onTap, this.height, this.model});

  static Widget onlineIcon(bool isOnline) {
    return Icon(
      isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: Colors.green,
    );
  }

  static Widget playingIcon(bool isPlaying) {
    return Icon(isPlaying ? Icons.live_tv : Icons.tv_off,
        color: isPlaying ? Colors.red : Colors.black);
  }

  static Widget usernameText(String username) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        username,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  onlineIcon(model.isOnline),
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
            Center(child: usernameText(model.username)),
          ],
        ),
      ),
      onPressed: () => onTap(model),
      onLongPress: () => onLongTap(model),
      hoverColor: Colors.grey,
    );
  }
}
