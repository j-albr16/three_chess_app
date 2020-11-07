import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PathClipper extends CustomClipper<Path> {
  Path path;
  PathClipper({this.path});

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(covariant oldClipper) {
    return false;
  }
}
