import 'package:flutter/material.dart';
import 'package:flutter_gank_app/view/ChannelWidget.dart';
import 'package:flutter_gank_app/viewmodel/ChannelViewModel.dart';
import 'package:flutter_gank_app/viewmodel/HomeViewModel.dart';
import 'package:provider/provider.dart';

import 'CategoryPage.dart';
import 'HomePage.dart';
import 'SearchPage.dart';

class ChannelPage extends StatefulWidget {
  ChannelPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChannelState();
  }
}

class _ChannelState extends State<ChannelPage> {
  ChannelViewModel _channelViewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ChannelViewModel>.value(
        value: _channelViewModel,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_channelViewModel.title),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (rbcontext) {
                      return SearchPage();
                    }));
                  })
            ],
          ),
          body: Container(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.3),
              itemBuilder: (bcontext, index) {
                return ChannelWidget(_channelViewModel.categorys[index], () {
                  Navigator.of(bcontext)
                      .push(MaterialPageRoute(builder: (context) {
                    return CategoryPage(_channelViewModel.categorys[index]);
                  }));
                });
              },
              itemCount: _channelViewModel.categorys.length,
            ),
          ),
        ));
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
    _channelViewModel = ChannelViewModel()..initData();
  }
}
