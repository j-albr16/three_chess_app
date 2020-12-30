import 'package:flutter/material.dart';

import '../basic/message_count.dart';

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
    return Text(
      username,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Stack(
            children: [
              ListTile(
                leading: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 5),
                    child: Row(
                      children: [
                        onlineIcon(model.isOnline),
                        Container(width: 10, color: Colors.transparent),
                        playingIcon(model.isPlaying),
                        // TODO for now just print out new Messages as Tetx WIdget.. Will be removed
                      ],
                    ),
                  ),
                ),
                title: usernameText(model.username),
                onTap: () => onTap(model),
                onLongPress: () => onLongTap(model),
                hoverColor: Colors.grey,
              ),
              if (model.newMessages > 0)
                Align(
                  alignment: Alignment.topRight,
                  child: MessageCount(model.newMessages),
                )
            ],
          ),
        ),
        Divider(thickness: 1,)
      ],
    );
  }
}