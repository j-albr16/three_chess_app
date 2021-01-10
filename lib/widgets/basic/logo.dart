import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../basic/sorrounding_cart.dart';

class Logo extends StatelessWidget {
  final Size size;
  final String imagePath;
  final ThemeData theme;

  Logo({this.size, this.imagePath, this.theme});

  @override
  Widget build(BuildContext context) {
    return SorroundingCard(
      height: size.height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
