import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../models/chess_move.dart';
import '../widgets/create_game.dart';
import './game_provider_test_screen.dart';

  typedef CreateGameCallback({int increment, int time, int posRatingRange, int negRatingRange, bool isPrivate, bool isRated, bool allowPremades});
class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-screen';

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) =>
        _gameProvider = Provider.of<GameProvider>(context, listen: false));
  }

  GameProvider _gameProvider;

  Size size;

// is Private vars
  bool isPrivate = false;
  Function updateIsPrivate(bool value) {
    setState(() {
      isPrivate = value;
    });
  }

//allow Premade vars
  bool allowPremades = true;
  Function updateAllowPremades(bool value) {
    setState(() {
      allowPremades = value;
    });
  }

// is Public Button Bar (Switch)
  Function updateButtonBarData(int index) {
    setState(() {
      currentPublicitySelection = index;
    });
  }

  int currentPublicitySelection = 0;

// player Color Selection
  Function updatePlayerColorSelection(int index) {
    setState(() {
      playerColorSelection = index;
    });
  }

  int playerColorSelection = 4;

  // time Slider
  double time = 10;
  double timeMin = 0;
  double timeMax = 50;
  Function updateTime(double value) {
    setState(() {
      time = value;
    });
  }

  int timeDivisions = 100;

  // increment Slider
  double increment = 3;
  double incrementMin = 0;
  double incrementMax = 10;
  int incrementDivisions = 10;
  Function updateIncrement(double value) {
    setState(() {
      increment = value;
    });
  }

  // Rating Range
  double posRatingRange = 100;
  double posratingRangeMin = 0;
  double posRatingRangeMax = 1000;
  int posRatingRangeDivisions = 1000;
  Function updatePosRatingRange(double value) {
    setState(() {
      posRatingRange = value;
    });
  }

  double negRatingRange = -100;
  double negRatingRangeMin = 0;
  double negRatingRangeMax = 1000;
  int negRatingRangeDivisions = 1000;
  Function updateNegRatingRange(double value) {
    setState(() {
      negRatingRange = -value;
    });
  }

// finish Buttons
  CreateGameCallback createGame(
      {increment,
      time,
      isRated,
      isPrivate,
      negRatingRange,
      posRatingRange,
      allowPremades}) {
    _gameProvider.createGame(
      increment: increment,
      time: time,
      isPublic: !isPrivate,
      isRated: isRated,
      negDeviation: negRatingRange,
      posDeviation: posRatingRange,
      allowPremades: allowPremades,
    );
    Navigator.of(context).pop();
  }

  Function cancelCreateGame(){
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: CreateGame(
        allowPremades: allowPremades,
        cancelCreateGame: () => cancelCreateGame(),
        createGame: () => createGame(
          allowPremades: allowPremades,
          increment: increment,
          isPrivate: isPrivate,
          isRated: isPrivate,
          negRatingRange: negRatingRange,
          posRatingRange: posRatingRange,
          time: time,
        ),
        currentPublicitySelection: currentPublicitySelection,
        increment: increment,
        incrementDivisions: incrementDivisions,
        incrementMax: incrementMax,
        incrementMin: incrementMin,
         isPublic: isPublic,
        negRatingRange: negRatingRange,
        negRatingRangeDivisions: negRatingRangeDivisions,
        negRatingRangeMax: negRatingRangeMax,
        negratingRangeMin: negRatingRangeMin,
        playerColorSelection: playerColorSelection,
        posRatingRange: posRatingRangeMax,
        posRatingRangeDivisions: posRatingRangeDivisions,
        posRatingRangeMax: posRatingRangeMax,
        posratingRangeMin: posRatingRangeMax,
        size: size,
        time: time,
        timeDivisions: timeDivisions,
        timeMax: timeMax,
        timeMin: timeMin,
        updateAllowPremades: (bool value)  => updateAllowPremades(value),
        updateButtonBarData: (int index) => updateButtonBarData(index),
        updateIncrement: (double value) => updateIncrement(value),
        updateIsPrivate: (bool value) => updateIsPrivate(value),
        updateNegRatingRange: (double value) => updateNegRatingRange(value),
        updatePlayerColorSelection: (int index) => updatePlayerColorSelection(index),
        updatePosRatingRange: (double value) => updatePosRatingRange(value),
        updateTime: (double value) => updateTime(value),
      ),
    );
  }
}
