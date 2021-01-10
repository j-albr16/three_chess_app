import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';


class GameTestScreen extends StatelessWidget {

  static const routeName = '/game-test-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: FutureBuilder(
        future: Provider.of<GameProvider>(context, listen: false).fetchAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } 
          if(snapshot.error){
            print(snapshot.error);
          }
          return Consumer<GameProvider>(
            builder: (context, value, child) {
              return Center(
          child: ListView.builder(
            itemCount: value.games.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                print('Pressed Button... try joining the Game');
                Provider.of<GameProvider>(context, listen: false).joinGame(value.games[index].id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(index.toString()),
                  Text(value.games[index].id),
                  Text(value.games[index].time.toString()),
                ],
              ),
            ),
          ),
        );
            },
          );
        },
      ),
    );
  }
}