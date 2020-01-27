import 'package:flutter/widgets.dart';

class ScreenUtil {
  static ScreenUtil _instance;

  factory ScreenUtil() => _getInstance();

  static ScreenUtil get instance => _getInstance();

  static ScreenUtil _getInstance() {
    _instance = _instance ?? ScreenUtil._init();
    return _instance;
  }

  ScreenUtil._init() {}

  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getScreenRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  Size getScreenPixel(BuildContext context) {
    var size = getScreenSize(context);
    var ratio = getScreenRatio(context);
    var pixel = Size(size.width * ratio, size.height * ratio);
    return pixel;
  }
}
