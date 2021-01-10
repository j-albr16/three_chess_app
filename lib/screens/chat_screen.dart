import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat.dart' as wig;
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _chatController;
  ScrollController _scrollController;
  ChatProvider _chatProvider;
  bool maxScrollExtent = false;
  FocusNode chatFocusNode;

  _scrollListener() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      maxScrollExtent = true;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) =>
        _chatProvider = Provider.of<ChatProvider>(context, listen: false));
    _chatController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    chatFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _chatProvider.resetCurrentChat();
    chatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => chatFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Center(
          child: wig.Chat(
            chat: chatProvider.chat,
            chatController: _chatController,
            scrollController: _scrollController,
            chatFocusNode: chatFocusNode,
            lobbyChat: true,
            size: Size(400, 600),
            submitMessage: (text) => _chatProvider.sendTextMessage(text),
            theme: theme,
            maxScrollExtent: maxScrollExtent,
          ),
        ),
      ),
    );
  }
}
