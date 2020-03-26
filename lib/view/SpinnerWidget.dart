import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  Widget child;

  SpinnerWidget(this.child);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SpinnerState();
  }
}

class ShowDownMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowDownState();
  }
}

class ShowDownState extends State<ShowDownMenu> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                    child: Container(
                  width: 50,
                  height: 200,
                  color: Colors.amberAccent,
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return Text(
                        "Index:$index",
                        style: TextStyle(color: Colors.blue),
                      );
                    },
                    shrinkWrap: true,
                    primary: true,
                    itemCount: 10,
                  ),
                )),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ));
  }
}

class SpinnerRoute extends PopupRoute {
  Widget _child;
  Duration _duration = Duration(milliseconds: 10);

  SpinnerRoute({Widget child}) : _child = child;

  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return _child;
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => _duration;
}

class SpinnerState extends State<SpinnerWidget> {
  Offset targetWidgetOffset;
  Size targetWidgetSize;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: widget.child,
      onTap: () {
        showPopupWidget();
      },
    );
  }

  Widget _generatorPopupMenu() {
    return Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return Text(
                        "Index:$index",
                        style: TextStyle(color: Colors.black),
                      );
                    },
                    itemCount: 10,
                    primary: true,
                  ),
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  void showPopupWidget() {
    RenderBox renderBox = context.findRenderObject();
    Offset localToGlobal =
        renderBox.localToGlobal(Offset.zero); //targetWidget的坐标位置
    Size size = renderBox.size; //targetWidget的size
    targetWidgetOffset = localToGlobal;
    targetWidgetSize = size;
    print("targetWidgetOffset:${targetWidgetOffset.toString()}");
    print("targetWidgetOffset:${targetWidgetSize.toString()}");
    Navigator.push(context, SpinnerRoute(child: ShowDownMenu()));
  }
}
