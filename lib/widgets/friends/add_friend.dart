import 'package:flutter/material.dart';

import '../basic/text_field.dart';
import '../basic/sorrounding_cart.dart';
import '../../helpers/constants.dart';

typedef void AddFriend(String friendToAdd);

class AddFriendArea extends StatelessWidget {
  final AddFriend addFriend;
  final Size size;
  final ThemeData theme;
  final Function switchIsSearchingFriend;
  final TextEditingController controller;
  final FocusNode focusNode;

  AddFriendArea(
      {this.addFriend,
      this.size,
      this.theme,
      this.focusNode,
      this.switchIsSearchingFriend,
      this.controller});

  void _submit(submitted) {
    focusNode.unfocus();
    controller.clear();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7),
      width: double.infinity,
      child: SurroundingCard(
        // padding: EdgeInsets.all(mainBoxPadding / 2),
        child: textField()),
    );
  }
}
