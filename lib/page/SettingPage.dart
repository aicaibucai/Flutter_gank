import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
                        "标题栏颜色",
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
            )
          ],
        ),
      ),
    );
  }
}

class ChangeTheme extends Dialog {
  int tempSelect = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Color> colors = ThemeViewModel.colors;
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
              return ThemeSelect(colors[index]);
            });
          },
          itemCount: colors.length,
        ),
      ),
    );
  }
}

class ThemeSelect extends StatefulWidget {
  Color _color;

  ThemeSelect(
    this._color,
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
            color: widget._color,
          ),
          Consumer<ThemeViewModel>(
            builder: (_, c, child) {
              bool select = (widget._color == c.appBarTheme) ?? false;
              return Offstage(
                offstage: !select,
                child: Align(
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: reverseColor(widget._color),
                  ),
                  alignment: Alignment.bottomRight,
                ),
              );
            },
          )
        ],
      ),
      onTap: () {
        Provider.of<ThemeViewModel>(context, listen: false).appBarTheme =
            widget._color;
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
