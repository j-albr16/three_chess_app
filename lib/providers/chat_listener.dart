import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/server.dart';
import '../models/message.dart';

typedef void RecieveMessage(Message message);

// typedef void FetchMessages(List<Message> messages);

class ChatListener {
  String _token;
  String _userId;
  String _receiverId;

  List<Message> _messages = [];

  get messages{
    return [..._messages];
  }

  // List<FetchMessages> messagesListener = [];
  List<RecieveMessage> messageListener = [];
  List<Function> listener = [];

  IO.Socket _socket = IO.io(SERVER_ADRESS);

void addListener(Function function){
  listener.add(function);
}
void removeListener(Function function){
  listener.remove(function);
}
void notifyListener(){
  listener.forEach((e) => e());
}

//listener for one new message
void addMessageListener(RecieveMessage function) {
    messageListener.add(function);
  }
 void  removeMessageListener(RecieveMessage function) {
    messageListener.remove(function);
  }
 void  notifyMessageListener(myMessage) {
    messageListener.forEach((element) {
      element(myMessage);
    });
  }

  void listenForMessages(String id) {
    _socket.on('message/$id', (encodedResponse) {
      final data = json.decode(encodedResponse.body);
      notifyMessageListener(data.toString());
    });
  }

  void sendTextMessage(String text) async {
    final url = SERVER_ADRESS + '/send-message' + '?auth=$_token&id=$_userId';
    await http.post(url,
        body: json.encode({'message': text, 'receiver': _receiverId}),
        headers: {'Content-Type': 'application/json'});
  }

  void switchChatroom(String rId){
    _receiverId = rId;
  }
}
