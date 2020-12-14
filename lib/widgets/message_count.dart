import 'package:flutter/material.dart';


class MessageCount extends StatelessWidget {

  final int messageCount;

  MessageCount(this.messageCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.only(right: 6, top: 6),
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle
      ),
      child: Text(messageCount.toString(), style: TextStyle(color: Colors.white),),
    );
  }
}