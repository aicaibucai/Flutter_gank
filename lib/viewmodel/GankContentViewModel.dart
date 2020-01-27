import 'BaseViewModel.dart';

class GankContentViewModel extends BaseViewModel {
  String _url;
  int _progress = 0;
  String _title="11111...";
  GankContentViewModel(this._url, {int progress = 0}) : _progress = progress;

  String get url => _url;

  set url(String value) {
    _url = value;
    notifyListeners();
  }

  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  int get progress => _progress;

  set progress(int value) {
    _progress = value;
  }
}
