import 'package:flutter/material.dart';
import 'package:three_chess/models/user.dart';

import '../models/player.dart';
import '../models/user.dart';

class DesignTestScreen extends StatelessWidget {
  static const routeName = '/design-test';

  List<Player> dummyPlayer = [
    Player(
      user: User(
        userName: 'jan',
      ),
    ),
    Player(
      user: User(
        userName: 'leo',
      ),
    ),
    Player(
      user: User(
        userName: 'david',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Design'),
      ),
      body: Table(dummyPlayer),
    );
  }
}

Widget Table(List<Player> player) {
  return Container(
    width: 700,
    height: 700,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 3.0,
          spreadRadius: 0,
          offset: Offset(2.0, 2.0),
        )
      ],
    ),
    child: Column(
      children: <Widget>[
        Row(
          children: [...player.map((e) => PlayerItem(e.user.userName, true))],
        ),
      ],
    ),
  );
}

Widget PlayerItem(String playerName, bool isConnected) {
  return GestureDetector(
    child: Card(
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(width: 5,),
        Text(
          playerName ?? 'is Null',
          style: TextStyle(fontSize: 50),
        ),
      ]),
    ),
  );
}
