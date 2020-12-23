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

class ChatBoardSubScreen extends StatelessWidget {
  final double height;
  final ScrollController scrollController;
  final bool maxScrollEntend;
  final TextEditingController chatController;
  final FocusNode chatFocusNode;
  final Function submitMessage;
  final ThemeData theme;
  final bool chatInit;

  ChatBoardSubScreen({
    this.height,
    this.chatInit,
    this.submitMessage,
    this.scrollController,
    this.maxScrollEntend,
    this.chatFocusNode,
    this.chatController,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return chatInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: Chat(
              chat: Provider.of<ChatProvider>(context).chat,
              chatController: chatController,
              chatFocusNode: chatFocusNode,
              lobbyChat: true,
              maxScrollExtent: maxScrollEntend,
              scrollController: scrollController,
              size: Size(400, height),
              submitMessage: submitMessage,
              theme: theme,
            ),
          );
  }
}
