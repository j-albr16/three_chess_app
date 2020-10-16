import 'package:flutter/material.dart';

import '../screens/board_screen.dart';
import '../screens/design-test-screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Column(
        children: <Widget>[
          menuItem('Chess Board Test',BoardScreen.routeName, context),
          menuItem('Design Test',DesignTestScreen.routeName, context),
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


Widget menuItem (String title, String routeName, BuildContext context) {
      return  GestureDetector(
              onTap: ()=>Navigator.of(context).pushNamed(routeName),
            child: Container(
              child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w400,
              ),),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
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
          );
}