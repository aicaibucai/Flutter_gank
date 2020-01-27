import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeViewModel extends ChangeNotifier {
  Color _primaryColor;
  Color _appBarTheme;
  Color _primarySwatch;
  static const List<Color> _colors = [
    Colors.red,
    Colors.grey,
    Colors.blue,
    Colors.yellow,
    Colors.teal,
    Colors.black,
    Colors.amber,
    Colors.deepPurple,
    Colors.orange
  ];

  static List<Color> get colors => _colors;

  Color get primaryColor => _primaryColor;

  set primaryColor(Color value) {
    _primaryColor = value;
    notifyListeners();
  }

  ThemeViewModel(
      {Color primaryColor = Colors.blue,
      Color appBarTheme = Colors.blue,
      Color primarySwatch = Colors.blue})
      : _primaryColor = primaryColor,
        _appBarTheme = appBarTheme,
        _primarySwatch = primarySwatch;

  Color get appBarTheme => _appBarTheme;

  set appBarTheme(Color value) {
    _appBarTheme = value;
    notifyListeners();
  }

  Color get primarySwatch => _primarySwatch;

  set primarySwatch(Color value) {
    _primarySwatch = value;
    notifyListeners();
  }
}
