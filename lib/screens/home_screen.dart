import 'package:flutter/material.dart';

import '../screens/board_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
              onTap: ()=>Navigator.of(context).pushNamed(BoardScreen.routeName),
            child: Container(
              child: Text('Dummy Chess Board',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w400,
              ),),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.greenAccent, Colors.grey],
                ),
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6.0,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            width: 200,
            child: Image.asset('assets/pieces/bishop_black.png', fit: BoxFit.cover,),
          ),
        ],
      ),
    );
  }
}
