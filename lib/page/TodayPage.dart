import 'package:flutter/material.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';
import 'package:flutter_gank_app/view/ContentItemWidget.dart';
import 'package:flutter_gank_app/viewmodel/BaseViewModel.dart';
import 'package:flutter_gank_app/viewmodel/HomeViewModel.dart';
import 'package:flutter_gank_app/viewmodel/TodayViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class TodayPage extends StatefulWidget {
  TodayPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage>
    with AutomaticKeepAliveClientMixin {
  TodayViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return ChangeNotifierProvider<TodayViewModel>.value(
        value: _viewModel.status == BaseViewModel.INIT
            ? (_viewModel..initData())
            : _viewModel,
        child: Builder(builder: (todayBuild) {
          print("Viewmodel重绘${DateTime.now().millisecondsSinceEpoch}");
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      selectDayInfo(_viewModel);
                    }),
                title: Selector<TodayViewModel, String>(
                    selector: (sContext, model) {
                  return model.title;
                }, builder: (_, title, widget) {
                  print("title重绘${DateTime.now().millisecondsSinceEpoch}");
                  return Text(title);
                }),
              ),
              body: Selector<TodayViewModel, int>(selector: (sContext, model) {
                return model.status;
              }, builder: (_, status, widget) {
                print("status重绘${DateTime.now().millisecondsSinceEpoch}");
                Widget child;
                switch (status) {
                  case BaseViewModel.NORMAL:
                    child = Container(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: generateClosedTag(_viewModel),
                              ),
                            )),
                          ),
                          Selector<TodayViewModel, List<TodayEntity>>(
                            selector: (sContext, model) {
                              return model.content;
                            },
                            builder: (_, content, widget) {
                              print(
                                  "ListView重绘${DateTime.now().millisecondsSinceEpoch}");
                              return SliverPadding(
                                padding: EdgeInsets.only(top: 10),
                                sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (buildcontext, index) {
                                  return ContentItemWidget(content[index]);
                                }, childCount: content.length)),
                              );
                            },
                          ),
                        ],
                        controller: ScrollController(),
                      ),
                    );
                    break;
                  case BaseViewModel.ERROR:
                    child = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("系统错误,请点击重试按钮重试"),
                          MaterialButton(
                            onPressed: () {
                              _viewModel.refreshResult();
                            },
                            child: Text(
                              "重试",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                          )
                        ],
                      ),
                    );
                    break;
                  case BaseViewModel.NETWORK_ERROR:
                    child = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("网络错误，请点击重试按钮重试。"),
                          MaterialButton(
                            onPressed: () {
                              _viewModel.refreshResult();
                            },
                            child: Text(
                              "重试",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )
                        ],
                      ),
                    );
                    break;
                  case BaseViewModel.INIT:
                    child = Container();
                    break;
                  case BaseViewModel.LOADING:
                    child = Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case BaseViewModel.EMPTY:
                    child = Center(
                        child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/empty_icon.png"),
                          Text(
                            "没有干货哦!",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ));
                    break;
                }
                return RefreshIndicator(
                    child: child,
                    onRefresh: () async =>
                      await  _viewModel.refreshResult());
              }));
        }));
  }

  List<Widget> generateExpendTag(TodayViewModel model) {
    List<Widget> tags = List();
    model.category.forEach((key, value) {
      if (key == model.allSelectTag) {
        tags.add(Selector<TodayViewModel, bool>(builder: (_, vs, widget) {
          return Container(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: ChoiceChip(
              label: Text(key),
              selected: vs,
              onSelected: (bool) {
                model.selectAll();
              },
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
          );
        }, selector: (sContext, model) {
          return model.category[key];
        }));
      } else {
        tags.add(Selector<TodayViewModel, bool>(builder: (_, vs, widget) {
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: ChoiceChip(
              label: Text(key),
              selected: vs,
              onSelected: (bool) {
                if (!(!bool && model.SelectSize == 1)) {
                  model.selectTag(key, bool);
                }
              },
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
          );
        }, selector: (sContext, model) {
          return model.category[key];
        }));
      }
    });
    return tags;
  }

  List<Widget> generateClosedTag(TodayViewModel viewModel) {
    print("Tag重绘${DateTime.now().millisecondsSinceEpoch}");
    List<Widget> tags = List();
    viewModel.category.forEach((key, value) {
      if (key == viewModel.allSelectTag) {
        tags.add(Selector<TodayViewModel, bool>(builder: (_, vs, widget) {
          return Container(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: ChoiceChip(
              label: Text(key),
              selected: vs,
              onSelected: (bool) {
                viewModel.selectAll();
              },
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
          );
        }, selector: (sContext, model) {
          return model.category[key];
        }));
      } else {
        tags.add(Selector<TodayViewModel, bool>(builder: (_, vs, widget) {
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: ChoiceChip(
              label: Text(key),
              selected: vs,
              onSelected: (bool) {
                if (!(!bool && viewModel.SelectSize == 1)) {
                  viewModel.selectTag(key, bool);
                }
              },
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
          );
        }, selector: (sContext, model) {
          return model.category[key];
        }));
      }
    });
    return tags;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = TodayViewModel();
  }

  void selectDayInfo(TodayViewModel model) {
    showDatePicker(
      context: context,
      initialDate: model.selectDate,
      firstDate: DateTime(2015, 08, 06),
      lastDate: DateTime.now(),
    ).then((dt) {
      if (dt.difference(DateTime.now()).inDays == 0) {
        model.isToday = true;
        var now = DateTime.now();
        model.selectDate = DateTime(now.year, now.month, now.day);
        model.loadToday();
      } else {
        model.isToday = false;
        model.selectDate = dt;
        model.loadDate(dt);
      }
    }).catchError((error) {
      print("ShowDatePickError${error.toString()}");
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
