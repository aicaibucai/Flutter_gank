import 'package:dio/dio.dart';
import 'package:flutter_gank_app/net/ApiManage.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';
import 'package:flutter_gank_app/utils/DateUtil.dart';

import 'BaseViewModel.dart';

class TodayViewModel extends BaseViewModel {

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
  
  @override
  void initData() {
    var now = DateTime.now();
    _selectDate = DateTime(now.year, now.month, now.day);
    loadToday();
  }

  void refreshToday() {
    content=List<TodayEntity>();
    title = isToday ? "今日" : selectDate.toSimpleDate();
    List<String> tags = List();
    _category.forEach((key, value) {
      if (value) {
        tags.add(key);
      }
    });
    if (_category[_allSelectTag]) {
      for (var tag in _category.keys.toList()) {
        if (tag == "福利" || tag == _allSelectTag) continue;
        if (_categoryContent.containsKey(tag)) {
          content.addAll(_categoryContent[tag]);
        }
      }
    } else {
      for (var tag in tags) {
        if (_categoryContent.containsKey(tag)) {
          content.addAll(_categoryContent[tag]);
        }
      }
    }
    notifyListeners();
  }

  void loadToday({bool isInit=true}) async {
    status = BaseViewModel.LOADING;
    if(isInit){
      notifyListeners();
    }
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
      _category.clear();
      _category[_allSelectTag] = true;
      if (result!=null&&result.error == false) {
        if (result.category != null) {
          result.category.forEach((cate) {
            if (cate != "福利") _category[cate] = false;
          });
        }
        if (result.results == null || result.results.length == 0) {
          status = BaseViewModel.EMPTY;
        }
        _categoryContent = result.results;
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
    _category.forEach((key, value) {
      _category[key] = false;
    });
     _category[_allSelectTag] = true;
    _selectSize = 1;
    refreshToday();
  }

  void selectTag(String tag, bool select) {
    _category[_allSelectTag] = false;
    _category[tag] = select;
    _selectSize =
        _category.values.toList().where((bool) => bool).toList().length;
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
    _category.clear();
    _category[_allSelectTag] = true;
    if (result.category != null) {
      result.category.forEach((cate) {
        if (cate != "福利") _category[cate] = false;
      });
    }
    if (result.results == null || result.results.length == 0) {
      status = BaseViewModel.EMPTY;
    }
    _categoryContent = result.results;
    refreshToday();
  }
}

