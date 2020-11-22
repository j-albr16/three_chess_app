import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/chat_model.dart' as mod;
import '../screens/auth_test_screen.dart' as DEC;

class Chat extends StatefulWidget {
  Size size;

  Chat(this.size);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController _scrollController;
  TextEditingController _chatController;
  // mod.Chat currentChat = mod.Chat(
  //   messages: [
  //     Message(
  //         isYours: true,
  //         text: 'Hi this is a dummy Text',
  //         timeStamp: DateTime.now(),
  //         userName: 'Jan'),
  //     Message(
  //       isYours: false,
  //       text:
  //           'Hi Jan whats up sdhjfgbsdf asdjaisdh andasiodh andjaosd asdhaspdh ashduaosd ashduaosd',
  //       timeStamp: DateTime.now(),
  //       userName: 'Leo',
  //     ),
  //     Message(
  //       isYours: false,
  //       text: 'Hi Jan whats up ',
  //       timeStamp: DateTime.now(),
  //       userName: 'Leo',
  //     )
  //   ],
  //   id: 'asbdaukofgtZSCDBASHJCGV',
  //   user: [
  //     User(userName: 'Jan'),
  //     User(userName: 'Leo'),
  //   ],
  // );

  List<mod.Chat> availableChats;

  bool lobbyChat = true;
  String id;
  mod.Chat chat;
  ChatProvider chatProvider;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => chatProvider = Provider.of<ChatProvider>(context));
    _chatController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  listenForMessage(String id) {}
  newChatMessage(Message message) {
    setState(() {
      chat.messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    chat = chatProvider.chat;
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: chat.messages.length,
                itemBuilder: (context, index) => chatObject(
                    chat.messages[index].timeStamp,
                    chat.messages[index].text,
                    chat.messages[index].userName,
                    chat.messages[index].isYours),
              ),
            ),
            textField(),
            FlatButton(
              child: Text('Fetch Chat'),
              onPressed: () {},
            ),
          ]),
    );
  }

  Widget selectChat() {
    return PopupMenuButton(
      padding: EdgeInsets.all(13),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white)),
        ),
        child: Text(
          'Dummy Chat Name',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onSelected: (value) {
        setState(() {
          chat = value;
        });
      },
      itemBuilder: (context) => [
        ...availableChats
            .map((e) => PopupMenuItem(
                  value: e.id,
                  child: Text('Dummy Chat Name'),
                ))
            .toList()
      ],
    );
  }

  Widget textField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(13),
            child: TextField(
              controller: _chatController,
              decoration: DEC.decoration('your Message'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.white70,
              style: TextStyle(color: Colors.white70),
              onSubmitted: (_) {
                submit();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(6),
          onPressed: submit,
          icon: Icon(
            Icons.subdirectory_arrow_right_sharp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  submit() {
    if (_chatController.text.isNotEmpty) {
      // setState(() {
        chatProvider.sendTextMessage(_chatController.text);
        _chatController.clear();
        
      // });
    }
    // print(currentChat.messages);
  }

  Widget chatObject(DateTime time, String text, String userName, bool isYours) {
    return Align(
      alignment: isYours ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(13),
        constraints: BoxConstraints(maxWidth: widget.size.width * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white12,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (lobbyChat && !isYours)
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                SizedBox(
                  height: 4,
                ),
                RichText(
                  text: TextSpan(
                    text: text,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    children: [],
                  ),
                  // text,
                ),
              ]),
              SizedBox(
                height: 4,
              ),
              Text(
                DateFormat.Hm().format(time),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
              ),
            ]),
      ),
    );
  }
}
