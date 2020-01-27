import 'package:flutter/material.dart';
import 'package:flutter_gank_app/view/ContentItemWidget.dart';
import 'package:flutter_gank_app/viewmodel/BaseViewModel.dart';
import 'package:flutter_gank_app/viewmodel/ChannelContentViewModel.dart';
import 'package:flutter_gank_app/viewmodel/ChannelViewModel.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  ChannelModel _channelModel;

  CategoryPage(this._channelModel);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoryState();
  }
}

class _CategoryState extends State<CategoryPage> {
  ChannelContentViewModel _model;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ChannelContentViewModel>(
      create: (_) =>
          _model = ChannelContentViewModel(widget._channelModel)..initData(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget._channelModel.categoryName),
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<ChannelContentViewModel>(
            builder: (_, model, widget) {
              Widget child;
              switch (model.status) {
                case BaseViewModel.NORMAL:
                  child = Container(
                    child: CustomScrollView(
                      slivers: <Widget>[
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
              return RefreshIndicator(child: child, onRefresh: () {});
            },
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void findContext(BuildContext context) async {
    State consa = context.findAncestorStateOfType();
    if (consa != null) {
      print("ShowASDContext:${consa.toString()}");
      findContext(consa.context);
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
