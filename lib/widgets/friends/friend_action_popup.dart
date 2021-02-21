import 'package:flutter/material.dart';

import './friend_tile.dart';
import '../../screens/friends_screen.dart';
import '../../models/friend.dart';

class FriendActionPopUp extends StatelessWidget {
  final Friend model;

  FriendActionPopUp({this.model});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold),
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
                color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold),
          )),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, model.isPlaying ? FriendAction.Watch : null);
          },
          child: Center(
              child: Text(
            model.isPlaying ?? false
                ? 'Watch him Play!'
                : "He ain't Playing right now!",
            style: TextStyle(
                color: model.isPlaying ?? false ? Colors.green : Colors.grey,
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
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          )),
        ),
      ],
    );
    ;
  }
}
