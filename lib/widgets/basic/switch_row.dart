import 'package:flutter/material.dart';

class SwitchRow extends StatelessWidget {
  String posText;
  String negText;
  bool value;
  Function updateValue;

  SwitchRow({this.posText, this.negText, this.updateValue, this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(value ? posText : negText, style: TextStyle(color: Colors.black)),
        Switch(
          onChanged: (value) => updateValue(value),
          value: value,
        ),
      ],
    );
  }
}
