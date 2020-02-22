import 'package:dio/dio.dart';
import 'package:flutter_gank_app/net/ApiManage.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';
import 'package:flutter_gank_app/utils/DateUtil.dart';

import 'BaseViewModel.dart';

class TodayViewModel extends BaseViewModel {
  TodayModel _model;

  TodayModel get  model=>_model;

  @override
  void initData() {
    var now = DateTime.now();
    _model=TodayModel();
    _model._selectDate = DateTime(now.year, now.month, now.day);
    loadToday();
  }

  void refreshToday() {
    _model. content.clear();
    _model.title = _model.isToday ? "今日" : _model.selectDate.toSimpleDate();
    List<String> tags = List();
    _model._category.forEach((key, value) {
      if (value) {
        tags.add(key);
      }
    });
    if (_model._category[_model._allSelectTag]) {
      for (var tag in _model._category.keys.toList()) {
        if (tag == "福利" || tag == _model._allSelectTag) continue;
        if (_model._categoryContent.containsKey(tag)) {
          _model.content.addAll(_model._categoryContent[tag]);
        }
      }
    } else {
      for (var tag in tags) {
        if (_model._categoryContent.containsKey(tag)) {
          _model.content.addAll(_model._categoryContent[tag]);
        }
      }
    }
    notifyListeners();
  }

  void loadToday() async {
    status = BaseViewModel.LOADING;
    notifyListeners();
    var result = await ApiManage.instance.getToday().whenComplete(() {
      status = BaseViewModel.NORMAL;
    }).catchError((e) {
      if(e is DioErrorType){
        status = BaseViewModel.NETWORK_ERROR;
      }else{
        status = BaseViewModel.ERROR;
      }
    });
    if(status==BaseViewModel.NORMAL){
      _model._category.clear();
      _model._category[_model._allSelectTag] = true;
      if (result!=null&&result.error == false) {
        if (result.category != null) {
          result.category.forEach((cate) {
            if (cate != "福利") _model._category[cate] = false;
          });
        }
        if (result.results == null || result.results.length == 0) {
          status = BaseViewModel.EMPTY;
        }
        _model._categoryContent = result.results;
        refreshToday();
      } else {
        status = BaseViewModel.ERROR;
        notifyListeners();
      }
    }else{
      notifyListeners();
    }
  }

  void selectAll() {
    _model._category.forEach((key, value) {
      _model._category[key] = false;
    });
    _model. _category[_model._allSelectTag] = true;
    _model._selectSize = 1;
    refreshToday();
  }

  void selectTag(String tag, bool select) {
    _model._category[_model._allSelectTag] = false;
    _model._category[tag] = select;
    _model._selectSize =
        _model._category.values.toList().where((bool) => bool).toList().length;
    refreshToday();
  }

  void loadDate(DateTime dateTime) async {
    await loadStringDate(dateTime.year.toString(), dateTime.month.toString(),
        dateTime.day.toString());
  }

  void loadStringDate(String year, String month, String day) async {
    status = BaseViewModel.LOADING;
    notifyListeners();
    var result =
        await ApiManage.instance.getDate(year, month, day).whenComplete(() {
      status = BaseViewModel.NORMAL;
    }).catchError((e) {
      status = BaseViewModel.ERROR;
    });
    _model._category.clear();
    _model._category[_model._allSelectTag] = true;
    if (result.category != null) {
      result.category.forEach((cate) {
        if (cate != "福利") _model._category[cate] = false;
      });
    }
    if (result.results == null || result.results.length == 0) {
      status = BaseViewModel.EMPTY;
    }
    _model._categoryContent = result.results;
    refreshToday();
  }
}

class TodayModel {
  String _allSelectTag = "全部";
  Map<String, bool> _category = Map();

  Map<String, List<TodayEntity>> _categoryContent = Map();

  Map<String, bool> get category => _category;

  Map<String, List<TodayEntity>> get categoryContent => _categoryContent;

  List<TodayEntity> content = List();

  bool get selectAllSelect => _category[_allSelectTag];

  String get allSelectTag => _allSelectTag;

  int _selectSize = 0;

  int get SelectSize => _selectSize;

  DateTime _selectDate;

  DateTime get selectDate => _selectDate;
  bool isToday = true;
  String title = "今日";
  set selectDate(DateTime value) {
    _selectDate = value;
  }

}
