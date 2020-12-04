import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import './server_provider.dart';


class OnlineProvider with ChangeNotifier{
bool inGame;
ServerProvider _serverProvider;
Timer _keepOnlineTimer;

   void update({game, server}){
     print('Update');
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
}