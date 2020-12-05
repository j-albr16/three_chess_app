import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

typedef void FriendDialog(FriendTileModel model);

class FriendTileModel {
  bool isOnline;
  final String username;
  bool isPlaying;
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
                playingIcon(model.isPlaying),
                // TODO for now just print out new Messages as Tetx WIdget.. Will be removed
                Text(model.newMessages.toString()),
              ],
            ),
          ),
        ),
        title: usernameText(model.username),
        onTap: () => onTap(model),
        onLongPress: () => onLongTap(model),
        hoverColor: Colors.grey,
      ),
    );
  }
}

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

  Widget usernameText(String username) {
    return Text(
      username,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _selectWrapper({Widget child}) {
      return isSelected
          ? InkWell(
              child: child,
              onTap: () => onSelected(FriendTileModel()),
            )
          : InkWell(
              child: child,
              onTap: () => onSelected(model),
            );
    }

    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return _selectWrapper(
        child: Container(
          height: isSelected ? height * 2 : height,
          // padding: EdgeInsets.only(top: 10, bottom: 10),
          //decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          child: Card(
            child: SizedBox(
              height: isSelected ? height * 2 : height,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    Center(child: usernameText(model.username)),
                    if (isSelected)
                      Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: InkWell(
                                  child: Card(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  onTap: () => onAccept(model),
                                ),
                              ),
                              Container(
                                width: screenWidth * 0.1,
                                color: Colors.transparent,
                              ),
                              Container(
                                width: screenWidth * 0.4,
                                child: InkWell(
                                  child: Card(
                                    child: Center(
                                        child: Text("X",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                  onTap: () => onReject(model),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class FriendList extends StatelessWidget {
  final double width;
  final FriendDialog onPendingSelect;
  final List<FriendTileModel> friendTiles;
  final List<FriendTileModel> pendingFriendTiles;
  final double tileHeight;
  final FriendDialog onLongTap;
  final FriendDialog onTap;
  final AddFriend addFriend;
  final bool isTyping;
  final Function switchTyping;
  final Function switchShowPending;
  final bool isPendingFriendsOpen;
  final FriendDialog onPendingAccept;
  final FriendDialog onPendingReject;
  final FriendTileModel selectedFriend;

  FriendList(
      {this.switchShowPending,
      this.onPendingSelect,
      this.selectedFriend,
      this.onPendingAccept,
      this.onPendingReject,
      this.isPendingFriendsOpen,
      this.switchTyping,
      this.isTyping,
      this.addFriend,
      this.onLongTap,
      this.onTap,
      this.tileHeight,
      this.width = double.infinity,
      this.friendTiles = const [],
      this.pendingFriendTiles = const []});

  @override
  Widget build(BuildContext context) {
    _onPendingWrapper({Widget child}) {
      return isPendingFriendsOpen
          ? Align(
              alignment: Alignment.topCenter,
              child: child,
            )
          : Expanded(
              child: child,
            );
    }
    return Container(
        padding: EdgeInsets.only(bottom: 5, top: 5),
        decoration:
            BoxDecoration(border: Border.all(width: 3, color: Colors.black)),
        child: Container(
          width: width,
          child: Stack(
            children: [
              if(isPendingFriendsOpen) Container(width: double.infinity, height: double.infinity, color: Colors.grey,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: isPendingFriendsOpen
                          ? pendingFriendTiles
                              .map((model) => Container(
                                    child: PendingFriendTile(
                                      isSelected: selectedFriend?.userId == (model?.userId ?? "")
                                          ? true
                                          : false,
                                      onSelected: onPendingSelect,
                                      model: model,
                                      onAccept: onPendingAccept,
                                      onReject: onPendingReject,
                                      height: tileHeight,
                                    ),
                                    constraints:
                                        BoxConstraints(maxWidth: width),
                                  ))
                              .toList()
                          : friendTiles
                              .map((model) => Container(
                                    child: FriendTile(
                                      model: model,
                                      height: tileHeight,
                                      onTap: onTap,
                                      onLongTap: onLongTap,
                                    ),
                                    constraints:
                                        BoxConstraints(maxWidth: width),
                                  ))
                              .toList(),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 7, right: 7),
                      height: tileHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "FriendRequest",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon( isPendingFriendsOpen ? Icons.arrow_upward : Icons.arrow_downward),
                            ],
                          ),
                        ),
                        onPressed: switchShowPending,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    AddFriendArea(
                      isTyping: isTyping,
                      switchTyping: switchTyping,
                      addFriend: addFriend,
                    ),
                  ],
                ),
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

  void _submit(submitted){
    switchTyping();
    addFriend(submitted);
  }

  Widget textField() {
    TextEditingController controller = TextEditingController();
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _submit(controller.text),
          ),
          hintText: '... add a Friend',
        ),
        maxLines: 1,
        onSubmitted: _submit,
      ),
    );
  }

  Widget button() {
    return Container(
        color: Colors.purple,
        height: 47,
        child: InkWell(
          onTap: () => switchTyping(),
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
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 7, right: 7),
        width: double.infinity,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        child: isTyping ? textField() : button());
  }
}
