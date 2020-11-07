import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/chat_listener.dart';
import '../models/message.dart';

class Chat extends StatefulWidget {


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatListener chatListener;
  List<Message> messages = [];

  bool lobbyChat;
   String id;

  @override
  void initState() {
    chatListener = ChatListener()
      ..addMessageListener((message) => newChatMessage(message))
      ..addListener(() => getMessages());
    super.initState();
  }

  newChatMessage(message) {
    setState(() {
      messages.add(message);
    });
  }
  getMessages() {
    setState(() {
      messages = chatListener.messages;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => chatObject(messages[index].timeStamp,
            messages[index].text, messages[index].userName, messages[index].yourMessage),
      ),
    );
  }
  Widget chatObject(DateTime time, String text, String userName, bool yourMessage) {
  return Row(
      children: <Widget>[
        if(yourMessage)
        Spacer(),
        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: yourMessage ? Colors.cyan : Colors.lightGreen[100],
      ),
      child: Column(
        children: [
          if (lobbyChat || !yourMessage)
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
             Text(text, style: TextStyle(
               fontSize: 10,
               color: Colors.white,
             ),
             textAlign: TextAlign.justify,
             ),
          Text(
            DateFormat.Hm().format(time),
            style: TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.w300
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ),
    if(!yourMessage)
        Spacer(),
        ]
  );
}
}


