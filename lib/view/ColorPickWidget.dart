import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleColorPickWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ColorPickState();
  }
}

class ColorPickState extends State<CircleColorPickWidget> {
  bool _isTap = false;
  Offset _pointOffset = Offset(100 - 5.0, 100 - 5.0);
  Color _selectColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: 200,
        height: 200,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    painter: CircleColorPainter(),
                    size: Size(200, 200),
                  ),
                  Positioned(
                      top: _pointOffset.dy,
                      left: _pointOffset.dx,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.black)),
                        ),
                      )),
                ],
              ),
              onTapDown: (td) {
                _isTap = true;
                colorPickPoint(
                    td.localPosition, _pointOffset, Offset(100, 100), 100 - 5.0);
              },
              onPanUpdate: (pu) {
                _isTap = true;
                colorPickPoint(
                    pu.localPosition, _pointOffset, Offset(100, 100), 100 - 5.0);
              },
              onTapUp: (tu) {
                _isTap = false;
                colorPickPoint(
                    tu.localPosition, _pointOffset, Offset(100, 100), 100 - 5.0);
              },
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: _selectColor),
            )
          ],
        ));
  }

  Color getColorAtPoint(
      Offset selectPoint, Offset centerCircle, double radius) {
    //获取坐标在色盘中的颜色值
    double x = selectPoint.dx - centerCircle.dx;
    double y = selectPoint.dy - centerCircle.dy;
    double r = sqrt(x * x + y * y);
    List<double> hsv = [0.0, 0.0, 1.0];
    hsv[0] = (atan2(-y, -x) / pi * 180).toDouble() + 180;
    hsv[1] = max(0, min(1, (r / radius)));
    return HSVColor.fromAHSV(1.0, hsv[0], hsv[1], hsv[2]).toColor();
  }



  void colorPickPoint(Offset localeOffset, Offset selectOffset,
      Offset circleCenter, var radius) {
    double centerDistance = sqrt(
        pow((circleCenter.dx - localeOffset.dx).abs(), 2) +
            pow((circleCenter.dy - localeOffset.dy).abs(), 2));
    if (centerDistance <= radius) {
      _pointOffset = Offset(localeOffset.dx - 5, localeOffset.dy - 5);
      _selectColor = getColorAtPoint(_pointOffset, circleCenter, radius);
      setState(() {});
    } else{

    }
  }
}

class CircleColorPainter extends CustomPainter {
  Paint _circleColorPaint;
  Paint _selectPointPaint;
  final List<Color> _circleColors = List();
  final List<Color> _selectPointColors = List();
  SweepGradient _circleShader;
  RadialGradient _selectPointShader;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double circleSize =
        (size.width <= size.height ? size.width : size.height) / 2;
    var rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    _circleColorPaint.shader = _circleShader.createShader(rect);
    _selectPointPaint.shader = _selectPointShader.createShader(rect);
    // 注意这一句
    canvas.clipRect(rect);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleSize, _circleColorPaint);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleSize, _selectPointPaint);
  }

  CircleColorPainter() {
    _init();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  void _init() {
    _circleColorPaint = Paint();
    _selectPointPaint = Paint();
    _circleColors
      ..add(Color.fromARGB(255, 255, 0, 0))
      ..add(Color.fromARGB(255, 255, 255, 0))
      ..add(Color.fromARGB(255, 0, 255, 0))
      ..add(Color.fromARGB(255, 0, 255, 255))
      ..add(Color.fromARGB(255, 0, 0, 255))
      ..add(Color.fromARGB(255, 255, 0, 255))
      ..add(Color.fromARGB(255, 255, 0, 0));

    _selectPointColors
      ..add(Color.fromARGB(255, 255, 255, 255))
      ..add(Color.fromARGB(0, 255, 255, 255));

    _circleShader = SweepGradient(colors: _circleColors);
    _selectPointShader = RadialGradient(colors: _selectPointColors);
  }
}
