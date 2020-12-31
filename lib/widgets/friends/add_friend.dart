import 'package:flutter/material.dart';

import '../basic/text_field.dart';
import '../basic/sorrounding_cart.dart';
import '../../helpers/constants.dart';

typedef void AddFriend(String friendToAdd);

class AddFriendArea extends StatelessWidget {
  final AddFriend addFriend;
  final bool isTyping;
  final Size size;
  final ThemeData theme;
  final Function switchTyping;
  final TextEditingController controller;
  final FocusNode focusNode;

  AddFriendArea(
      {this.addFriend,
      this.size,
      this.theme,
      this.focusNode,
      this.isTyping = false,
      this.switchTyping,
      this.controller});

  void _submit(submitted) {
    focusNode.unfocus();
    switchTyping();
    addFriend(submitted);
  }

  Widget textField() {
    return ChessTextField(
      controller: controller,
      // errorText: 'Error finding Friend',
      focusNode: focusNode,
      // helperText: 'username',
      labelText: 'username',
      maxLines: 1,
      obscuringText: false,
      onSubmitted: (String text) => _submit(text),
      hintText: 'username',
      size: Size(size.width * 0.9, 45),
      suffixIcon: IconButton(
        icon: Icon(Icons.send),
        onPressed: () => _submit(controller.text),
      ),
      textInputType: TextInputType.name,
      theme: theme,
    );
  }

  Widget button() {
    return Container(
        color: Colors.purple,
        height: 47,
        child: InkWell(
          onTap: () {
            switchTyping();
            focusNode.requestFocus();
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add a Friend",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(width: 10, color: Colors.transparent),
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7),
      width: double.infinity,
      // decoration:
      // BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      // child: isTyping ? textField() : button());
      child: SorroundingCard(
        // padding: EdgeInsets.all(mainBoxPadding / 2),
        child: textField()),
    );
  }
}
