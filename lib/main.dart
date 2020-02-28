import 'package:flutter/material.dart';

import 'Config/ThemeConfig.dart';
import 'page/HomePage.dart';

import 'package:provider/provider.dart';

import 'viewmodel/ThemeViewModel.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(ThemeConfig.themeModels[5]),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (_, model, widget) {
        return MaterialApp(
          title: 'Gank App Demo',
          initialRoute: "/",
          theme: ThemeData(
            appBarTheme: AppBarTheme(color: model.themeModel.appBarTheme),
//            primarySwatch: model.themeModel.primarySwatch,
            primaryColor: model.themeModel.primaryColor,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
