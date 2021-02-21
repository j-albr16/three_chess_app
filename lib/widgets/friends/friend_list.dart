import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../helpers/constants.dart';
import '../../screens/friends_screen.dart';
import '../basic/sorrounding_cart.dart';
import './add_friend.dart';
import './friend_tile.dart';
import './pending_friend_tile.dart';
import '../../models/friend.dart';

typedef void SwitchBool(FriendBools friendBool);

class FriendList extends StatelessWidget {
  final double width;
  final FriendDialog onPendingSelect;
  final List<Friend> friendTiles;
  final List<Friend> pendingFriendTiles;
  final double tileHeight;
  final FriendDialog onLongTap;
  final FriendDialog onTap;
  final AddFriend addFriend;
  final SwitchBool switchBool;
  final bool isPendingOpen;
  final FriendDialog onPendingAccept;
  final FriendDialog onPendingReject;
  final Friend selectedFriend;
  final TextEditingController controller;
  final ThemeData theme;
  final Size size;
  final FocusNode focusNode;
  final bool isSearchingFriend;
  final Function resetBool;

  FriendList(
      {this.switchBool,
      this.onPendingSelect,
      this.controller,
      this.resetBool,
      this.selectedFriend,
      this.onPendingAccept,
      this.focusNode,
      this.size,
      this.theme,
      this.isSearchingFriend,
      this.onPendingReject,
      this.isPendingOpen,
      this.addFriend,
      this.onLongTap,
      this.onTap,
      this.tileHeight,
      this.width = double.infinity,
      this.friendTiles = const [],
      this.pendingFriendTiles = const []});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _onPendingWrapper({Widget child}) {
      return isPendingOpen
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
      width: width,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: friendList()),
              if (isPendingOpen) pendingFriendList(size.height * 0.3),
              friendActions(theme),
              if (isSearchingFriend)
                AddFriendArea(
                  switchIsSearchingFriend: () =>
                      switchBool(FriendBools.IsSearchngFriend),
                  addFriend: addFriend,
                  controller: controller,
                  focusNode: focusNode,
                  size: size,
                  theme: theme,
                ),
              SizedBox(height: bottomGreyBarHeigth),
            ],
          ),
        ],
      ),
    );
  }

  Widget friendActionButton(
      {Function callback, ThemeData theme, String text, Icon icon}) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: mainBoxPadding, vertical: 0),
      color: theme.colorScheme.secondary,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: icon,
          ),
          Center(
            child: Text(
              text,
              style: theme.textTheme.subtitle2
                  .copyWith(color: theme.colorScheme.onSecondary, fontSize: 17),
            ),
          ),
        ],
      ),
      onPressed: callback,
    );
  }

  Widget friendActions(ThemeData theme) {
    return SurroundingCard(
      padding: EdgeInsets.all(mainBoxPadding / 2),
      color: theme.colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          friendActionButton(
            callback: () => switchBool(FriendBools.PendingOpen),
            theme: theme,
            text: 'Open Requests',
            icon: Icon(
              isPendingOpen ? Icons.arrow_upward : Icons.arrow_downward,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          // SizedBox(height: 10),
          if (!isSearchingFriend)
            Divider(
              color: theme.colorScheme.onSecondary,
              height: 1,
            ),
          if (!isSearchingFriend)
            friendActionButton(
              callback: () => switchBool(FriendBools.IsSearchngFriend),
              theme: theme,
              text: 'Add a Friend',
              icon: Icon(
                Icons.search,
                color: theme.colorScheme.onSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget pendingFriendList(double height) {
    return GestureDetector(
      onTap: () {
        onPendingSelect(null);
        resetBool(FriendBools.IsSearchngFriend, false);
      },
      child: SurroundingCard(
        alignment: Alignment.topLeft,
        height: height,
        child: ListView(
          shrinkWrap: true,
          children: pendingFriendTiles
              .map((model) => Container(
                    child: PendingFriendTile(
                      isSelected:
                          selectedFriend.user.id == (model.user.id ?? "")
                              ? true
                              : false,
                      onSelected: onPendingSelect,
                      model: model,
                      onAccept: onPendingAccept,
                      onReject: onPendingReject,
                      height: tileHeight,
                    ),
                    constraints: BoxConstraints(maxWidth: width),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget friendList() {
    return GestureDetector(
      onTap: () {
        onPendingSelect(null);
        resetBool(FriendBools.PendingOpen, false);
        resetBool(FriendBools.IsSearchngFriend, false);
      },
      child: SurroundingCard(
        padding: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.topLeft,
        child: ListView(
          shrinkWrap: true,
          children: friendTiles
              .map((model) => Container(
                    constraints: BoxConstraints(maxWidth: width),
                    child: FriendTile(
                      model: model,
                      height: tileHeight,
                      onTap: onTap,
                      onLongTap: onLongTap,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
