import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Config/ThemeConfig.dart';


void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gank App Demo',
      initialRoute: "/",
//           theme: ThemeData(
//             appBarTheme: AppBarTheme(color: model.themeModel.appBarTheme),
// //            primarySwatch: model.themeModel.primarySwatch,
//             primaryColor: model.themeModel.primaryColor,
//           ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: Text("Hello World"),
      ),
    );
  }
}
