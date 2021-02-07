import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/chat_provider.dart';
import '../../../widgets/chat.dart';
import '../../../models/enums.dart';

class ChatBoardSubScreen extends StatefulWidget {
  final double height;
  final ThemeData theme;
  final String chatId;

// Chat Related
  ChatBoardSubScreen({
    this.height,
    this.theme,
    this.chatId,
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
    Provider.of<ChatProvider>(context, listen: false)
        .sendTextMessage(chatController.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => chatFocusNode.unfocus(),
      child: Container(
        height: widget.height,
        child: FutureBuilder(
          future: Provider.of<ChatProvider>(context).selectChatRoom(
              chatType: ChatType.OnlineGame, id: widget.chatId, context: context),
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
                    height: widget.height,
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
      ),
    );
  }
}
