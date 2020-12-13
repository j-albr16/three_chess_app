import 'package:flutter/material.dart';
import '../widgets/slider.dart';
import '../widgets/switch_row.dart';
import '../widgets/buttonbar.dart';
import '../models/friend.dart';
import '../models/game_opptions.dart';
import './friend_popup.dart';
import '../models/user.dart';

typedef CreateGameCallback(Options options);

class CreateGame extends StatelessWidget {
  Size size;
  User user;
// is Private vars
  bool isPublic = true;
  Function updateIsPrivate;

//allow Premade vars
  bool allowPremades;
  Function updateAllowPremades;

// is Public Button Bar (Switch)
  Function updateButtonBarData;
  int currentPublicitySelection;

// player Color Selection
  Function updatePlayerColorSelection;
  int playerColorSelection;

  // time Slider
  double time;
  double timeMin;
  double timeMax;
  Function updateTime;
  int timeDivisions;

  // increment Slider
  double increment;
  double incrementMin;
  double incrementMax;
  int incrementDivisions;
  Function updateIncrement;

  // Rating Range
  double posRatingRange;
  double negRatingRange;
  Function updateRatingRange;

//Friend Popup
  List<Friend> friends;
  Function confirmFriendInvitations;
  Function cancelFriendInvitation;
  List<Friend> selectedFriends;
  Function removeFriend;

// finish Buttons
  CreateGameCallback createGame;
  Function cancelCreateGame;

  int get playerColor {
    if (playerColorSelection == 5) {
      return null;
    }
    return playerColorSelection;
  }

  bool get isRated {
    if (currentPublicitySelection == 0) {
      return true;
    }
    return false;
  }

  CreateGame(
      {this.cancelCreateGame,
      this.createGame,
      this.allowPremades,
      this.posRatingRange,
      this.user,
      this.negRatingRange,
      this.updateIncrement,
      this.incrementMin,
      this.incrementMax,
      this.incrementDivisions,
      this.timeDivisions,
      this.removeFriend,
      this.playerColorSelection,
      this.currentPublicitySelection,
      this.updateIsPrivate,
      this.increment,
      this.isPublic,
      this.updateRatingRange,
      this.selectedFriends,
      this.size,
      this.time,
      this.timeMax,
      this.timeMin,
      this.updateAllowPremades,
      this.updateButtonBarData,
      this.updatePlayerColorSelection,
      this.updateTime,
      this.confirmFriendInvitations,
      this.friends,
      this.cancelFriendInvitation});

