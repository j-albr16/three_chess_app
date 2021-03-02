import 'package:flutter/material.dart';

class ChessSlider extends StatelessWidget {
  final Size size;
  final double totalValue;
  final Function updateValue;
  final String title;
  final double min;
  final double max;
  final int divisions;

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
        Text(title, style: TextStyle(color: Colors.black)),
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
                label: totalValue.toStringAsFixed(0),
                onChanged: (double value) => updateValue(value),
              ),
            ),
            Text(totalValue.toStringAsFixed(0),
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
