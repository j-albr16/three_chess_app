import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import './server_provider.dart';


class OnlineProvider with ChangeNotifier{
bool inGame;
ServerProvider _serverProvider;
Timer _keepOnlineTimer;
Timer _getCountTimer;

int _usersCount = 0;
int _playerCount = 0;
int _gamesCount = 0;

int get usersCount {
  return _usersCount;
}
int get playerCount {
  return _playerCount;
}
int get gamesCount {
  return _gamesCount ;
}
   void update({game, server}){
     _serverProvider = server;
     inGame = game != null; 
     if(inGame){
       setTimer(4);
     }else {
       setTimer(25);
     }
   }
   Future<void> setTimer(int seconds) async {
     print('Set Timer');
     try{
       _keepOnlineTimer?.cancel();
       _keepOnlineTimer = new Timer.periodic(Duration(seconds: seconds), (Timer timer) async { 
         final data = await _serverProvider.onlineStatusUpdate();
       });
     }catch(error){
       _serverProvider.handleError('Error while Setting Online Timer', error);
     }
   }

   Future<void> getCount() async {
     try{
       _getCountTimer?.cancel();
       _getCountTimer = new Timer.periodic(Duration(seconds: 3), (Timer timer) async  {
         // TODO
         final data = await _serverProvider.getCount();
         _gamesCount = data['games'];
         _usersCount = data['users'];
         _playerCount = data['player'];
        });
     }catch(error){
       _serverProvider.handleError('Error while getting Count', error);
     }
   }
   void stopCount(){
     _getCountTimer?.cancel();
   }
}