  @override
  Widget build(BuildContext context) {
    print(selectedFriends);
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        children: <Widget>[
          header('Create Game'),
          isPublicSwitch(),
          allowPremadeSwitch(),
          isRatedButtonBar(),
          playerColorButtonBar(),
          timeSlider(),
          incrementSlider(),
          ratingRangeSlider(),
          inviteFriend(context),
          if (selectedFriends.length > 0) invitedFriends(),
          finishSelection(),
        ],
      ),
    );
  }

  Widget header(String text) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(text),
    );
  }

  Widget isPublicSwitch() {
    return SwitchRow(
      negText: 'Private',
      posText: 'Public',
      updateValue: updateIsPrivate,
      value: isPublic,
    );
  }

  Widget allowPremadeSwitch() {
    return SwitchRow(
      negText: 'Exclude Premades',
      posText: 'Allow Premades',
      updateValue: updateAllowPremades,
      value: allowPremades,
    );
  }

  Widget isRatedButtonBar() {
    return ChessButtonBar(
      currentValue: currentPublicitySelection,
      updateValue: updateButtonBarData,
      size: Size(size.width, size.height * 0.1),
      buttonBarData: [
        Text('isRated'),
        Text('Casual'),
      ],
    );
  }

  Widget playerColorButtonBar() {
    return ChessButtonBar(
      currentValue: playerColorSelection,
      size: Size(size.width, size.height * 0.1),
      updateValue: updatePlayerColorSelection,
      buttonBarData: [
        Image.asset(
          'assets/pieces/king_white.png',
          fit: BoxFit.scaleDown,
          height: size.height * 0.06,
          width: size.width / 8,
        ),
        Image.asset(
          'assets/pieces/king_black.png',
          fit: BoxFit.scaleDown,
          height: size.height * 0.06,
          width: size.width / 8,
        ),
        Image.asset(
          'assets/pieces/king_red.png',
          fit: BoxFit.scaleDown,
          height: size.height * 0.06,
          width: size.width / 8,
        ),
        null,
        Text('Random'),
      ],
    );
  }

  Widget timeSlider() {
    return ChessSlider(
      divisions: timeDivisions,
      max: timeMax,
      min: timeMin,
      size: Size(size.width, size.height * 0.1),
      title: 'Time',
      totalValue: time,
      updateValue: updateTime,
    );
  }

  Widget incrementSlider() {
    return ChessSlider(
      divisions: incrementDivisions,
      max: incrementMax,
      min: incrementMin,
      updateValue: updateIncrement,
      size: Size(size.width, size.height * 0.1),
      title: 'Increment',
      totalValue: increment,
    );
  }

  Widget ratingRangeSlider() {
    return Column(
      children: [
        Text('Rating Range'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(negRatingRange?.toString()),
            SizedBox(
              height: size.height * 0.1,
              width: size.width * 0.6,
              child: RangeSlider(
                min: 0,
                max: user.score + 1000.0,
                divisions: user.score + 1000,
                labels: RangeLabels(
                    negRatingRange?.toString(), posRatingRange?.toString()),
                onChanged: (RangeValues values) => updateRatingRange(values),
                values: RangeValues(negRatingRange, posRatingRange),
              ),
            ),
            Text(posRatingRange?.toString()),
          ],
        ),
      ],
    );
  }

  Widget inviteFriend(BuildContext context) {
    List<String> selectedFriendIds =
        selectedFriends.map((e) => e.user.id).toList();
    return FlatButton(
        child: Text(
          'Invite Friends',
          style: TextStyle(fontSize: 14),
        ),
        height: size.height * 0.1,
        minWidth: size.width * 0.6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text('Invite Friends'),
                  content: FriendPopup(
                      cancelFriendSelection: cancelCreateGame,
                      confirmFriendSelection: confirmFriendInvitations,
                      selectedFriendIds: selectedFriendIds,
                      friends: friends,
                      size: Size(size.width * 0.7, size.height * 0.7),
                      updateFriendSelectionStatus: (bool value, String id) {
                        print(selectedFriends);
                        if (value && selectedFriends.length < 3) {
                          selectedFriendIds.add(id);
                        } else if (!value) {
                          selectedFriendIds.remove(id);
                        }
                        setState(() {});
                      }),
                ),
              ),
            ));
  }

  Widget invitedFriends() {
    print('Create invite Friends');
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: selectedFriends.map((e) {
          print('Hi');
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
                height: size.height * 0.08,
                width: size.width / 2.5,
                child: FriendPopup.friendTile(e, size,
                    remove: true,
                    removeCallback: (String id) => removeFriend(id))),
            // child: Text(e.user.userName),
            elevation: 8,
          );
        }).toList());
  }

  Widget finishSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Text('Create'),
          height: size.height * 0.1,
          minWidth: size.width * 0.2,
          onPressed: () => createGame(new Options(
            allowPremades: allowPremades,
            increment: increment.round(),
            isPublic: isPublic,
            isRated: isRated,
            negRatingRange: negRatingRange.round(),
            posRatingRange: posRatingRange.round(),
            time: time.round(),
          )),
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        FlatButton(
          child: Text('Cancel'),
          height: size.height * 0.1,
          minWidth: size.width * 0.2,
          onPressed: cancelCreateGame,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
      ],
    );
  }
}
