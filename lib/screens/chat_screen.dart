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

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _chatProvider = Provider.of<ChatProvider>(context, listen: false));
    _chatController = TextEditingController();
    _scrollController = ScrollController();
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
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) => wig.Chat(
            chat: chatProvider.chat,
            chatController: _chatController,
            scrollController: _scrollController,
            lobbyChat: true,
            size: Size(400, 600),
            submitMessage: (text) => _chatProvider.sendTextMessage(text),
          ),
        ),
      ),
    );
  }
}
