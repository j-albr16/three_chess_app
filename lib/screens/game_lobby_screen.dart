import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/enums.dart';

import '../widgets/chat.dart' as widget;
import '../providers/lobby_provider.dart';
import '../providers/game_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/basic/sorrounding_cart.dart';
import '../models/chat_model.dart';
import '../models/player.dart';
import '../widgets/friends/friend_tile.dart';
import '../widgets/basic/chess_divider.dart';

class GameLobbyScreen extends StatefulWidget {
  static String routeName = '/game-lobby-screen';

  @override
  _GameLobbyScreenState createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends State<GameLobbyScreen> {
  Widget mainLobbyWidget(){
    return Column(
      children: [],
    );
  }
  Widget playersWidget(List<Player> players){
    return SorroundingCard(
      child: Column(
        children: players.map((player) => playerWidget(player)).toList(),
      ),
    );
  }

  Widget playerWidget(Player player){
    return Column(
      children: [
        FriendTile(
          model: FriendTileModel(
            userId: player.user.id,
            username: player.user.userName,
            isOnline: player.isOnline,
            isPlaying: true,
          ),
        ),
        ChessDivider()
      ],
    );
  }

  Widget chatWidget(Chat chat) {
    return SorroundingCard(
      child: widget.Chat(
        chat: chat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Lobby'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(child: mainLobbyWidget(), flex: 2),
            Flexible(
              flex: 3,
              child: FutureBuilder(
                  future: Provider.of<ChatProvider>(context, listen: false)
                      .selectChatRoom(
                          chatType: ChatType.Lobby,
                          context: context,
                          id: arguments['gameId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) =>
                            chatWidget(chatProvider.chat));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
