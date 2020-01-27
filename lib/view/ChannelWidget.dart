import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gank_app/viewmodel/ChannelViewModel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChannelWidget extends StatelessWidget {
  ChannelModel _model;
  VoidCallback voidCallback;

  ChannelWidget(this._model, this.voidCallback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                _model.image,
                height: 50,
                width: 50,
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  _model.categoryName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        if (voidCallback != null) {
          voidCallback();
        }
      },
    );
  }
}
