import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank_app/viewmodel/HomeViewModel.dart';
import 'package:provider/provider.dart';

import 'CategoryPage.dart';
import 'TodayPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeSate();
  }
}

class HomeSate extends State<HomePage> {
  HomeModel _homeModel;
  List<Widget> _leadWidget;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TODO: implement build
    print("HomePageBuild:${DateTime.now().toIso8601String()}");
    return ChangeNotifierProvider.value(
        value: _homeModel
          ..initData()
          ..context = context
          ..initPage(),
        child: SafeArea(
            child: WillPopScope(
                child: Scaffold(
                    body: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _homeModel.getPage(index);
                      },
                      itemCount: _homeModel.pages.length,
//            onPageChanged: (index) {
//              if (index != _homeModel.currentIndex) {
//                _homeModel.selectIndex(index, false);
//              }
//            },
                      controller: _homeModel.pageControl,
                    ),
                    bottomNavigationBar:
                        Consumer<HomeModel>(builder: (build, model, widget) {
                      return BottomNavigationBar(
                        currentIndex: model.currentIndex,
                        selectedItemColor: themeData.primaryColor,
                        items: [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.ac_unit),
                              title: Text("今日"),
                              activeIcon: Icon(
                                Icons.ac_unit,
                              )),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.apps),
                              title: Text("频道"),
                              activeIcon: Icon(
                                Icons.apps,
                              )),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings),
                              title: Text("设置"),
                              activeIcon: Icon(
                                Icons.settings,
                              ))
                        ],
                        onTap: (index) {
                          model.selectIndex(index, true);
                        },
                      );
                    })),
                onWillPop: () async {
                  print("HomePage:back press");
                  if (_homeModel.currentPage is Navigator) {
                    print("HomePage:嵌套路由返回");
                    if (Navigator.of(_homeModel.currentContext).canPop()) {
                      Navigator.of(_homeModel.currentContext).pop();
                      return false;
                    } else {
                      return true;
                    }
                  }
                  return true;
                })));
  }

  @override
  void initState() {
    super.initState();
    _homeModel = HomeModel();
  }

  Widget _leadButton(int index) {
    return _leadWidget[index];
  }
}
