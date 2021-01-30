import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


import '../screens/board_screen.dart';
import './friends_provider.dart';
import '../models/game.dart';
import '../widgets/end_game.dart';
import '../helpers/sound_player.dart';
import '../widgets/invitations/invitations.dart';
import './game_provider.dart';
import '../providers/lobby_provider.dart';

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
    if (_gameProvider.hasPopup && _gameProvider.hasGame) {
      _gameProvider.hasPopup = false;
      makeEndGamePopup(_gameProvider);
      notifyListeners();
    } else if (_friendsProvider.newInvitation) {
      _friendsProvider.newInvitation = false;
      makeInvitationPopup(_friendsProvider.invitations.last);
      notifyListeners();
    } else if (_gameProvider.hasMessage) {
      makeSnackBar(_gameProvider.popUpMessage);
      _gameProvider.hasMessage = false;
      _gameProvider.popUpMessage = null;
      notifyListeners();
    } else if (_friendsProvider.newNotification) {
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

  void makeEndGamePopup(GameProvider gameProvider) {
    _popUp = (BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return EndGameAlertDialog(
            finishedGameData: _gameProvider.onlineGame.finishedGameData,
            player: _gameProvider.onlineGame.player,
            inspect: () {},
            leave: () {
              gameProvider.removeGame();
              Navigator.of(context).pop();
            },
            rematch: () {},
            size: Size(size.width * 0.75, size.height * 0.75),
            you: gameProvider.player,
          );
        });
    hasPopup = true;
  }

  void makeSnackBar(String message) {
    _popUp = (BuildContext context) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(basicSnackbar(message));
    };
    hasPopup = true;
  }

  SnackBar basicSnackbar(String text) {
    return SnackBar(
      content: Text(text ?? 'Could not get Text'),
      duration: Duration(seconds: 2),
    );
  }

  void makeInvitationPopup(Game game) {
    _popUp = (BuildContext context) => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            new Timer(Duration(seconds: 20), () => Navigator.of(context).pop());
            return invitationDialog(game, size, context);
          },
        );
    Sounds.playSound(Sound.SocialNotify);
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
                  LobbyProvider gProvider =
                      Provider.of<LobbyProvider>(context, listen: false);
                  gProvider.joinGame(game.id).then((valid) {
                    if (valid) {
                      Navigator.of(context).pushNamed(BoardScreen.routeName);
                    }
                  });
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
