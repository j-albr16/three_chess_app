import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../models/enums.dart';
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
  ThemeData theme;

  Chat({
    this.chat,
    this.theme,
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
                controller:scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: chat.messages.length,
                itemBuilder: (context, index) => chatObject(
                    chat.messages[index].timeStamp,
                    chat.messages[index].text,
                    chat.messages[index].userName,
                    chat.messages[index].owner),
              ),
            ),
            textField(),
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
              controller: chatController,
              decoration: DEC.decoration('your Message', theme),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.black26,
              style: TextStyle(color: Colors.black26),
              onSubmitted: (_){

              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(6),
          onPressed: submit,
          icon: Icon(
            Icons.subdirectory_arrow_right_sharp,
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  submit() {
    if (chatController.text.isNotEmpty) {
      submitMessage(chatController.text);
      chatController.clear();
    }
  }

AlignmentGeometry getAlignment(MessageOwner owner){
  switch(owner){
    case MessageOwner.You : 
    return Alignment.bottomRight;
    break;
    case MessageOwner.Mate:
    return Alignment.bottomLeft;
    break;
    case MessageOwner.Server:
    return Alignment.bottomCenter;
    break;
  }

}
  Widget chatObject(DateTime time, String text, String userName, MessageOwner owner) {
    return Align(
      alignment: getAlignment(owner),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(13),
        constraints: BoxConstraints(maxWidth: size.width * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (lobbyChat && owner == MessageOwner.You)
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
                      fontSize: owner != MessageOwner.Server ? 14 : 8,
                      color: Colors.white70,
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
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w300),
              ),
            ]),
      ),
    );
  }
}