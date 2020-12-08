import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './friends_provider.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';

typedef PopUp(BuildContext context);

class PopupProvider with ChangeNotifier {
  FriendsProvider _friendsProvider;

  void update({context, friendsProvider}) {
    _friendsProvider = friendsProvider;
  }

  List<PopUp> _popUps = [];

  List<PopUp> get popUps {
    return [..._popUps];
  }

  void _checklForPopUps() {
    // Invitation PopUps
    if (_friendsProvider.newPopup) {
      _friendsProvider.newPopup = false;
      makeInvitationPopup(_friendsProvider.invitations.last);
      notifyListeners();
    }
  }

  Widget displayPopups(BuildContext context) {
    _popUps.forEach((popUp) {
      popUp(context);
    });
  }

  void makeInvitationPopup(Game game) {
    Function invitationPopup = (BuildContext context) => showDialog(
          context: context,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            return Container(
              height: size.height * 0.1,
              width: size.width * 0.35,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Game Invitation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
    _popUps.add(invitationPopup);
  }

  Widget gameInfos(String userName, int time, int increment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(userName),
        Text(time.toString() + ' + ' + increment.toString()),
      ],
    );
  }
}
