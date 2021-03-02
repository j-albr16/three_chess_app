import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/screens/screen_bone.dart';

import '../screens/chat_screen.dart';
import '../screens/create_game_screen.dart';
import '../widgets/friends/friend_list.dart';
import '../providers/chat_provider.dart';
import '../providers/friends_provider.dart';
import '../widgets/friends/friend_tile.dart';
import '../widgets/friends/friend_action_popup.dart';
import '../models/friend.dart';
import '../models/user.dart';

enum FriendBools { PendingSelected, IsSearchngFriend, PendingOpen }
enum FriendAction { Watch, Battle, Profile, Delete }

class FriendsScreen extends StatefulWidget {
  static const routeName = 'friends-screen';

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with notificationPort<FriendsScreen>{
  FriendsProvider _friendsProvider;
  ChatProvider _chatProvider;
  bool _didFetch = false;
  List<Friend> friends;
  List<Friend> pendingFriends;
  Friend selectedPending;
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _friendPopUp(context, Friend model) async {
    switch (await showDialog<FriendAction>(
        context: context,
        builder: (BuildContext context) {
          return FriendActionPopUp(
            model: model,
          );
        })) {
      case FriendAction.Battle:
        battleFriend(model.user.id);
        break;
      case FriendAction.Profile:
        //TODO
        break;
      case FriendAction.Watch:
        //TODO
        break;
      case FriendAction.Delete:
        //TODO
        Provider.of<FriendsProvider>(context, listen: false)
            .removeFriend(model.user.id);
        break;
    }
  }

  void battleFriend(String friendId) {
    Navigator.of(context)
        .pushNamed(CreateGameScreen.routeName, arguments: {'friend': friendId});
  }

  switchSelectedPending(model) {
    setState(() {
      selectedPending = model;
    });
  }

  // Booleans

  Map<FriendBools, bool> switchBooleans = {
    FriendBools.IsSearchngFriend: false,
    FriendBools.PendingOpen: false,
  };

  void switchBool(FriendBools key) {
    setState(() {
      switchBooleans[key] = !switchBooleans[key];
    });
  }

  void setBoolTo(FriendBools key, bool setTo) {
    setState(() {
      switchBooleans[key] = setTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    _friendsProvider = Provider.of<FriendsProvider>(context);
    friends = _friendsProvider.friends;
    pendingFriends = _friendsProvider.pendingFriends;
    //mobile thing
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          focusNode.unfocus();
          setBoolTo(FriendBools.IsSearchngFriend, false);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: FriendList(
              tileHeight: 40,
              switchBool: switchBool,
              addFriend: (toBeAddedUsername) =>
                  Provider.of<FriendsProvider>(context, listen: false)
                      .makeFriendRequest(toBeAddedUsername),
              onLongTap: (username) => _friendPopUp(context, username),
              onTap: (friend) {
                print('Select Chat and Navigate to new Chat after Selection');
                return Provider.of<ChatProvider>(context, listen: false)
                    .selectChatRoom(
                        id: friend.user.id, chatType: ChatType.Friend)
                    .then((_) =>
                        Navigator.of(context).pushNamed(ChatScreen.routeName));
                // TODO Open Chat where chat is supposed to be and not design Test Screen
              },
              // friendTiles: sampleFriends,
              friendTiles: friends ?? [],
              // pendingFriendTiles: sampleFriends,
              pendingFriendTiles: pendingFriends ?? [],
              resetBool: setBoolTo,
              onPendingSelect: switchSelectedPending,
              isSearchingFriend: switchBooleans[FriendBools.IsSearchngFriend],
              controller: controller,
              focusNode: focusNode,
              size: MediaQuery.of(context).size,
              theme: Theme.of(context),
              selectedFriend: selectedPending,
              isPendingOpen: switchBooleans[FriendBools.PendingOpen],
              onPendingAccept: (model) =>
                  Provider.of<FriendsProvider>(context, listen: false)
                      .acceptFriend(model.user.id),
              onPendingReject: (model) =>
                  Provider.of<FriendsProvider>(context, listen: false)
                      .declineFriend(model.user.id),
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
