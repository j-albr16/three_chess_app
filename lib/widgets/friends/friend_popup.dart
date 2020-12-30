import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/friends_provider.dart';
import 'friend_list.dart';
import '../../models/friend.dart';
import './friend_tile.dart';

class FriendPopup extends StatelessWidget {
  List<Friend> friends;
  Size size;
  Function updateFriendSelectionStatus;
  Function confirmFriendSelection;
  Function cancelFriendSelection;

  List<String> selectedFriendIds;

  FriendPopup(
      {this.selectedFriendIds,
      this.updateFriendSelectionStatus,
      this.size,
      this.cancelFriendSelection,
      this.confirmFriendSelection,
      this.friends});

  @override
  Widget build(BuildContext context) {
    print(selectedFriendIds);
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.75,
            width: size.width,
            child: ListView(
              children: friends.map((friend) => checkBoxTile(friend)).toList(),
            ),
          ),
          Text(
            '${selectedFriendIds.length}. You can invite ${2 - selectedFriendIds.length} more',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: size.height * 0.05),
          confirmationButtons(),
        ],
      ),
    );
  }

  Widget checkBoxTile(Friend friend) {
    return CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        contentPadding: EdgeInsets.all(8),
        value: selectedFriendIds.contains(friend.user.id),
        title: friendTile(friend, size),
        onChanged: (bool value) =>
            updateFriendSelectionStatus(value, friend.user.id));
  }

  static Widget friendTile(Friend friend, Size size,
      {bool remove = false, Function removeCallback}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FriendTile.onlineIcon(friend.isOnline),
        // SizedBox(width: size.width * 0.1),
        FriendTile.usernameText(friend.user.userName),
        Spacer(),
        Text(friend.user.score.toString()),
        // SizedBox(width: size.width * 0.06),
        if (remove)
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.red,
            ),
            onPressed: () => removeCallback(friend.user.id),
          )
      ],
    );
  }

  Widget confirmationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlatButton(
          padding: EdgeInsets.all(15),
          child: Text(
            'Confirm',
            style: TextStyle(fontSize: 20),
          ),
          height: size.height * 0.12,
          minWidth: size.width * 0.35,
          onPressed: () => confirmFriendSelection(selectedFriendIds),
        ),
        FlatButton(
          padding: EdgeInsets.all(15),
          height: size.height * 0.1,
          minWidth: size.width * 0.3,
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 15),
          ),
          onPressed: cancelFriendSelection,
        )
      ],
    );
  }
}
