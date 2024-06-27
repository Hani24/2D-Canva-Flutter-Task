import 'package:flutter/material.dart';

class Rectangle {
  Rect rect;
  double width;
  double height;
  bool isConnecting; // Indicates if this rectangle is part of an L-shape
  double fixedDimension; // The fixed dimension for the L-shape

  Rectangle(this.rect, this.width, this.height,
      {this.isConnecting = false, required this.fixedDimension});
}
