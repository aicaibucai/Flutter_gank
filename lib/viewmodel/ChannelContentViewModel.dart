import 'package:flutter_gank_app/net/ApiManage.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';

import 'BaseViewModel.dart';
import 'ChannelViewModel.dart';

class ChannelContentViewModel extends BaseViewModel {
  ChannelModel _channelModel;

  ChannelContentViewModel(this._channelModel);

  String get title => _channelModel.categoryName;
  List<TodayEntity> _content = List();

  List<TodayEntity> get content => _content;

  set index(int value) {
    _index = value;
  }

  int get index => _index;
  int _index = 1;

  @override
  void initData() {
    getChannelContent();
  }

  void getChannelContent() async {
    status = BaseViewModel.LOADING;
    notifyListeners();
    var result = await ApiManage.instance
        .getCategoryContent(_channelModel.category, 10, _index)
        .whenComplete(() {
      status = BaseViewModel.NORMAL;
    }).catchError((e) {
      status = BaseViewModel.ERROR;
    });
    if (result.results != null && result.results.length != 0) {
      _content = result.results;
    } else {
      status = BaseViewModel.EMPTY;
    }
    notifyListeners();
  }
}
