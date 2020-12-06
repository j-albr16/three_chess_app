import 'package:flutter/material.dart';
import '../widgets/slider.dart';
import '../widgets/switch_row.dart';
import '../widgets/buttonbar.dart';

class CreateGame extends StatelessWidget {
  Size size;

// is Private vars
  bool isPrivate;
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
 



bool get isRated{
  if(currentPublicitySelection == 0){
    return true;
  }
  return false;
} 
int get playerColor {
  if(playerColorSelection == 5){
    return null;
  }
  return playerColorSelection;
}
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

  Widget isPublicSwitch(){
    return SwitchRow(
      negText: 'Publice',
      posText: 'Private',
      updateValue: updateIsPrivate,
      value: isPrivate,
    );
  }
  Widget allowPremadeSwitch(){
    return SwitchRow(
      negText: 'Exclude Premades',
      posText: 'Allow Premades',
      updateValue: updateAllowPremades,
      value: allowPremades,
    );
  }
  Widget isRatedButtonBar(){
    return ChessButtonBar(
      currentValue: currentPublicitySelection,
      updateValue: updateButtonBarData,
      size: size,
      buttonBarData: [
        Text('isRated'),
        Text('Casual'),
      ],
    );
  }
  Widget playerColorButtonBar(){
    return ChessButtonBar(
      currentValue: playerColorSelection,
      size: size,
      updateValue: updatePlayerColorSelection,
      buttonBarData: [
        Image.asset('pieces/king_white.png'),
        Image.asset('pieces/king_black.png'),
        Image.asset('pieces/king_red.png'),
        null,
        Text('Random'),
      ],
    );
  }
  Widget timeSlider(){
    return ChessSlider(
      divisions: timeDivisions,
      max: timeMax,
      min: timeMin,
      size: size,
      title: 'Time',
      totalValue: time ,
      updateValue: updateTime,
    );
  }
  Widget incrementSlider(){
    return ChessSlider(
      divisions: incrementDivisions,
      max: incrementMax,
      min: incrementMin,
      updateValue: updateIncrement,
      size: size,
      title: 'Increment',
      totalValue: increment,
    );
  }
  Widget ratingRangeSlider(){
    return Row(
      children: <Widget>[
        ChessSlider(
          divisions: negRatingRangeDivisions,
          max: negRatingRangeMax,
          min: negratingRangeMin,
          size: size,
          title: 'Negative Rating Range',
          totalValue: negRatingRange,
          updateValue: updateNegRatingRange,
        ),
        ChessSlider(
          divisions: posRatingRangeDivisions,
          max: posRatingRangeMax,
          min: posratingRangeMin,
          size: size,
          title: 'Positive Rating Range',
          totalValue: posRatingRange,
          updateValue: updatePosRatingRange,
        )
      ],
    );
  }
  Widget finishSelection(){}
}
