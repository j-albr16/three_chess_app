import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../screens/board_screen.dart';
import './friends_provider.dart';
import '../models/online_game.dart';
import '../widgets/end_game.dart';
import '../helpers/sound_player.dart';
import '../widgets/invitations/invitations.dart';
import '../models/player.dart';
import './game_provider.dart';
import '../providers/lobby_provider.dart';
import '../models/enums.dart';

typedef PopUp(BuildContext context);
typedef PopUp EndGamePopUp(
    {OnlineGame onlineGame, Player player, Function removeGameCallback});
typedef PopUp InvitationPopUp(OnlineGame onlineGame);
typedef PopUp SnackBarPopUp(String text);
typedef PopUp GameStarts();

class PopupProvider with ChangeNotifier {
  FriendsProvider _friendsProvider;
  GameProvider _gameProvider;

  PopUp _popUp;
  bool hasPopup = false;

  PopUp get popUp {
    return _popUp;
  }

  Map<PopUpType, Function> get makePopUp {
    print('Trying to display PopUp');
    return {
      PopUpType.Endgame:
          (OnlineGame onlineGame, Player player, Function removeGameCallback) =>
              makeEndGamePopup(
                  onlineGame: onlineGame,
                  player: player,
                  removeGameCallback: removeGameCallback) as EndGamePopUp,
      PopUpType.Invitation: (OnlineGame onlineGame) =>
          makeInvitationPopup(onlineGame) as InvitationPopUp,
      PopUpType.SnackBar: (String text) => makeSnackBar(text) as SnackBarPopUp,
      PopUpType.GameStarts: () => gameStarts(),
    };
  }

  void displayPopup(BuildContext context) {
    if (hasPopup) {
      print('Displaying PopUp');
      _popUp(context);
      _popUp = null;
      hasPopup = false;
    }
  }

  void gameStarts() {
    _popUp = (BuildContext context) =>
        Navigator.of(context).pushNamed(BoardScreen.routeName);
    hasPopup = true;
    notifyListeners();
  }

  void makeEndGamePopup(
      {OnlineGame onlineGame, Player player, removeGameCallback}) {
    _popUp = (BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return EndGameAlertDialog(
            finishedGameData: onlineGame.finishedGameData,
            player: onlineGame.player,
            inspect: () {},
            leave: () {
              removeGameCallback();
              Navigator.of(context).pop();
            },
            rematch: () {},
            size: Size(size.width * 0.75, size.height * 0.75),
            you: player,
          );
        });
    hasPopup = true;
    notifyListeners();
  }

  void makeSnackBar(String text) {
    print('Displaying Snack Bar Message');
    _popUp = (BuildContext context) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(basicSnackBar(text));
    };
    hasPopup = true;
    notifyListeners();
  }

  SnackBar basicSnackBar(String text) {
    return SnackBar(
      content: Text(text ?? 'Could not get Text'),
      duration: Duration(seconds: 2),
    );
  }

  void makeInvitationPopup(OnlineGame game) {
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
    notifyListeners();
  }

  invitationDialog(OnlineGame game, Size size, BuildContext context) {
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
                  gProvider.joinGame(context, game.id);
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
