import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-screen';

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  bool isPublic = true;
  bool isRated = true;

  double _totalTime = 5;
  int get totalTime => _totalTime.round();
  double _increment = 2;
  int get increment => _increment.round();

  double _negDeviation = -100;
  int get negDeviation => _negDeviation.round();

  double _posDeviation = 100;
  int get posDeviation => _posDeviation.round();

  @override
  Widget build(BuildContext context) {
    // print(_negDeviation);
    // print(negDeviation);
    final Size size = MediaQuery.of(context).size;
    // final args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('auth-image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Create a new Game',
              style: TextStyle(color: Colors.white),
            ),
            margin: EdgeInsets.all(13),
            decoration: BoxDecoration(color: Colors.black45),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            // height: size.height * 0.5,
            width: size.width * 0.6,
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.all(13),
            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(7)),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(isPublic ? 'Public' : 'Private', style: TextStyle(color: Colors.white)),
                  Switch(
                    onChanged: (value) {
                      setState(() {
                        isPublic = value;
                      });
                    },
                    value: isPublic,
                  ),
                ],
              ),
              Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
              Text('Time', style: TextStyle(color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Slider(
                      value: _totalTime,
                      min: 1,
                      max: 50,
                      divisions: 100,
                      label: totalTime.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _totalTime = value;
                        });
                      },
                    ),
                  ),
                  Text(_totalTime.toStringAsFixed(1), style: TextStyle(color: Colors.white)),
                ],
              ),
              Text('Increment', style: TextStyle(color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.add_alarm_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Slider(
                      value: _increment,
                      min: 0,
                      max: 25,
                      divisions: 50,
                      label: increment.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _increment = value;
                        });
                      },
                    ),
                  ),
                  Text(increment.toStringAsFixed(1), style: TextStyle(color: Colors.white)),
                ],
              ),
              Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    padding: EdgeInsets.all(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: isRated ? Colors.blueAccent : Colors.black45,
                    onPressed: () {
                      setState(() {
                        isRated = true;
                      });
                    },
                    child: Text(
                      'Public',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: !isRated ? Colors.blueAccent : Colors.black45,
                    onPressed: () {
                      setState(() {
                        isRated = false;
                      });
                    },
                    child: Text(
                      'Casual',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.5,
                color: Colors.white,
                // indent: 1000,
              ),
              Text(
                'Rating Range',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * 0.2,
                    child: Slider(
                      value: _negDeviation,
                      min: -500,
                      max: 0,
                      divisions: 500,
                      label: negDeviation.toStringAsFixed(0),
                      onChanged: (double value) {
                        setState(() {
                          _negDeviation = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    negDeviation.toStringAsFixed(0) + '   /   ' + posDeviation.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                    child: Slider(
                      value: _posDeviation,
                      min: 0,
                      max: 500,
                      divisions: 500,
                      label: posDeviation.toStringAsFixed(0),
                      onChanged: (double value) {
                        setState(() {
                          _posDeviation = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
              FlatButton(
                child: Text('Create Game', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
                onPressed: () {
                  Provider.of<GameProvider>(context, listen: false).createGame(
                    increment: increment,
                    isPublic: isPublic,
                    isRated: isRated,
                    negDeviation: negDeviation,
                    posDeviation: posDeviation,
                    time: totalTime,
                  );
                  //print('Game was created');
                },
                minWidth: 100,
                padding: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
