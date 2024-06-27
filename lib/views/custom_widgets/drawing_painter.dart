import 'package:flutter/material.dart';
import '../../data/rectangle.dart';

class DrawingPainter extends CustomPainter {
  final List<Rectangle> rectangles;

  DrawingPainter(this.rectangles);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey[900]!
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var rectangle in rectangles) {
      if (rectangle.isConnecting) {
        drawLShape(canvas, rectangle, fillPaint, borderPaint);
      } else {
        canvas.drawRect(rectangle.rect, fillPaint);
        canvas.drawRect(rectangle.rect, borderPaint);
        drawDimensions(canvas, rectangle.rect);
      }
    }
  }

  void drawLShape(Canvas canvas, Rectangle rectangle, Paint fillPaint, Paint borderPaint) {
    final rect = rectangle.rect;
    final path = Path();

    if (rectangle.width > rectangle.height) {
      // Swiped horizontally first then vertically
      if (rect.width > rect.height) {
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.close();
      } else {
        // Swiped vertically first then horizontally
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.top);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.bottom);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.right, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left, rect.top + rectangle.fixedDimension);
        path.close();
      }
    } else {
      if (rect.height > rect.width) {
        // Swiped vertically first then horizontally
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.close();
      } else {
        // Swiped horizontally first then vertically
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.top);
        path.lineTo(rect.left + rectangle.fixedDimension, rect.bottom);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.right, rect.top + rectangle.fixedDimension);
        path.lineTo(rect.left, rect.top + rectangle.fixedDimension);
        path.close();
      }
    }

    // Draw the filled L-shape
    canvas.drawPath(path, fillPaint);
    // Draw the stroke for the L-shape
    canvas.drawPath(path, borderPaint);

    // Draw dimensions for the L-shape
    drawLShapeDimensions(canvas, rectangle);
  }

  void drawDimensions(Canvas canvas, Rect rect) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    // Height text
    final heightSpan =
    TextSpan(text: rect.height.toStringAsFixed(2), style: textStyle);
    final heightPainter = TextPainter(
      text: heightSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    heightPainter.layout(minWidth: 0, maxWidth: double.infinity);

    final heightX = rect.left - heightPainter.width - 5;
    final heightY = rect.center.dy - heightPainter.height / 2;

    heightPainter.paint(canvas, Offset(heightX, heightY));

    // Width text
    final widthSpan =
    TextSpan(text: rect.width.toStringAsFixed(2), style: textStyle);
    final widthPainter = TextPainter(
      text: widthSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    widthPainter.layout(minWidth: 0, maxWidth: double.infinity);

    final widthX = rect.center.dx - widthPainter.width / 2;
    final widthY = rect.top - widthPainter.height - 5;

    widthPainter.paint(canvas, Offset(widthX, widthY));
  }

  void drawLShapeDimensions(Canvas canvas, Rectangle rectangle) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    final rect = rectangle.rect;

    // Drawing the longer dimension (the full L-shape height/width)
    final longerDimension = rectangle.width > rectangle.height
        ? rectangle.width.toStringAsFixed(2)
        : rectangle.height.toStringAsFixed(2);
    final longerSpan = TextSpan(text: longerDimension, style: textStyle);
    final longerPainter = TextPainter(
      text: longerSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    longerPainter.layout(minWidth: 0, maxWidth: double.infinity);

    if (rectangle.width > rectangle.height) {
      // Drawing width for horizontal-vertical L-shape
      final longerX = rect.center.dx - longerPainter.width / 2;
      final longerY = rect.top - longerPainter.height - 5;
      longerPainter.paint(canvas, Offset(longerX, longerY));
    } else {
      // Drawing height for vertical-horizontal L-shape
      final longerX = rect.left - longerPainter.width - 5;
      final longerY = rect.center.dy - longerPainter.height / 2;
      longerPainter.paint(canvas, Offset(longerX, longerY));
    }

    // Drawing the shorter dimension (the L-part length/width)
    final shorterDimension = rectangle.width > rectangle.height
        ? rectangle.height.toStringAsFixed(2)
        : rectangle.width.toStringAsFixed(2);
    final shorterSpan = TextSpan(text: shorterDimension, style: textStyle);
    final shorterPainter = TextPainter(
      text: shorterSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    shorterPainter.layout(minWidth: 0, maxWidth: double.infinity);

    if (rectangle.width > rectangle.height) {
      // Drawing height for horizontal-vertical L-shape
      final shorterX = rect.right + 5;
      final shorterY =
          rect.top + rectangle.fixedDimension / 2 - shorterPainter.height / 2;
      shorterPainter.paint(canvas, Offset(shorterX, shorterY));
    } else {
      // Drawing width for vertical-horizontal L-shape
      final shorterX =
          rect.left + rectangle.fixedDimension / 2 - shorterPainter.width / 2;
      final shorterY = rect.bottom + 5;
      shorterPainter.paint(canvas, Offset(shorterX, shorterY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
