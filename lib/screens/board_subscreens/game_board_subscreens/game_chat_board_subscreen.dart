import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/chat_provider.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../../../models/chess_move.dart';
import '../../../models/chat_model.dart' as model;
import '../../../widgets/board_boarding_widgets.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/three_chess_board.dart';
import '../../../widgets/chat.dart';
import 'package:relative_scale/relative_scale.dart';

class ChatBoardSubScreen extends StatefulWidget {
  final double height;
  final ThemeData theme;
// Chat Related
  ChatBoardSubScreen({
    this.height,
    this.theme,
  });

  @override
  _ChatBoardSubScreenState createState() => _ChatBoardSubScreenState();
}

class _ChatBoardSubScreenState extends State<ChatBoardSubScreen> {
  ScrollController chatScrollController;
  FocusNode chatFocusNode;
  TextEditingController chatController;
  bool maxScrollExtend = false;

  void _scrollListener() {
    if (chatScrollController.offset ==
            chatScrollController.position.maxScrollExtent &&
        !chatScrollController.position.outOfRange) {
      maxScrollExtend = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    chatScrollController = ScrollController();
    chatController = TextEditingController();
    chatFocusNode = FocusNode();
    chatScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<ChatProvider>(context, listen: false).resetCurrentChat();
    // chatProvider.resetCurrentChat();
    chatFocusNode.dispose();
    chatController.dispose();
    chatScrollController.dispose();
    super.dispose();
  }

  void submitMessage(String text) {
    Provider.of<ChatProvider>(context).sendTextMessage(chatController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: FutureBuilder(
        future: Provider.of<ChatProvider>(context).fetchChat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ChatProvider>(
              builder: (context, chatProvider, child) => Container(
                child: Chat(
                  chat: chatProvider.chat,
                  chatController: chatController,
                  chatFocusNode: chatFocusNode,
                  lobbyChat: true,
                  maxScrollExtent: maxScrollExtend,
                  scrollController: chatScrollController,
                  size: Size(400, widget.height),
                  submitMessage: (String text) => submitMessage(text),
                  theme: widget.theme,
                ),
              ),
            );
          } else {
            return Text('Could not Fetch Chat. Sorry');
          }
        },
      ),
    );
  }
}
