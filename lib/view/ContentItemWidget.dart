import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank_app/net/entity/TodayEntity.dart';
import 'package:flutter_gank_app/page/GankContentPage.dart';
import 'package:flutter_gank_app/utils/DateUtil.dart';
import 'package:flutter_gank_app/utils/ScreenUtil.dart';

class ContentItemWidget extends StatelessWidget {
  TodayEntity _entity;

  ContentItemWidget(TodayEntity entity) {
    _entity = entity;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(-1.0, 1.0), //阴影xy轴偏移量
                blurRadius: 1.0, //阴影模糊程度
                spreadRadius: 0.2 //阴影扩散程度
                ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        constraints: BoxConstraints.expand(
          height: ScreenUtil.instance.getScreenSize(context).height / 8,
          width: ScreenUtil.instance.getScreenSize(context).width,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _entity.desc,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            _entity.who,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          Text(
                            DateTime.parse(_entity.publishedAt).toSimpleDate(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: _entity.images != null
                  ? CachedNetworkImage(
                      width: 60,
                      height: 60,
                      imageUrl: _entity.images[0],
                      placeholder: (_, __) => Icon(Icons.terrain),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return GankContentPage(_entity.url);
        }));
      },
    );
  }
}
