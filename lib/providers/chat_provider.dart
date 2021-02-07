import 'dart:async';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/user.dart';

import '../providers/server_provider.dart';
import '../helpers/user_acc.dart';
import '../models/chat_model.dart';
import './game_provider.dart';
import '../conversion/chat_conversion.dart';
import '../providers/lobby_provider.dart';
import '../providers/popup_provider.dart';

class ChatProvider with ChangeNotifier {
  String _userId = constUserId;

  List<Chat> _chats = [];
  int _currentChatIndex;
  ServerProvider _serverProvider;
  PopupProvider _popUpProvider;

  void update({chatIndex,chats,ServerProvider serverProvider, PopupProvider popUpProvider}) {
    print('Update Chat');
    _currentChatIndex = chatIndex;
    _chats = chats;
    _serverProvider = serverProvider;
    _popUpProvider = popUpProvider;
    notifyListeners();
  }

  List<Chat> get chats {
    return [..._chats];
  }

  int get currentChatIndex {
    return _currentChatIndex;
  }

  Chat get chat {
    if (_currentChatIndex == null) {
      return new Chat();
    }
    if (_chats[_currentChatIndex] == null) {
      // TODO
      return new Chat();
    }
    return _chats[_currentChatIndex];
  }

  void subscribeToAuthUserChannel({
    friendRequestCallback,
    friendAcceptedCallback,
    friendDeclinedCallback,
    increaseNewMessageCounterCallback,
    friendRemovedCallback,
    friendIsOnlineCallback,
    friendIsAfkCallback,
    friendIsPlayingCallback,
    friendIsNotPlayingCallback,
    gameInvitationCallback,
  }) {
    _serverProvider.subscribeToAuthUserChannel(
      friendRemovedCallback: (String userId, String message) =>
          friendRemovedCallback(userId, message),
      friendDeclinedCallback: (message) => friendDeclinedCallback(message),
      friendAcceptedCallback: (data) => friendAcceptedCallback(data),
      friendRequestCallback: (friendData, message) =>
          friendRequestCallback(friendData, message),
      friendIsOnlineCallback: (userId) => friendIsOnlineCallback(userId),
      friendIsAfkCallback: (userId) => friendIsAfkCallback(userId),
      friendIsPlayingCallback: (userId) => friendIsPlayingCallback(userId),
      friendIsNotPlayingCallback: (userId) =>
          friendIsNotPlayingCallback(userId),
      messageCallback: (messageData) =>
          _handleMessageData(messageData, increaseNewMessageCounterCallback),
      gameInvitationsCallback: (gameData) => gameInvitationCallback(gameData),
    );
  }

  void resetCurrentChat() {
    _currentChatIndex = null;
    // notifyListeners();
  }

  Future<void> sendTextMessage(String text) async {
    try {
      await _serverProvider.sendMessage(text, chat.id);
    } catch (error) {
      _serverProvider.handleError('error while Sending Text Message', error);
    }
  }

  Future<void> fetchChat(
      {String id,
      ChatType chatType = ChatType.Friend,
      BuildContext context}) async {
    // either receive userId or gameId...
    try {
      final Map<String, dynamic> data =
          await _serverProvider.fetchChat(chatType, id);
      // convert chat
      _chats.add(ChatConversion.convertChat(data, _userId));
      // make shure current chat is the new Chat that was fetched
      _currentChatIndex = _chats.length - 1;
      if (chatType == ChatType.Lobby) {
        Provider.of<LobbyProvider>(context, listen: false)
            .setChatId(id, chat.id);
      }
      if (chatType == ChatType.OnlineGame) {
        Provider.of<GameProvider>(context, listen: false)
            .setChatId(id, chat.id);
      }
      print("next up fetch print:");
      ChatConversion.printWholeChat(chat);
      print(_chats);
    } catch (error) {
      _serverProvider.handleError('Error while Fetching Chat', error);
    }
  }

  // Future<void> getMoreMessages(Chat chat) async {
  //   try {
  //     final Map<String, dynamic> data =
  //         await _serverProvider.getMoreMessages(chat.id, chat.messages.length);
  //     data['messages'].forEach((message) {
  //       User owner =
  //           chat.user.firstWhere((user) => user.id == message['userId']);
  //       _chats[_currentChatIndex].messages.add(ChatConversion.rebaseOneMessage(
  //           message, _userId,
  //           userName: owner.userName));
  //     });
  //     notifyListeners();
  //   } catch (error) {
  //     _serverProvider.handleError('Error While getting more Messages', error);
  //   }
  // }

  Future<void> selectChatRoom(
      {String id = '',
      ChatType chatType = ChatType.Friend,
      BuildContext context}) async {
    int index = _chats.indexWhere((chat) =>
        chat.user.firstWhere((u) => u.id == id, orElse: () => null) != null ||
        chat.id == id);
    if (index == -1) {
      await fetchChat(
        id: id,
        chatType: chatType,
        context: context,
      );
      if (chatType == ChatType.Friend) {
        return notifyListeners();
      }
      return;
    } else {
      _currentChatIndex = index;
      notifyListeners();
    }
  }

  void _handleMessageData(Map<String, dynamic> messageData,
      Function increaseNewMessageCounterCallback) {
    print('Message was Received');
    int chatIndex =
        _chats.indexWhere((chat) => chat.id == messageData['chatId']);
    if (chatIndex != _currentChatIndex || chatIndex == -1) {
      //TODO : What should happen if message was received and current chat is not the Chat the Message was sent to
      print(messageData['userId']);
      increaseNewMessageCounterCallback(messageData['userId']);
    }
    if (chatIndex != -1) {
      _chats[chatIndex]
          .messages
          .add(ChatConversion.rebaseOneMessage(messageData, _userId));
    }
    notifyListeners();
  }
}
