import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleColorPickWidget extends StatefulWidget {
  Color _selectColor;
  double _width;
  double _height;
  double _selectPointRadius;

  CircleColorPickWidget(
      {Color selectColor,
      double width = 200,
      double height = 200,
      double selectPointRadius = 5})
      : _selectColor = selectColor,
        _width = width,
        _height = height,
        _selectPointRadius = selectPointRadius;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ColorPickState();
  }
}

class ColorPickState extends State<CircleColorPickWidget> {
  bool _isTap = false;
  Offset _pointOffset = Offset(0, 0);
  Offset centerPostion = Offset(0, 0);
  Color _selectColor = Colors.white;
  double _radius=0.0;
  @override
  void initState() {
    super.initState();
    centerPostion = Offset(widget._width / 2, widget._height / 2);
    _pointOffset = Offset(centerPostion.dx - widget._selectPointRadius,
        centerPostion.dy - widget._selectPointRadius);
    _radius=min(widget._width, widget._height)/2;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: widget._width,
        height: widget._height,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    painter: CircleColorPainter(),
                    size: Size(widget._width, widget._height),
                  ),
                  Positioned(
                      top: _pointOffset.dy,
                      left: _pointOffset.dx,
                      child: Container(
                        height: widget._selectPointRadius * 2,
                        width: widget._selectPointRadius * 2,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget._selectPointRadius),
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.black)),
                        ),
                      )),
                ],
              ),
              onTapDown: (td) {
                _isTap = true;
                colorPickPoint(
                    td.localPosition, _pointOffset, centerPostion, _radius);
              },
              onPanUpdate: (pu) {
                _isTap = true;
                colorPickPoint(
                    pu.localPosition, _pointOffset, centerPostion, _radius);
              },
              onTapUp: (tu) {
                _isTap = false;
                colorPickPoint(
                    tu.localPosition, _pointOffset, centerPostion, _radius);
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

  void colorToPoint(Color color, Offset circleCenter, double radius) {
    //RGB转成HSV
    HSVColor hsvColor = HSVColor.fromColor(color);
    //获取点到圆心的距离
    double r = hsvColor.saturation * radius;
    //获取夹角，未知atan2的角度转换是如何的
    double radian = hsvColor.hue / -180.0 * pi;
    //获取到以圆心为坐标轴的(0,0)坐标的坐标轴，(x,y)则是此坐标轴上的点。
    double x = (r * cos(radian));
    double y = (-r * sin(radian));
    //由于x,y直接是以圆心为坐标轴的坐标，所以(x,y)直接运算即可得到距离
    double tr = sqrt(x * x + y * y);
    //判断(x,y)的距离是否超出半径
    if (tr > radius) {
      x *= radius / tr;
      y *= radius / tr;
    }
    //转换出屏幕坐标的实际位置
    x = x + circleCenter.dx+widget._selectPointRadius;
    y = y + circleCenter.dy+widget._selectPointRadius;
    print("Potint--->x:$x,------>y:$y");
  }

  void colorPickPoint(Offset localeOffset, Offset selectOffset,
      Offset circleCenter, var radius) {
    double centerDistance = sqrt(
        pow((circleCenter.dx - localeOffset.dx).abs(), 2) +
            pow((circleCenter.dy - localeOffset.dy).abs(), 2));
    if (centerDistance <= radius) {
      _pointOffset = Offset(localeOffset.dx - widget._selectPointRadius, localeOffset.dy - widget._selectPointRadius);
      _selectColor = getColorAtPoint(_pointOffset, circleCenter, radius);
      setState(() {});
      print("TapPotint--->x:${localeOffset.dx},------>y:${localeOffset.dy}");
      colorToPoint(_selectColor, circleCenter, radius);
    } else {}
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
    double circleSize = min(size.width, size.height) / 2;
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
