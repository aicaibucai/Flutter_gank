import 'package:flutter/material.dart';
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
  TodayViewModel _TodayViewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return ChangeNotifierProvider<TodayViewModel>.value(
        value: _TodayViewModel,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () {
                    selectDayInfo();
                  }),
              title: Consumer<TodayViewModel>(builder: (_, model, widget) {
                return Text(model.title);
              }),
            ),
            body: Consumer<TodayViewModel>(builder: (_, model, widget) {
              Widget child;
              switch (model.status) {
                case BaseViewModel.NORMAL:
                  child = Container(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Container(
                              child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: generateClosedTag(model),
                            ),
                          )),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(top: 10),
                          sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (buildcontext, index) {
                            return ContentItemWidget(model.content[index]);
                          }, childCount: model.content.length)),
                        )
                      ],
                      controller: ScrollController(),
                    ),
                  );
                  break;
                case BaseViewModel.ERROR:
                case BaseViewModel.NETWORK_ERROR:
                  child = Center(
                    child: Text("Error"),
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
                  child: child, onRefresh: () async => await model.loadToday());
            })));
  }

  List<Widget> generateExpendTag(TodayViewModel model) {
    List<Widget> tags = List();
    model.category.forEach((key, value) {
      if (key == model.allSelectTag) {
        tags.add(Container(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: ChoiceChip(
            label: Text(key),
            selected: value,
            onSelected: (bool) {
              model.selectAll();
            },
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
        ));
      } else {
        tags.add(Container(
          padding: EdgeInsets.only(left: 10),
          child: ChoiceChip(
            label: Text(key),
            selected: value,
            onSelected: (bool) {
              if (!(!bool && model.SelectSize == 1)) {
                model.selectTag(key, bool);
              }
            },
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
        ));
      }
    });
    return tags;
  }

  List<Widget> generateClosedTag(TodayViewModel model) {
    List<Widget> tags = List();
    model.category.forEach((key, value) {
      if (key == model.allSelectTag) {
        tags.add(Container(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: ChoiceChip(
            label: Text(key),
            selected: value,
            onSelected: (bool) {
              model.selectAll();
            },
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
        ));
      } else {
        tags.add(Container(
          padding: EdgeInsets.only(left: 10),
          child: ChoiceChip(
            label: Text(key),
            selected: value,
            onSelected: (bool) {
              if (!(!bool && model.SelectSize == 1)) {
                model.selectTag(key, bool);
              }
            },
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
        ));
      }
    });
    return tags;
  }

  @override
  void initState() {
    super.initState();
    _TodayViewModel = TodayViewModel()..initData();
  }

  void selectDayInfo() {
    showDatePicker(
      context: context,
      initialDate: _TodayViewModel.selectDate,
      firstDate: DateTime(2015, 08, 06),
      lastDate: DateTime.now(),
    ).then((dt) {
      if (dt.difference(DateTime.now()).inDays == 0) {
        _TodayViewModel.isToday = true;
        var now = DateTime.now();
        _TodayViewModel.selectDate = DateTime(now.year, now.month, now.day);
        _TodayViewModel.loadToday();
      } else {
        _TodayViewModel.isToday = false;
        _TodayViewModel.selectDate = dt;
        _TodayViewModel.loadDate(dt);
      }
    }).catchError((error) {
      print("ShowDatePickError${error.toString()}");
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
