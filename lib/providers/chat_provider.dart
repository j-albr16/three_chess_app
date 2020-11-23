import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:three_chess/models/user.dart';

import '../data/server.dart';
import '../providers/server_provider.dart';
import '../models/message.dart';
import '../helpers/user_acc.dart';
import '../models/chat_model.dart';
import '../widgets/friend_list.dart';

class ChatProvider with ChangeNotifier {
  String _userId = constUserId;

  List<Chat> _chats = [];
  int _currentChatIndex;
  ServerProvider _serverProvider;

  void update({chatIndex, chats, serverProvider}) {
    _currentChatIndex = chatIndex;
    _chats = chats;
    _serverProvider = serverProvider;
    notifyListeners();
  }

  List<Chat> get chats {
    return [..._chats];
  }

  int get currentChatIndex {
    return _currentChatIndex;
  }

  Chat get chat {
    if(_chats[_currentChatIndex] == null){
      // TODO
     return new Chat(); 
    }
    return _chats[_currentChatIndex];
  }

  void subsribeToAuthUserChannel(
      {friendRequestCallback,
      friendAcceptedCallback,
      friendDeclinedCallback,
      increaseNewMessageCounterCallback}) {
    _serverProvider.subscribeToAuthUserChannel(
      friendDeclinedCallback: (userId) => friendDeclinedCallback(userId),
      friendAcceptedCallback: (userId) => friendAcceptedCallback(userId),
      friendRequestCallback: (friendData) => friendRequestCallback(friendData),
      messageCallback: (messageData) =>
          _handleMessageData(messageData, increaseNewMessageCounterCallback),
    );
  }

  Future<void> sendTextMessage(String text) async {
    try {
      await _serverProvider.sendMessage(text, chat.id);
    } catch (error) {
      _serverProvider.handleError('error while Sending Text Message', error);
    }
  }

  Future<void> fetchChat({String id, bool isGameChat, bool wasInit}) async {
    // either receive userId or gameId...
    try {
      if (wasInit) {
// TODO : Find Better Solution to amke the decision whether curretn chat should be deleted
        _chats.removeAt(_currentChatIndex);
      }
      // http request
      final Map<String, dynamic> data =
          await _serverProvider.fetchChat(isGameChat, id);
      // convert chat
      _chats.add(_convertChat(data));
      // make shure current chat is the new Chat that was fetched
      _currentChatIndex = _chats.length - 1;
      print("next up fetch print:");
      notifyListeners();
      _printWholeChat(chat);
    } catch (error) {
      _serverProvider.handleError('Error while Fetching Chat', error);
    }
  }

  Future<void> selectChatRoom(String id, {bool isGameChat = false}) async {
    int index = _chats.indexWhere((e) => e.id == id);
    if (index == -1) {
      return await fetchChat(
        id: id,
        isGameChat: isGameChat,
        wasInit: false,
      );
    } else {
      _currentChatIndex = index;
      notifyListeners();
    }
  }

  void _handleMessageData(Map<String, dynamic> messageData,
      Function increaseNewMessageCounterCallback) {
    int chatIndex =
        _chats.indexWhere((chat) => chat.id = messageData['chatId']);
    _chats[chatIndex].messages.add(_rebaseOneMessage(messageData));
    if (chatIndex != _currentChatIndex) {
      //TODO : What should happen if message was received and current chat is not the Chat the Message was sent to
      increaseNewMessageCounterCallback(messageData['userId']);
    }
    notifyListeners();
  }

  _convertChat(Map<String, dynamic> chatData) {
    //converting icoming mesages and sort them into existing classes...
    // for more information look at data models in three_chess_app_node repo
    List<Message> messages = [];
    List<User> users = [];
    chatData['user'].forEach((userData) {
      users.add(_rebaseOneUser(userData));
      chatData['chat']['messages'].forEach((messageData) {
        if (messageData['userId'] == userData['_id']) {
          messages.add(
              _rebaseOneMessage(messageData, userName: userData['userName']));
        }
      });
    });
    return new Chat(
      user: users,
      id: chatData['chat']['_id'],
      messages: messages,
    );
  }

  Message _rebaseOneMessage(Map<String, dynamic> messageData,
      {String userName}) {
    final isYours = messageData['userId'] == _userId;
    return new Message(
      isYours: isYours,
      text: messageData['text'],
      timeStamp: DateTime.parse(messageData['date']),
      userId: messageData['userId'],
      userName: userName ?? messageData['userName'],
    );
  }

  User _rebaseOneUser(Map<String, dynamic> userData) {
    return new User(
      id: userData['_id'],
      score: userData['score'],
      userName: userData['userName'],
    );
  }
}

void _printWholeChat(Chat _chat) {
  if (_chat != null) {
    int playerIndex = 0;
    int messagesIndex = 0;
    print('===============================================');
    print('PRINT CHAT ------------------------------------');
    print('id:         ' + _chat?.id ?? 'null');
    print('user:------------------------------------');
    _chat?.user?.forEach((e) {
      print('player ${playerIndex + 1}-----------------------');
      print('-> id:         ' + e?.id ?? 'null');
      print('-> userName:   ' + e?.userName ?? 'null');
      print('-> score:      ' + e?.score?.toString() ?? 'null');
      playerIndex ++;
    });
    print('messages----------------------------------------');
    _chat?.messages?.forEach((el) {
      print('message ${messagesIndex + 1}--------------------');
      print('-> text:       ' + el?.text ?? 'null');
      print('-> userName:   ' + el?.userName ?? 'null');
      print('-> timeStamp:  ' + el?.timeStamp?.toIso8601String() ?? 'null');
      messagesIndex ++;
    });
    print('===============================================');
  }
}
