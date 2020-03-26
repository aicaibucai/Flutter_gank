import 'package:flutter_gank_app/net/ApiManage.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';
import 'package:flutter_gank_app/viewmodel/BaseViewModel.dart';

class SearchViewModel extends BaseViewModel {
  List<String> category = [
    "all",
    "Android",
    "iOS",
    "休息视频",
    "福利",
    "拓展资源",
    "前端",
    "瞎推荐",
    "App"
  ];
  int categoryIndex = 0;
  List<TodayEntity> content;
  int count;
  int pageNum;

  void search(String query) async {
    status = BaseViewModel.LOADING;
    notifyListeners();
    var result = await ApiManage.instance
        .searchCategory(query, category[categoryIndex], count, pageNum)
        .catchError((e) {
      return Future.value(Null);
    });
    if (result != null) {
      if (result.error) {
        status = BaseViewModel.ERROR;
        notifyListeners();
      } else {

      }
    } else {

    }
  }
}
