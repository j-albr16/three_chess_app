import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/server.dart';

typedef void RecieveMessage(String message);

class ChatListener{
  
  List<RecieveMessage> listener = [];
  IO.Socket _socket = IO.io(SERVER_ADRESS);
  
  addListener(RecieveMessage function){
    listener.add(function);
  }

  removeListener(RecieveMessage function){
    listener.remove(function);
  }

  notifyListener(String myMessage){
    listener.forEach((element) {
      element(myMessage);
    });
  }

  listenForMessages(String id){
    _socket.on('message/$id', (encodedResponse) {
      final data = json.decode(encodedResponse.body);
      return data.toString();
    });
  }
}