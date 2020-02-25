import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeModel _themeModel;

  ThemeModel get themeModel => _themeModel;

  set themeModel(ThemeModel value) {
    _themeModel = value;
    notifyListeners();
  } //  static const List<Color> _colors = [

//    Colors.red,
//    Colors.grey,
//    Colors.blue,
//    Colors.yellow,
//    Colors.teal,
//    Colors.black,
//    Colors.amber,
//    Colors.deepPurple,
//    Colors.orange
//  ];
//
//  static List<Color> get colors => _colors;
  ThemeViewModel(ThemeModel themeModel) : _themeModel = themeModel;
}

class ThemeModel {
  Color _primaryColor;
  Color _appBarTheme;
  Color _primarySwatch;
  Color _contentTextColor;

  ThemeModel(Color primaryColor,Color appBarTheme,Color primarySwatch,Color contentTextColor)
      : _primaryColor = primaryColor,
        _appBarTheme = appBarTheme,
        _primarySwatch = primarySwatch,
        _contentTextColor = contentTextColor;

  set primaryColor(Color value) {
    _primaryColor = value;
  }

  Color get primaryColor => _primaryColor;

  set appBarTheme(Color value) {
    _appBarTheme = value;
  }

  Color get contentTextColor => _contentTextColor;

  set contentTextColor(Color value) {
    _contentTextColor = value;
  }

  Color get appBarTheme => _appBarTheme;

  Color get primarySwatch => _primarySwatch;

  set primarySwatch(Color value) {
    _primarySwatch = value;
  }
}
