import 'package:flutter/material.dart';
import '../widgets/slider.dart';
import '../widgets/switch_row.dart';
import '../widgets/buttonbar.dart';

  typedef CreateGameCallback({int increment, int time, int posRatingRange, int negRatingRange, bool isPublic, bool isRated, bool allowPremades});
class CreateGame extends StatelessWidget {
  Size size;

// is Private vars
  bool isPublic;
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
  double posratingRangeMin;
  double posRatingRangeMax;
  int posRatingRangeDivisions;
  Function updatePosRatingRange;

  double negRatingRange;
  double negratingRangeMin;
  double negRatingRangeMax;
  int negRatingRangeDivisions;
  Function updateNegRatingRange;

// finish Buttons
  CreateGameCallback createGame;
  Function cancelCreateGame;

  int get playerColor {
    if(playerColorSelection == 5){
      return null;
    }
    return playerColorSelection;
  }

  bool get isRated{
    if(currentPublicitySelection == 0){
      return true;
    }
    return false;
  }

  CreateGame(
      {this.cancelCreateGame,
      this.createGame,
      this.allowPremades,
      this.updatePosRatingRange,
      this.posRatingRange,
      this.posratingRangeMin,
      this.negRatingRangeMax,
      this.negRatingRangeDivisions,
      this.updateNegRatingRange,
      this.negRatingRange,
      this.negratingRangeMin,
      this.updateIncrement,
      this.incrementMin,
      this.incrementMax,
      this.incrementDivisions,
      this.timeDivisions,
      this.playerColorSelection,
      this.currentPublicitySelection,
      this.updateIsPrivate,
      this.increment,
      this.isPublic,
      this.posRatingRangeDivisions,
      this.posRatingRangeMax,
      this.size,
      this.time,
      this.timeMax,
      this.timeMin,
      this.updateAllowPremades,
      this.updateButtonBarData,
      this.updatePlayerColorSelection,
      this.updateTime});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          header('Create Game'),
          isPublicSwitch(),
          allowPremadeSwitch(),
          isRatedButtonBar(),
          timeSlider(),
          incrementSlider(),
          ratingRangeSlider(),
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
        Image.asset('assets/pieces/king_white.png'),
        Image.asset('assets/pieces/king_black.png'),
        Image.asset('assets/pieces/king_red.png'),
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
    return Row(
      children: <Widget>[
        ChessSlider(
          divisions: negRatingRangeDivisions,
          max: negRatingRangeMax,
          min: negratingRangeMin,
          size: Size(size.width * 0.5, size.height * 0.1),
          title: 'Negative Rating Range',
          totalValue: negRatingRange,
          updateValue: updateNegRatingRange,
        ),
        ChessSlider(
          divisions: posRatingRangeDivisions,
          max: posRatingRangeMax,
          min: posratingRangeMin,
          size: Size(size.width * 0.5, size.height * 0.1),
          title: 'Positive Rating Range',
          totalValue: posRatingRange,
          updateValue: updatePosRatingRange,
        )
      ],
    );
  }

  Widget finishSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Text('Create'),
          height: size.height * 0.1,
          minWidth: size.width * 0.2,
          onPressed: () => createGame(
              increment: increment.round(),
              time: time.round(),
              negRatingRange: negRatingRange.round(),
              posRatingRange: posRatingRange.round(),
              isPublic:isPublic,
              isRated: isRated,
              allowPremades: allowPremades),
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
