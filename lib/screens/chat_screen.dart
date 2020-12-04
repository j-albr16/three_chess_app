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
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _chatProvider.resetCurrentChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
    if (maxScrollExtent) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
    }
    });
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: wig.Chat(
          chat: chatProvider.chat,
          chatController: _chatController,
          scrollController: _scrollController,
          lobbyChat: true,
          size: Size(400, 600),
          submitMessage: (text) => _chatProvider.sendTextMessage(text),
          theme: theme,
          maxScrollExtent: maxScrollExtent,
        ),
      ),
    );
  }
}
