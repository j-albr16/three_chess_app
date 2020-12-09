import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './friends_provider.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../widgets/invitations.dart';
import './game_provider.dart';
import '../models/user.dart';

typedef PopUp(BuildContext context);

class PopupProvider with ChangeNotifier {
  FriendsProvider _friendsProvider;

  void update({friendsProvider}) {
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
    if (_friendsProvider.newInvitation) {
      _friendsProvider.newInvitation = false;
      makeInvitationPopup(_friendsProvider.invitations.last);
      notifyListeners();
    }
  }

  displayPopup(BuildContext context) {
    if (hasPopup) {
      _popUp(context);
      _popUp = null;
    }
  }

  void makeInvitationPopup(Game game) {
    _popUp = (BuildContext context) => showDialog(
          context: context,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            new Timer(Duration(seconds: 20), () => Navigator.of(context).pop());
            return invitationWidget(game, size, context);
          },
        );
    hasPopup = true;
  }

  invitationWidget(Game game, Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Positioned(
            height: 30,
            left: 30,
            child: Container(
              height: size.height * 0.1,
              width: size.width * 0.35,
              alignment: Alignment.topLeft,
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
                size: Size(size.width * 0.34, size.height * 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
