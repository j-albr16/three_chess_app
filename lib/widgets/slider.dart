import 'package:flutter/material.dart';

class ChessSlider extends StatelessWidget {
  Size size;
  double totalValue;
  Function updateValue;
  String title;
  double min;
  double max;
  int divisions;

  ChessSlider(
      {this.size,
      this.divisions,
      this.max,
      this.min,
      this.totalValue,
      this.title,
      this.updateValue});

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
              width: size.width * 0.7,
              height: size.height,
              child: Slider(
                value: totalValue,
                min: min,
                max: max,
                divisions: divisions,
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
