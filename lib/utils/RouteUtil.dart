import 'package:flutter/widgets.dart';

class RouteUtil {
  static RouteUtil _instance;

  factory RouteUtil() => _getInstance();

  static RouteUtil get instance => _getInstance();

  static RouteUtil _getInstance() {
    _instance = _instance ?? RouteUtil._init();
    return _instance;
  }

  RouteUtil._init() {}

}
