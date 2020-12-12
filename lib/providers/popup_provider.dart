import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './friends_provider.dart';
import '../models/game.dart';
import '../widgets/end_game.dart';
import '../models/player.dart';
import '../widgets/invitations.dart';
import './game_provider.dart';
import '../models/user.dart';

typedef PopUp(BuildContext context);

class PopupProvider with ChangeNotifier {
  FriendsProvider _friendsProvider;
  GameProvider _gameProvider;

  void update({friendsProvider, gameProvider}) {
    _gameProvider = gameProvider;
    _friendsProvider = friendsProvider;
    _checklForPopUps();
  }

  PopUp _popUp;
  bool hasPopup = false;

  PopUp get popUp {
    return _popUp;
  }

  void _checklForPopUps() {
    // Invitation PopUps
  if(_gameProvider.hasPopup){
    _gameProvider.hasPopup = false;
    makeEndGamePopup(_gameProvider);
    notifyListeners();
  }
    else if (_friendsProvider.newInvitation) {
      _friendsProvider.newInvitation = false;
      makeInvitationPopup(_friendsProvider.invitations.last);
      notifyListeners();
    }
    else if (_friendsProvider.newNotification) {
      makeSnackBar(_friendsProvider.notification);
      _friendsProvider.notification = null;
      _friendsProvider.newNotification = false;
      notifyListeners();
    }
  }

  displayPopup(BuildContext context) {
    if (hasPopup) {
      _popUp(context);
      _popUp = null;
      hasPopup = false;
    }
  }
   void makeEndGamePopup(GameProvider gameProvider){
    _popUp = (BuildContext context) => showDialog(context: context,
    builder: (context){
      Size size = MediaQuery.of(context).size;
      return EndGameAlertDialog(
        game: gameProvider.game,
        inspect: (){},
        leave: (){
          gameProvider.removeGame();
          Navigator.of(context).pop();
        },
        rematch: (){},
        size: Size(size.width * 0.75, size.height * 0.75),
        you: gameProvider.player,
      );
    });
    hasPopup = true;
  }


  void makeSnackBar(String message) {
    _popUp = (BuildContext context) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(basicSnackbar(message));
    };
    hasPopup = true;
  }

  SnackBar basicSnackbar(String text) {
    return SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
    );
  }

  void makeInvitationPopup(Game game) {
    _popUp = (BuildContext context) => showDialog(
          context: context,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            new Timer(Duration(seconds: 20), () => Navigator.of(context).pop());
            return invitationDialog(game, size, context);
          },
        );
    hasPopup = true;
  }

  invitationDialog(Game game, Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 1,
            child: Container(
              width: size.width - 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Invitations.invitationTile(
                accept: () {
                  print('Here You will join the Game');
                  Navigator.of(context).pop();
                },
                decline: () => Navigator.of(context).pop(),
                game: game,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
