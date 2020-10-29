import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/game_provider.dart';

class CreateGameScreen extends StatefulWidget {
  static const routeName = '/create-screen';

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

bool isPublic = true;
bool isRated = true;

double _totalTime = 5;
double _increment = 2;

class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  Widget build(BuildContext context) {
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
            height: size.height * 0.3,
            width: size.width * 0.6,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(13),
            decoration: BoxDecoration(color: Colors.black45),
            child: ListView(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(isPublic ? 'Public' : 'Private',
                      style: TextStyle(color: Colors.white)),
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
              Text('Time', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Slider(
                      value: _totalTime,
                      min: 0,
                      max: 50,
                      divisions: 100,
                      label: _totalTime.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _totalTime = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Text('Increment', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Icon(
                    Icons.add_alarm_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Slider(
                      value: _increment,
                      min: 0,
                      max: 25,
                      divisions: 50,
                      label: _increment.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _increment = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isRated = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isRated
                        ? Colors.blueAccent
                        : Colors.black45,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Rated',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                     
                    onTap: (){
                      setState(() {
                        isRated = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: !isRated
                        ? Colors.blueAccent
                        : Colors.black45,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Casual',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
