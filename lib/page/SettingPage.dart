import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank_app/Config/ThemeConfig.dart';
import 'package:flutter_gank_app/view/ColorPickWidget.dart';
import 'package:flutter_gank_app/viewmodel/ThemeViewModel.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingState();
  }
}

class SettingState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "主题颜色",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      color: themeData.appBarTheme.color,
                    )
                  ],
                ),
              ),
              onTap: () {
//                print(
//                    "ThemeViewModel:${Provider.of<ThemeViewModel>(context, listen: false).primaryColor}");
                showDialog(
                  context: context,
                  child: ChangeTheme(),
                );
              },
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "自定义颜色",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      color: themeData.appBarTheme.color,
                    )
                  ],
                ),
              ),
              onTap: () {
//                print(
//                    "ThemeViewModel:${Provider.of<ThemeViewModel>(context, listen: false).primaryColor}");
                showDialog(
                  context: context,
                  child: ColorPickDialog(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ColorPickDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: 400,
      height: 400,
      child: CircleColorPickWidget(selectColor: Colors.red,),
      decoration: BoxDecoration(color: Colors.white),
    ),);
  }
}

class ChangeTheme extends Dialog {
  int tempSelect = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        width: 400,
        height: 400,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              childAspectRatio: 1,
              crossAxisSpacing: 1),
          itemBuilder: (bContext, index) {
            return Builder(builder: (c) {
              return ThemeSelect(ThemeConfig.themeModels[index]);
            });
          },
          itemCount: ThemeConfig.themeModels.length,
        ),
      ),
    );
  }
}

class ThemeSelect extends StatefulWidget {
  ThemeModel _themeModel;

  ThemeSelect(
    this._themeModel,
  );

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ThemeSelectState();
  }
}

class ThemeSelectState extends State<ThemeSelect> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            color: widget._themeModel.appBarTheme,
          ),
          Consumer<ThemeViewModel>(
            builder: (_, c, child) {
              bool select = (widget._themeModel == c.themeModel) ?? false;
              return Offstage(
                offstage: !select,
                child: Align(
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: reverseColor(widget._themeModel.appBarTheme),
                  ),
                  alignment: Alignment.bottomRight,
                ),
              );
            },
          )
        ],
      ),
      onTap: () {
        Provider.of<ThemeViewModel>(context, listen: false).themeModel =
            widget._themeModel;
      },
    );
  }

  Color reverseColor(Color color) {
    var green = 255 - color.green;
    var blue = 255 - color.blue;
    var red = 255 - color.red;
    return Color.fromARGB(color.alpha, red, green, blue);
  }
}
