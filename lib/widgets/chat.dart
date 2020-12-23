import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../models/enums.dart';
import '../models/message.dart';
import '../models/user.dart';
import './text_field.dart';
import '../providers/friends_provider.dart';
import '../models/chat_model.dart' as mod;
import '../screens/auth_test_screen.dart' as DEC;

class Chat extends StatelessWidget {
  final Size size;
  final Function submitMessage;
  final mod.Chat chat;
  final bool lobbyChat;
  bool wasInit = false;
  final ScrollController scrollController;
  final TextEditingController chatController;
  final ThemeData theme;
  final bool maxScrollExtent;
  final FocusNode chatFocusNode;

  Chat({
    this.chat,
    this.maxScrollExtent,
    this.chatFocusNode,
    this.theme,
    this.lobbyChat,
    this.size,
    this.submitMessage,
    this.chatController,
    this.scrollController,
  }) {
    // TODO Scroll Down
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (maxScrollExtent || wasInit == false) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        wasInit = true;
        Provider.of<FriendsProvider>(context, listen: false)
            .resetNewMessages(chat.id);
      }
    });
    return Container(
      alignment: Alignment.center,
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: chat.messages.length,
                itemBuilder: (context, index) => chatObject(
                    chat.messages[index].timeStamp,
                    chat.messages[index].text,
                    chat.messages[index].userName,
                    chat.messages[index].owner),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textField(),
            ),
          ]),
    );
  }

  Widget textField() {
    return ChessTextField(
      controller: chatController,
      // errorText: 'invalid',
      focusNode: chatFocusNode,
      // hintText: 'message',
      labelText: 'message',
      maxLines: 1,
      textInputType: TextInputType.text,
      theme: theme,
      obscuringText: false,
      size: Size(size.height * 0.9, 50),
      onSubmitted: (_) => submit(),
      suffixIcon: IconButton(
        padding: EdgeInsets.all(6),
        onPressed: submit,
        icon: Icon(
          Icons.subdirectory_arrow_right_sharp,
          color: Colors.black26,
        ),
      ),
    );
  }

  submit() {
    if (chatController.text.isNotEmpty) {
      chatFocusNode.unfocus();
      submitMessage(chatController.text);
      chatController.clear();
    }
  }

  AlignmentGeometry getAlignment(MessageOwner owner) {
    switch (owner) {
      case MessageOwner.You:
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

  Widget chatObject(
      DateTime time, String text, String userName, MessageOwner owner) {
    return Align(
      alignment: getAlignment(owner),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(maxWidth: size.width * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
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
