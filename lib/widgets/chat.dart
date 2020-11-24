import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/chat_model.dart' as mod;
import '../screens/auth_test_screen.dart' as DEC;

class Chat extends StatelessWidget{
  Size size;
  Function submitMessage;
  mod.Chat chat;
  bool lobbyChat;
  ScrollController scrollController;
  TextEditingController chatController;

  Chat({
    this.chat,
    this.lobbyChat,
    this.size,
    this.submitMessage,
    this.chatController,
    this.scrollController,
  }){
    // TODO Scroll Down
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width:size.width,
      height:size.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
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
      submitMessage(_chatController.text);
      _chatController.clear();
    }
  }

  Widget chatObject(DateTime time, String text, String userName, bool isYours) {
    return Align(
      alignment: isYours ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(13),
        constraints: BoxConstraints(maxWidth: size.width * 0.7),
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