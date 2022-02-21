import 'package:flutter/material.dart';

class MyGradient extends BoxDecoration {
  
  MyGradient({
    required startColor,
    required endColor,
    bool horizontal: false,
    bool diagonal: false,
    double radius: 0
  }): super(
    gradient: LinearGradient(
        colors: [startColor, endColor],
      begin: (diagonal) ? Alignment.bottomLeft : const FractionalOffset(0, 0),
      end: (diagonal) ? Alignment.topRight : (horizontal) ? const FractionalOffset(1, 0) : const FractionalOffset(0, 1)
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius))
  );
}