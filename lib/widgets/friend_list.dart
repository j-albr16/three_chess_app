import 'package:flutter/material.dart';

typedef void FriendDialog(FriendTileModel model);

class FriendTileModel {
  final bool isOnline;
  final String username;
  final bool isPlaying;

  FriendTileModel({this.isPlaying, this.isOnline, this.username});
}

class FriendTile extends StatelessWidget {
  final double height;
  final FriendTileModel model;
  final FriendDialog popUp;

  FriendTile(
      {this.popUp,this.height,  this.model});

  Widget onlineIcon(bool isOnline) {
    return Icon(
      isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: Colors.green,
    );
  }

  Widget playingIcon(bool isPlaying) {
    return Icon(isPlaying ? Icons.live_tv : Icons.tv_off,
        color: isPlaying ? Colors.red : Colors.black);
  }

  Widget usernameText(String username) {
    return Text(
      username,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: ListTile(
        leading: FittedBox(
          child: Padding(
            padding: EdgeInsets.only(top: 2, bottom: 5),
            child: Row(
              children: [
                onlineIcon(model.isOnline),
                Container(width: 10, color: Colors.transparent),
                playingIcon(model.isPlaying)
              ],
            ),
          ),
        ),
        title: usernameText(model.username),
        onTap: () => popUp(model),
        hoverColor: Colors.grey,
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final double width;
  final List<FriendTileModel> friendTiles;
  final double tileHeight;
  final FriendDialog popUp;
  final AddFriend addFriend;
  final bool isTyping;
  final Function switchTyping;

  FriendList(
      {
        this.switchTyping,
        this.isTyping,
        this.addFriend,
      this.popUp,
      this.tileHeight,
      this.width = double.infinity,
      this.friendTiles = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 5, top: 5, right: 8),
        decoration:
            BoxDecoration(border: Border.all(width: 3, color: Colors.black)),
        child: Container(
          width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: friendTiles
                        .map((model) => Container(
                              child: FriendTile(
                                model: model,
                                height: tileHeight,
                                popUp: popUp,
                              ),
                              constraints: BoxConstraints(maxWidth: width),
                            ))
                        .toList(),
                  ),
                ),
                Container(height: 20, color: Colors.transparent),
                AddFriendArea(
                  isTyping: isTyping,
                  switchTyping: switchTyping,
                  addFriend: addFriend,
                )
              ],
            ),
        ));
  }
}

typedef void AddFriend(String friendToAdd);

class AddFriendArea extends StatelessWidget {
  final AddFriend addFriend;
  final bool isTyping;
  final Function switchTyping;

  AddFriendArea({this.addFriend, this.isTyping = false, this.switchTyping});


  Widget textField() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: TextField(
        autofocus: true,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: '... add a Friend',
        ),
        maxLines: 1,
        onSubmitted: (submitted) {
          switchTyping();
          addFriend(submitted);
        },
      ),
    );
  }

  Widget button() {
    return Container(
        color: Colors.purple,
        height: 47,
        child: InkWell(
          onTap: () =>
            switchTyping()
          ,

          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add a Friend",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(width: 10, color: Colors.transparent),
                  Icon(Icons.search, color: Colors.white,),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 7),
        width: double.infinity,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        child: isTyping ? textField() : button());
  }
}
