// import 'package:flutter/material.dart';

// import '../providers/chat_listener.dart';
// import '../models/message.dart';


// class Chat extends StatefulWidget {

//   final double height;
//   final double width;

//   Chat({this.height, this.width});

//   @override
//   _ChatState createState() => _ChatState();
// }


// class _ChatState extends State<Chat> {

// ChatListener chatListener;
// List<Message> messages = [];

// @override
// void initState(){
//   chatListener = ChatListener()
//   ..addListener((message) => newChatMessage(message));
//   super.initState();
// }

// newChatMessage(message){
//   messages.add(message);
// }


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid,),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: ListView.builder(
//         itemCount: messages.length,
//         itemBuilder: (context, index) => ,
//       ),
//     );
//   }
// }

// Widget chatObject(DateTime time, String message, String userName){
//   return Row(
//     children: [
//       Text(time.),
//     ],
//   );
// }