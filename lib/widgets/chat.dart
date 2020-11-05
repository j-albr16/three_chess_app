import 'package:flutter/material.dart';

import '../providers/chat_listener.dart';


class Chat extends StatefulWidget {

  final double height;
  final double width;

  Chat({this.height, this.width});

  @override
  _ChatState createState() => _ChatState();
}


class _ChatState extends State<Chat> {

ChatListener chatListener;
String messages;

@override
void initState(){
  chatListener = ChatListener()
  ..addListener((message) => newChatMessage(message));
  super.initState();
}

newChatMessage(message){
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid,),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.builder(
        // itemCount: ,
        // itemBuilder: ,
      ),
    );
  }
}