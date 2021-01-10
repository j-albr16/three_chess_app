import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../widgets/create_game.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';

typedef CreateGameCallback(
    {int increment,
    int time,
    int posRatingRange,
    int negRatingRange,
    bool isPrivate,
    bool isRated,
    bool allowPremades});

class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-screen';

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      _gameProvider = Provider.of<GameProvider>(context, listen: false);
      Provider.of<FriendsProvider>(context, listen: false)
          .fetchFriends()
          .then((_) => setState(() {
                _friendsInit = true;
              }));
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser()
          .then((_) => setState(() {
                _userInit = true;
              }));
    });
  }

  bool _userInit = false;
  bool _friendsInit = false;

  GameProvider _gameProvider;

  Size size;
  User user;

// is Private vars
  bool isPublic = true;
  Function updateIsPrivate(bool value) {
    setState(() {
      isPublic = value;
    });
  }

//allow Premade vars
  bool allowPremades = true;
  Function updateAllowPremades(bool value) {
    setState(() {
      allowPremades = value;
    });
  }

// is Public Button Bar (Switch)
  Function updateButtonBarData(int index) {
    setState(() {
      currentPublicitySelection = index;
    });
  }

  int currentPublicitySelection = 0;

// player Color Selection
  Function updatePlayerColorSelection(int index) {
    setState(() {
      playerColorSelection = index;
    });
  }

  int playerColorSelection = 4;

  // time Slider
  double time = 10;
  double timeMin = 0;
  double timeMax = 50;
  Function updateTime(double value) {
    setState(() {
      time = value;
    });
  }

  int timeDivisions = 50;

  // increment Slider
  double increment = 3;
  double incrementMin = 0;
  double incrementMax = 10;
  int incrementDivisions = 10;
  Function updateIncrement(double value) {
    setState(() {
      increment = value;
    });
  }

  // Friend Popup
  int friendSelectionAmount = 0;
  Function confirmFriendSelection(List<String> selectedFriendIds) {
    selectedFriends = friends
        .where((friend) => selectedFriendIds.contains(friend.user.id))
        .toList();
    Navigator.of(context).pop();
    setState(() {});
  }

  Function cancelFriendSelection() {
    Navigator.of(context).pop();
  }

  Function removeFriend(String id) {
    setState(() {
      selectedFriends.removeWhere((friend) => friend.user.id == id);
    });
  }

  List<Friend> selectedFriends = [];
  List<Friend> friends = [];

  // Rating Range
  double posRatingRange;
  updateRatingRange(RangeValues values) {
    print(user.score);
    if (values.start <= user.score) {
      setState(() {
        negRatingRange = values.start;
      });
    }
    if (values.end >= user.score) {
      setState(() {
        posRatingRange = values.end;
      });
    }
  }

  double negRatingRange = 100;

  int get playerColor {
    if (playerColorSelection == 4) {
      return null;
    }
    return playerColorSelection;
  }

  bool get isRated {
    if (currentPublicitySelection == 0) {
      return true;
    }
    return false;
  }

// finish Buttons
  CreateGameCallback createGame(
      {increment,
      time,
      isRated,
      isPublic,
      negRatingRange,
      invitations,
      posRatingRange,
      allowPremades}) {
    print('Create Game');
    _gameProvider.createGame(
      increment: increment,
      time: time,
      invitations: invitations,
      isPublic: isPublic,
      isRated: isRated,
      negRatingRange: negRatingRange,
      posRatingRange: posRatingRange,
      allowPremades: allowPremades,
    );
    Navigator.of(context).pop();
  }

  Function cancelCreateGame() {
    Navigator.of(context).pop();
  }

  bool didCheckForPreInvites = false;
  void checkForPreInvites() {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final String friendId = args['friend'];
    print(friends.length);
    print('friendId');
    print(friendId);
    if (friendId != null) {
      Friend friend = friends.firstWhere((friend) => friend.user.id == friendId,
          orElse: () => null);
      if (friend != null) {
        selectedFriends.add(friend);
        print('Added ${selectedFriends.length} Friends');
        print(friendId);
      }
    }
    didCheckForPreInvites = true;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: Consumer2<UserProvider, FriendsProvider>(
          builder: (context, userProvider, friendsProvider, child) {
        if (!_userInit || !_friendsInit) {
          return Center(child: CircularProgressIndicator());
        }
        user = userProvider.user;
        friends = friendsProvider.friends;
        print(friends);
        if (!didCheckForPreInvites) {
          checkForPreInvites();
        }
        if (posRatingRange == null) {
          posRatingRange = user.score + 100.0;
          negRatingRange = user.score - 100.0;
        }
        return CreateGame(
          allowPremades: allowPremades,
          cancelCreateGame: () => cancelCreateGame(),
          createGame: (model) => createGame(
            invitations:
                selectedFriends.map((friend) => friend.user.id).toList(),
            allowPremades: model.allowPremades,
            increment: model.increment,
            isPublic: model.isPublic,
            isRated: model.isRated,
            negRatingRange: model.negRatingRange,
            posRatingRange: model.posRatingRange,
            time: model.time,
          ),
          currentPublicitySelection: currentPublicitySelection,
          increment: increment,
          incrementDivisions: incrementDivisions,
          incrementMax: incrementMax,
          incrementMin: incrementMin,
          isPublic: isPublic,
          negRatingRange: negRatingRange,
          user: user,
          playerColorSelection: playerColorSelection,
          posRatingRange: posRatingRange,
          size: size,
          time: time,
          selectedFriends: selectedFriends,
          timeDivisions: timeDivisions,
          timeMax: timeMax,
          friends: friends,
          timeMin: timeMin,
          removeFriend: (String id) => removeFriend(id),
          cancelFriendInvitation: () => cancelFriendSelection(),
          confirmFriendInvitations: (List<String> selectedFriendIds) =>
              confirmFriendSelection(selectedFriendIds),
          updateAllowPremades: (bool value) => updateAllowPremades(value),
          updateButtonBarData: (int index) => updateButtonBarData(index),
          updateIncrement: (double value) => updateIncrement(value),
          updateIsPrivate: (bool value) => updateIsPrivate(value),
          updateRatingRange: (RangeValues values) => updateRatingRange(values),
          updatePlayerColorSelection: (int index) =>
              updatePlayerColorSelection(index),
          updateTime: (double value) => updateTime(value),
        );
      }),
    );
  }
}
