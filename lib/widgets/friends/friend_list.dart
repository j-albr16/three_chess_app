import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/helpers/constants.dart';
import 'package:three_chess/widgets/basic/sorrounding_cart.dart';
import './add_friend.dart';
import './friend_tile.dart';
import './pending_friend_tile.dart';

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
  final TextEditingController controller;
  final ThemeData theme;
  final Size size;
  final FocusNode focusNode;
  final bool isSearchingFriend;
  final Function switchIsSearchingFriend;

  FriendList(
      {this.switchShowPending,
      this.onPendingSelect,
      this.controller,
      this.selectedFriend,
      this.onPendingAccept,
      this.focusNode,
      this.switchIsSearchingFriend,
      this.size,
      this.theme,
      this.isSearchingFriend = false,
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
    Size size = MediaQuery.of(context).size;
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
      width: width,
      child: Stack(
        children: [
          // if (isPendingFriendsOpen)
          //   Container(
          //     width: double.infinity,
          //     height: double.infinity,
          //     color: Colors.grey,
          //   ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: friendList()),
              if (isPendingFriendsOpen) pendingFriendList(size.height * 0.3),
              friendActions(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget friendActionButton(
      {Function callback, ThemeData theme, String text, Icon icon}) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal : mainBoxPadding, vertical: 0),
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
    return SorroundingCard(
      padding: EdgeInsets.all(mainBoxPadding / 2),
      color: theme.colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          friendActionButton(
            callback: switchShowPending,
            theme: theme,
            text: 'Open Requests',
            icon: Icon(
              isPendingFriendsOpen ? Icons.arrow_upward : Icons.arrow_downward,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          // SizedBox(height: 10),
          Divider(color: theme.colorScheme.onSecondary, height: 1,),
          friendActionButton(
            callback: switchIsSearchingFriend,
            theme: theme,
            text: 'Add a Friend',
            icon: Icon(
              Icons.search,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          if (isSearchingFriend)
            AddFriendArea(
              isTyping: isTyping,
              switchTyping: switchTyping,
              addFriend: addFriend,
              controller: controller,
              focusNode: focusNode,
              size: size,
              theme: theme,
            ),
        ],
      ),
    );
  }

  Widget pendingFriendList(double height) {
    return SorroundingCard(
      alignment: Alignment.topLeft,
      height: height,
      child: ListView(
        shrinkWrap: true,
        children: pendingFriendTiles
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
                  constraints: BoxConstraints(maxWidth: width),
                ))
            .toList(),
      ),
    );
  }

  Widget friendList() {
    return SorroundingCard(
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
    );
  }
}
