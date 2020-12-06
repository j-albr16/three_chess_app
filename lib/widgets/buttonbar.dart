import 'package:flutter/material.dart';

class ChessButtonBar extends StatelessWidget {
  List<Map<String,dynamic>> buttonBarData;
  Size size;
  
  ChessButtonBar(this.buttonBarData, this.size);
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      buttonHeight: size.height,
      buttonMinWidth: size.width,
      buttonPadding: EdgeInsets.all(25),
      alignment: MainAxisAlignment.center,
      children: buttonBarData.map((buttonData) => buttonItem(buttonData['value'], buttonData['updateValue'], buttonData['lable'])).toList() ,
    );
  }

  Widget buttonItem(bool value, Function updateValue, String label) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      color: !value ? Colors.blueAccent : Colors.black45,
      onPressed: () => updateValue(),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
