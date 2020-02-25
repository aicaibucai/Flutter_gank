import 'package:flutter/widgets.dart';

class BaseViewModel with ChangeNotifier {
  static const int NORMAL = 2;
  static const int EMPTY = 3;
  static const int LOADING = 1;
  static const int INIT = 0;
  static const int ERROR = -1;
  static const int NETWORK_ERROR = -2;
  int _status = INIT;

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  void initData() {}
}
