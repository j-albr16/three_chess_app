import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/screens/screen_bone.dart';
import 'package:three_chess/widgets/basic/switch_row.dart';

import '../widgets/chat.dart' as widget;
import '../providers/lobby_provider.dart';
import '../providers/game_provider.dart';
import '../models/online_game.dart';
import '../providers/chat_provider.dart';
import '../widgets/basic/sorrounding_cart.dart';
import '../widgets/lobby/lobby_player_tile.dart';
import '../widgets/lobby/options_widget.dart';
import '../models/chat_model.dart';
import '../models/player.dart';
import '../widgets/friends/friend_tile.dart';
import '../models/game.dart';
import '../helpers/constants.dart';
import '../widgets/basic/chess_divider.dart';

class GameLobbyScreen extends StatefulWidget {
  static String routeName = '/game-lobby-screen';

  @override
  _GameLobbyScreenState createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends State<GameLobbyScreen>
    with notificationPort<GameLobbyScreen> {
  ThemeData theme;
  OnlineGame game;

  LobbyProvider _lobbyProvider;
  LobbyProvider lobbyProvider;

  TextEditingController textController;
  ScrollController scrollController;
  FocusNode chatFocusNode;
  ChatProvider chatProvider;
  bool maxScrollExtent = false;
  bool _wasInit = false;

  bool _chatOpen = false;
  bool _optionsOpen = false;

  void leaveLobby() {}

  void switchOptionsOpen() {
    setState(() {
      _optionsOpen = !_optionsOpen;
    });
  }

  void switchChatOpen() {
    setState(() {
      _chatOpen = !_chatOpen;
    });
  }

  void submitMessage(String text) {
    chatProvider.sendTextMessage(text);
  }

  Future<void> getChat() {
    if (!_wasInit) {
      return Provider.of<ChatProvider>(context, listen: false)
          .selectChatRoom(
              chatType: ChatType.Lobby,
              context: context,
              id: game.chatId ?? game.id)
          .then((_) => setState(() {
                _wasInit = true;
              }));
    }
    return null;
  }

  Widget optionsWidget(ThemeData theme) {
    return SurroundingCard(
      child: Column(
        children: [
          switchTitle(
            switchCall: () => switchOptionsOpen(),
            switchBool: _optionsOpen,
            theme: theme,
            title: 'Options',
          ),
          SizedBox(height: 6),
          if (_optionsOpen)
            OptionsWidget(
              onlineGame: game,
            ),
        ],
      ),
    );
  }

  Widget chatWidget(Chat chat, ThemeData theme, double height) {
    return SurroundingCard(
      child: Column(
        children: [
          if (!chatFocusNode.hasFocus)
            switchTitle(
              theme: theme,
              switchBool: _chatOpen,
              switchCall: () => switchChatOpen(),
              title: 'Chat',
            ),
          if (_chatOpen)
            SizedBox(
              height: height,
              child: chat.id == null
                  ? Text('No Chat')
                  : widget.Chat(
                      chat: chat,
                      chatController: textController,
                      noSorrounding: true,
                      chatFocusNode: chatFocusNode,
                      lobbyChat: true,
                      maxScrollExtent: maxScrollExtent,
                      scrollController: scrollController,
                      submitMessage: (text) => submitMessage(text),
                      theme: theme,
                    ),
            ),
        ],
      ),
    );
  }

  Widget mainLobbyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          playersWidget(game.player),
          optionsWidget(theme),
        ],
      ),
    );
  }

  static Widget switchTitle(
      {Function switchCall, ThemeData theme, bool switchBool, String title}) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: switchCall,
            child: Text(title, style: theme.textTheme.headline1),
          ),
        ),
        Switch(value: switchBool, onChanged: (value) => switchCall())
      ],
    );
  }

  Widget playersWidget(List<Player> players) {
    return SurroundingCard(
      child: Column(
        children:
            players.map((player) => playerWidget(player, players)).toList(),
      ),
    );
  }

  static bool getIsPremade(String userId, List<Player> players) {
    players.forEach((player) {
      if (player.user.friendIds.contains(userId)) {
        return true;
      }
    });
    return false;
  }

  Widget playerWidget(Player player, List<Player> players) {
    return Column(
      children: [
        LobbyPlayerTile(
          onTap: (_) {},
          onLongTap: (_) {},
          model: player,
          isPremade: getIsPremade(player.user.id, players),
        ),
      ],
    );
  }

  Widget bottomButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: _bottomButton(
              theme: theme, callback: () => leavePendingGame(), text: 'Leave'),
        ),
        Flexible(flex: 1, child: _isReadySwitch(theme)),
      ],
    );
  }

  Widget _isReadySwitch(ThemeData theme) {
    bool isReady = _lobbyProvider.getYouPlayer(game.id).isReady;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Ready', style: theme.textTheme.bodyText1),
        Switch(
          value: isReady,
          onChanged: (isReady) => updateReadyState(isReady),
          activeColor: Colors.green,
        ),
      ],
    );
  }

  void leavePendingGame() {
    _lobbyProvider.leaveLobby(game.id).then((valid) {
      if (valid) {
        Navigator.of(context).pop();
      }
    });
  }

  void updateReadyState(bool iReady) {
    setState(() {
      _lobbyProvider.setIsReady(iReady, game.id);
    });
    _lobbyProvider
        .updateReadyState(isReady: iReady, gameId: game.id)
        .then((valid) {
      if (!valid) {
        setState(() {
          _lobbyProvider.setIsReady(!iReady, game.id);
        });
      }
    });
  }

  Widget _bottomButton({Function callback, ThemeData theme, String text}) {
    return TextButton(
        onPressed: callback,
        child: Text(text),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius))),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    lobbyProvider = Provider.of<LobbyProvider>(context);
    game = lobbyProvider.pendingGame;
    Size size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    // printGameModel(game);
    return GestureDetector(
      onTap: () => chatFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Game Lobby'),
        ),
        body: game == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: <Widget>[
                    Expanded(child: mainLobbyWidget()),
                    FutureBuilder(
                        future: getChat(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            SnackBar snackBar = SnackBar(
                                content: Text('Could not retrieve Chat'),
                                duration: Duration(seconds: 2));
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return Text('No Chat');
                          } else {
                            return Consumer<ChatProvider>(
                                builder: (context, chatP, child) => chatWidget(
                                    chatP.chat, theme, size.height * 0.4));
                          }
                        }),
                    bottomButtons(theme),
                  ],
                ),
              ),
      ),
    );
  }

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      maxScrollExtent = true;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) =>
        chatProvider = Provider.of<ChatProvider>(context, listen: false));
    textController = TextEditingController();
    scrollController = ScrollController();
    _lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    scrollController.addListener(_scrollListener);
    chatFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    chatProvider.resetCurrentChat();
    chatFocusNode.dispose();
    super.dispose();
  }

  void printGameModel(OnlineGame onlineGame) {
    print('Online Game');
    print(onlineGame?.id);
    print(onlineGame?.chatId);
  }
}
