import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:three_chess/models/user.dart';

import '../data/server.dart';
import '../models/message.dart';
import '../helpers/user_acc.dart';
import '../models/chat_model.dart';

typedef void RecieveMessage(Message message);

// typedef void FetchMessages(List<Message> messages);

class ChatListener {
  IO.Socket _socket = IO.io(SERVER_ADRESS);
  String _token = constToken;
  String _userId = constUserId;
  String _chatId = '5fa92b642a0f111da099cb4c';

  Chat _chat;

  ChatListener() {}

  get chat {
    return _chat;
  }

  // List<FetchMessages> messagesListener = [];
  List<RecieveMessage> messageListener = [];
  List<Function> listener = [];

  void addListener(Function function) {
    listener.add(function);
  }

  void removeListener(Function function) {
    listener.remove(function);
  }

  void notifyListener() {
    listener.forEach((e) => e());
  }

//listener for one new message
  void addMessageListener(RecieveMessage function) {
    messageListener.add(function);
  }

  void removeMessageListener(RecieveMessage function) {
    messageListener.remove(function);
  }

  void notifyMessageListener(myMessage) {
    messageListener.forEach((element) {
      element(myMessage);
    });
  }

  listenForMessages() async {
    print('Connected to Socket');
    // print(_chatId);
    print(_chatId);
    _socket.on(_chatId, (encodedResponse) {
      // _socket.on('chat', (encodedResponse) {
      print('received Message via socket');
      final data = json.decode(encodedResponse);
      print(data.toString());
      final message = new Message(
        text: data['textMessage'],
        timeStamp: data['timeStamp'],
        userName: data['userName'],
        isYours: data['userId'] == _userId,
      );
      _chat.messages.add(message);
      notifyMessageListener(message);
      _printWholeChat(_chat);
    });
  }

  Future<void> sendTextMessage(String text) async {
    final url = SERVER_ADRESS + '/send-message' + '?auth=$_token&id=$_userId';
    await http.post(url,
        body: json.encode({'message': text, 'chatId': _chatId}),
        headers: {'Content-Type': 'application/json'});
    // _chat.messages.add(new Message(
    //   text: text,
    //   timeStamp: DateTime.now(),
    //   userName: _chat.you.userName,
    //   isYours: true,
    // ));
    // notifyListener();
    // _printWholeChat(_chat);
  }

  Future<void> fetchChat() async {
    print('fetch Chat');
    final url = SERVER_ADRESS +
        '/fetch-chat' +
        '?chatId=$_chatId&auth=$_token&id=$_userId';
    final encodedResponse = await http.get(url);
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    if (data == null) {
      throw ('No server Response was sent');
    }
    print('data:   ' + data.toString());
    if (!data['valid']) {
      print(data['message']);
      throw ('Data is not vaild' + data['message']);
    }
    print(data['message']);
    print(data.toString());
    _chat = _convertChat(data);
    print("next up fetch print:");
    _printWholeChat(_chat);
    notifyListener();
  }

  void switchChatroom(String rId) {
    _chatId = rId;
  }

  _convertChat(dynamic data) {
    //converting icoming mesages and sort them into existing classes...
    // for more information look at data models in three_chess_app_node repo
    List<Message> messages = [];
    User you;
    data['chat']['messages'].forEach((mes) {
      String userName;
      bool isYours = false;
      if (_userId == mes['userId']) {
        isYours = true;
      }
      data['user'].forEach((el) {
        print('vergleiche userIds:   ');
        print('mes userId:   ' + mes['userId']);
        print('el userId:   ' + el['userId']);
        print(el['userId'] == mes['userId']);
        if (el['userId'] == mes['userId']) {
          userName = el['userName'];
          print(userName);
        }
        if (el['userId'] == _userId) {
          you = new User(
            id: _userId,
            score: el['score'],
            userName: el['userName'],
          );
        }
      });
      messages.add(new Message(
        isYours: isYours,
        text: mes['text'],
        timeStamp: DateTime.parse(mes['date']),
        userId: mes['userId'],
        userName: userName,
      ));
    });
    // converting user
    List<User> user = [];
    data['user'].forEach((e) {
      user.add(new User(
        id: e['userId'],
        score: e['score'],
        userName: e['userName'],
      ));
    });
    return new Chat(
      chatPartner: user,
      id: data['chat']['_id'],
      messages: messages,
      you: you,
    );
  }
}

void _printWholeChat(Chat _chat) {
  if (_chat != null) {
    int playerIndex = 0;
    int messagesIndex = 0;
    print('===============================================');
    print('PRINT CHAT ------------------------------------');
    print('id:         ' + _chat.id ?? 'null');
    print('------------------------------------------------');
    print('you:--------------------------------------------');
    print('id:         ' + _chat.you?.id ?? 'null');
    print('userName:   ' + _chat.you?.userName ?? 'null');
    print('score:      ' + _chat.you?.score?.toString() ?? 'null');
    print('------------------------------------------------');
    print('chatPartner:------------------------------------');
    _chat.chatPartner.forEach((e) {
      print('player ${playerIndex + 1}-----------------------');
      print('-> id:         ' + _chat.you?.id ?? 'null');
      print('-> userName:   ' + _chat.you?.userName ?? 'null');
      print('-> score:      ' + _chat.you?.score?.toString() ?? 'null');
    });
    print('------------------------------------------------');
    print('messages----------------------------------------');
    _chat.messages.forEach((el) {
      print('message ${messagesIndex + 1}--------------------');
      print('-> text:       ' + el?.text ?? 'null');
      print('-> userName:   ' + el?.userName ?? 'null');
      print('-> timeStamp:  ' + el.timeStamp.toIso8601String() ?? 'null');
    });
    print('===============================================');
  }
}
