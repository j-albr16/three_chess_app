import 'package:flutter/material.dart';

import './create_game_screen.dart';


class LobbyScreen extends StatefulWidget {

  static const routeName = '/lobby-screen';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        actions: [
          IconButton(color: Colors.white, icon: Icon(Icons.add), onPressed: (){
            return Navigator.of(context).pushNamed(CreateGameScreen.routeName);
          },),
          SizedBox(width: 20)
        ],
         title: Text('Lobby'),
       ),
       body: Column(
         children: <Widget> [
           
         ]
       ),
    );
  }
}