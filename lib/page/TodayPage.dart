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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return ChangeNotifierProvider<TodayViewModel>(
        create: (_)=>TodayViewModel()..initData(),
        child: Builder(builder: (todayBuild){
          TodayViewModel viewModel=Provider.of<TodayViewModel>(todayBuild);
          TodayModel model=viewModel.model;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      selectDayInfo(viewModel);
                    }),
                title: Text(model.title),
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
                                      return ContentItemWidget(model.model.content[index]);
                                    }, childCount: model.model.content.length)),
                          )
                        ],
                        controller: ScrollController(),
                      ),
                    );
                    break;
                  case BaseViewModel.ERROR:
                    child = Center(
                      child: Text("Error"),
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
                              model.loadToday();
                            },
                            child: Text("重试",style: TextStyle(color: Colors.white),),
                            color:Colors.blue,
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
                    child: child, onRefresh: () async => await model.loadToday());
              }));
        }));
  }

  List<Widget> generateExpendTag(TodayViewModel model) {
    List<Widget> tags = List();
    model.model.category.forEach((key, value) {
      if (key == model.model.allSelectTag) {
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
              if (!(!bool && model.model.SelectSize == 1)) {
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
    model.model.category.forEach((key, value) {
      if (key == model.model.allSelectTag) {
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
              if (!(!bool && model.model.SelectSize == 1)) {
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
  }

  void selectDayInfo(TodayViewModel viewModel) {
    TodayModel model=viewModel.model;
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
        viewModel.loadToday();
      } else {
        model.isToday = false;
        model.selectDate = dt;
        viewModel.loadDate(dt);
      }
    }).catchError((error) {
      print("ShowDatePickError${error.toString()}");
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
