import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/screens/chat_screen.dart';
import 'package:three_chess/screens/create_game_screen.dart';
import 'package:three_chess/widgets/friends/friend_list.dart';

import '../providers/chat_provider.dart';
import '../screens/design-test-screen.dart';
import '../widgets/create_game.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';
import '../widgets/friends/friend_tile.dart';

enum FriendAction { Watch, Battle, Profile, Delete }

class FriendsScreen extends StatefulWidget {
  static const routeName = 'friends-screen';

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  FriendsProvider _friendsProvider;
  ChatProvider _chatProvider;
  bool _didFetch = false;
  List<FriendTileModel> friends;
  List<FriendTileModel> pendingFriends;
  FriendTileModel selectedPending;
  TextEditingController controller;
  FocusNode focusNode;
  bool isSearchingFriend = false;

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

  bool isTyping = false;
  bool _isPendingOpen = false;

  Future<void> _friendPopUp(context, FriendTileModel model) async {
    switch (await showDialog<FriendAction>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('What you wanna do with him?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FriendAction.Battle);
                },
                child: Center(
                    child: const Text(
                  'Battle him!',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FriendAction.Profile);
                },
                child: const Center(
                    child: Text(
                  'His Profile!',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                      context, model.isPlaying ? FriendAction.Watch : null);
                },
                child: Center(
                    child: Text(
                  model.isPlaying ?? false
                      ? 'Watch him Play!'
                      : "He ain't Playing right now!",
                  style: TextStyle(
                      color:
                          model.isPlaying ?? false ? Colors.green : Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FriendAction.Delete);
                },
                child: const Center(
                    child: Text(
                  'Delete that guy!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ],
          );
        })) {
      case FriendAction.Battle:
        battleFriend(model.userId);
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
            .removeFriend(model.userId)
            .then((String message) => handleServerResponse(message));
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

  switchTyping() {
    setState(() {
      isTyping = !isTyping;
    });
  }

  switchPending() {
    setState(() {
      _isPendingOpen = !_isPendingOpen;
    });
  }

  void provideFriends() {
    // TODO
    _friendsProvider = Provider.of<FriendsProvider>(context);
    _chatProvider = Provider.of<ChatProvider>(context);
    friends = _friendsProvider.friends
        .map((friend) => new FriendTileModel(
              username: friend.user.userName,
              userId: friend.user.id,
              chatId: friend.chatId,
              newMessages: friend.newMessages,
              // isOnline: friend.isOnline,
              isOnline: friend.isOnline,
              isPlaying: friend.isPlaying,
            ))
        .toList();
    pendingFriends = _friendsProvider.pendingFriends
        .map((pendingFriend) => new FriendTileModel(
            username: pendingFriend.user.userName,
            userId: pendingFriend.user.id,
            newMessages: pendingFriend.newMessages,
            chatId: pendingFriend.chatId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    provideFriends();
    //mobile thing
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          focusNode.unfocus();
          if (isTyping) {
            switchTyping();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FriendList(
                isTyping: isTyping,
                switchTyping: switchTyping,
                tileHeight: 50,
                switchShowPending: switchPending,
                addFriend: (toBeAddedUsername) => Provider.of<FriendsProvider>(
                        context,
                        listen: false)
                    .makeFriendRequest(toBeAddedUsername)
                    .then((String message) => handleServerResponse(message)),
                onLongTap: (username) => _friendPopUp(context, username),
                onTap: (friend) {
                  print('Select Chat and Navigate to new Chat after Selection');
                  return Provider.of<ChatProvider>(context, listen: false)
                      .selectChatRoom(id: friend.userId, isGameChat: false)
                      .then((_) => Navigator.of(context)
                          .pushNamed(ChatScreen.routeName));
                  // TODO Open Chat where chat is supposed to be and not design Test Screen
                },
                // friendTiles: sampleFriends,
                friendTiles: friends ?? [],
                // pendingFriendTiles: sampleFriends,
                pendingFriendTiles: pendingFriends ?? [],
                onPendingSelect: switchSelectedPending,
                isSearchingFriend: isSearchingFriend,
                switchIsSearchingFriend: () {
                  setState() {
                    isSearchingFriend = !isSearchingFriend;
                  }
                },
                controller: controller,
                focusNode: focusNode,
                size: MediaQuery.of(context).size,
                theme: Theme.of(context),
                selectedFriend: selectedPending,
                isPendingFriendsOpen: _isPendingOpen,
                onPendingAccept: (model) => Provider.of<FriendsProvider>(
                        context,
                        listen: false)
                    .acceptFriend(model.userId)
                    .then((String message) => handleServerResponse(message)),
                onPendingReject: (model) => Provider.of<FriendsProvider>(
                        context,
                        listen: false)
                    .declineFriend(model.userId)
                    .then((String message) => handleServerResponse(message)),
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleServerResponse(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
