import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gank_app/page/TodayPage.dart';
import 'package:flutter_gank_app/page/SettingPage.dart';
import 'package:flutter_gank_app/page/ChannelPage.dart';

import 'BaseViewModel.dart';

class HomeModel extends BaseViewModel {
  int _currentIndex = 0;
  List<String> _titleNames = ["今日", "频道", "设置"];

  int get currentIndex => _currentIndex;

  List<String> get titleNames => _titleNames;

  String get title => _titleNames[_currentIndex];

  List<Widget> _pages = List();

  List<Widget> get pages => _pages;

  Widget get currentPage => _pages[_currentIndex];
  PageController _pageController;

  PageController get pageControl => _pageController;

  BuildContext _context = null;

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  BuildContext _currentContext =null;


  BuildContext get currentContext => _currentContext;

  set currentContext(BuildContext value) {
    _currentContext = value;
  }

  @override
  void initData() {
    status = BaseViewModel.NORMAL;
    pages.clear();
    _pageController = PageController();
  }

  void initPage() {
    pages
      ..add(TodayPage())
      ..add(Navigator(onGenerateRoute: (setting) {
        return MaterialPageRoute(
            builder: (build) => ChannelPage(), settings: setting);
      }))
//      ..add(ChannelPage())
      ..add(SettingPage());
  }

  Widget getPage(index) {
    return pages[index];
  }


  void selectIndex(var index, bool isNavigation) {
    _currentIndex = index;
    notifyListeners();
    if (isNavigation) {
      _pageController.jumpToPage(_currentIndex);
    }
  }
}
