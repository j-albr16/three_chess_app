import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/chat_provider.dart';
import './basic/sorrounding_cart.dart';
import '../models/enums.dart';
import '../models/message.dart';
import '../models/user.dart';
import './basic/text_field.dart';
import '../providers/friends_provider.dart';
import '../models/chat_model.dart' as mod;
import '../screens/auth_screen.dart' as DEC;
import '../helpers/constants.dart';

typedef void SubmitMessage(String message);

class Chat extends StatelessWidget {
  final double width;
  final double height;
  final SubmitMessage submitMessage;
  final mod.Chat chat;
  final bool lobbyChat;
  bool wasInit = false;
  @required
  final ScrollController scrollController;
  @required
  final TextEditingController chatController;
  final ThemeData theme;
  final bool maxScrollExtent;
  final FocusNode chatFocusNode;
  final bool noSorrounding;

  Chat({
    this.chat,
    this.noSorrounding = false,
    this.maxScrollExtent,
    this.chatFocusNode,
    this.theme,
    this.lobbyChat,
    this.width = double.infinity,
    this.height = double.infinity,
    this.submitMessage,
    this.chatController,
    this.scrollController,
  });

  void animateToBottom(BuildContext context) {
    ///  Method to Animate to the Bottom of the Chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (maxScrollExtent || wasInit == false) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        wasInit = true;
        Provider.of<FriendsProvider>(context, listen: false)
            .resetNewMessages(chat.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: noSorrounding ? mainChat() : SorroundingCard(
              padding: EdgeInsets.all(mainBoxPadding / 2),
              child: mainChat(),
            ),
          ),
          textField(),
        ]);
  }

  Widget mainChat(){
    return ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: chat?.messages?.length,
                itemBuilder: (context, index) => chatObject(
                    time: chat.messages[index].timeStamp,
                    theme: Theme.of(context),
                    text: chat.messages[index].text,
                    userName: chat.messages[index].userName,
                    owner: chat.messages[index].owner),
              );
  }

  Widget blankTextField() {
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
      size: Size(double.infinity, 50),
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

  Widget textField() {
    return noSorrounding
        ? blankTextField()
        : SorroundingCard(
            padding: EdgeInsets.all(mainBoxPadding),
            child: blankTextField(),
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
    AlignmentGeometry align = Alignment.bottomRight;
    switch (owner) {
      case MessageOwner.You:
        align = Alignment.bottomRight;
        break;
      case MessageOwner.Mate:
        align = Alignment.bottomLeft;
        break;
      case MessageOwner.Server:
        align = Alignment.bottomCenter;
        break;
    }
    return align;
  }

  Widget chatObjectWrapper(
      {ThemeData theme, MessageOwner owner, Widget child}) {
    return Align(
      alignment: getAlignment(owner),
      child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(maxWidth: width * 0.7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.onBackground.withOpacity(0.60),
          ),
          child: child),
    );
  }

  Widget chatObject(
      {DateTime time,
      ThemeData theme,
      String text,
      String userName,
      MessageOwner owner}) {
    return chatObjectWrapper(
      theme: theme,
      owner: owner,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (lobbyChat && owner != MessageOwner.You)
                Text(
                  userName,
                  style: theme.textTheme.subtitle2.copyWith(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              SizedBox(
                height: 4,
              ),
              Text(
                text,
                style: theme.textTheme.bodyText2,
              ),
            ]),
            SizedBox(
              height: 4,
            ),
            Text(
              DateFormat.Hm().format(time),
              style: theme.textTheme.overline
                  .copyWith(color: theme.textTheme.subtitle2.color),
            ),
          ]),
    );
  }
}
