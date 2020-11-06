import 'package:flutter/material.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/piece.dart';
import 'package:three_chess/models/user.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

import '../models/player.dart';
import '../models/user.dart';
import '../models/game.dart';
import '../models/chess_move.dart';
import '../widgets/move_table.dart';
import '../widgets/chat.dart';

class DesignTestScreen extends StatefulWidget {
  static const routeName = '/design-test';

  @override
  _DesignTestScreenState createState() => _DesignTestScreenState();
}

class _DesignTestScreenState extends State<DesignTestScreen> {
  bool showChat = false;

  @override
  Widget build(BuildContext context) {
    Game game = Provider.of<GameProvider>(context).game;
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Design'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            children: <Widget>[
              if (showChat) GameTable(game),
              if (!showChat) Chat(),
              Divider(
                color: Colors.white,
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'showChat',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: showChat,
                    onChanged: (bool newValue) {
                      setState(() {
                        showChat = newValue;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
