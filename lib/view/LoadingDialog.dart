import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  double width;
  double height;
  BuildContext _context;

  void dismiss() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // TODO: implement build
    return WillPopScope(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xaa0a0a0a)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _RotationWidget(Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }

  LoadingDialog({this.width = 120.0, this.height = 120.0})
      : super(backgroundColor: Colors.transparent);
}

class _RotationWidget extends StatefulWidget {
  Widget child;
  Duration duration;

  _RotationWidget(this.child,
      {this.duration = const Duration(milliseconds: 500)});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RotationState();
  }
}

class _RotationState extends State<_RotationWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}
