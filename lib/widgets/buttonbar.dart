import 'package:flutter/material.dart';

class ChessButtonBar extends StatelessWidget {
  List<Widget> buttonBarData;
  Size size;
  int currentValue;
  Function updateValue;

  ChessButtonBar({this.currentValue,this.buttonBarData, this.size, this.updateValue});
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
        buttonHeight: size.height,
        buttonMinWidth: size.width,
        buttonPadding: EdgeInsets.all(25),
        alignment: MainAxisAlignment.center,
        children: buttonBarData.asMap().entries.map((label) {
          int index =label.key;
          if(label.value == null){
            return Spacer();
          }
          return buttonItem(index ,label.value);
        }).toList());
  }

  Widget buttonItem(int index, Widget label) {
    Color color;
    if(currentValue == index){
      color = Colors.blueAccent;
    }else{
      color = Colors.black45;
    }
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      color: color,
      onPressed: () => updateValue(index),
      child: label,
    );
  }
}
