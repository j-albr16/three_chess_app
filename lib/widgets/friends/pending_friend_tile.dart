import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import './friend_tile.dart';

class PendingFriendTile extends StatelessWidget {
  final double height;
  final FriendTileModel model;
  final FriendDialog onAccept;
  final FriendDialog onReject;
  final FriendDialog onSelected;
  final bool isSelected;

  PendingFriendTile(
      {this.onAccept,
      this.onReject,
      this.height,
      this.model,
      this.isSelected,
      this.onSelected});

  Widget usernameText(String username) {
    return Text(
      username,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _selectWrapper({Widget child}) {
      return isSelected
          ? InkWell(
              child: child,
              onTap: () => onSelected(FriendTileModel()),
            )
          : InkWell(
              child: child,
              onTap: () => onSelected(model),
            );
    }

    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return _selectWrapper(
        child: Column(
          children: [
            Container(
              height: isSelected ? height * 2 : height,
              // padding: EdgeInsets.only(top: 10, bottom: 10),
              //decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
              child: Card(
                child: SizedBox(
                  height: isSelected ? height * 2 : height,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Center(child: usernameText(model.username)),
                        if (isSelected)
                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: InkWell(
                                      child: Card(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                      onTap: () => onAccept(model),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.1,
                                    color: Colors.transparent,
                                  ),
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: InkWell(
                                      child: Card(
                                        child: Center(
                                            child: Text("X",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold))),
                                      ),
                                      onTap: () => onReject(model),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}