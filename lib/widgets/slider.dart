import 'package:flutter/material.dart';

class ChessSlider extends StatelessWidget {
  Size size;
  double totalValue;
  Function updateValue;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Time', style: TextStyle(color: Colors.black)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.access_time, color: Colors.black),
            SizedBox(
              width: size.width * 0.4,
              child: Slider(
                value: totalValue,
                min: 1,
                max: 50,
                divisions: 100,
                label: totalValue.toStringAsFixed(1),
                onChanged: (double value) => updateValue(value),
              ),
            ),
            Text(totalValue.toStringAsFixed(1),
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
