import 'dart:math';

import 'package:eduapp/globals.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AccountBackShape extends CustomPainter {
  double heightMultiplier;
  Color surfaceColor;
  double arcRadius;
  Color firstColor;

  AccountBackShape(this.arcRadius, this.heightMultiplier, this.surfaceColor,
      {this.firstColor = const Color(0xFF8DBEE6)});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(size.width, size.height * 0.8),
          [this.firstColor, this.surfaceColor])
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset arcEnd = Offset(size.width, size.height * this.heightMultiplier);

    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.arcToPoint(arcEnd,
        radius: Radius.circular(this.arcRadius), clockwise: false);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleIndicator extends CustomPainter {
  double currentProgress;
  double strokewidth;

  CircleIndicator(this.currentProgress, {this.strokewidth = 50});

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = strokewidth
      ..color = secondaryDarkThemeColor.withAlpha(50)
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = strokewidth
      // ..color = primaryThemeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(size.width, size.height),
          [primaryThemeColor, primaryThemeColor.withGreen(180)]);

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class QuizElevatedButton extends StatelessWidget {
  const QuizElevatedButton(
      {Key? key,
      this.title = "",
      this.color = const Color(0xFFFFC7FA5),
      this.borderColor = primaryThemeColor,
      this.tapFunc,
      this.size = const Size(120, 50),
      this.textColor = const Color(0xFFFFFFFF5),
      this.surfaceColor = primaryThemeColor,
      this.elevation})
      : super(key: key);

  final String title;
  final Color color;
  final Color textColor;
  final Color surfaceColor;
  final Color borderColor;
  final Function? tapFunc;
  final Size size;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          tapFunc!();
        },
        style: ElevatedButton.styleFrom(
          primary: surfaceColor,
          side: BorderSide(width: 1.0, color: borderColor),
          onSurface: surfaceColor,
          minimumSize: size,
          elevation: elevation,
        ),
        child: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ));
  }
}
