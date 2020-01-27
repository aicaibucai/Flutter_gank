import 'package:flutter/material.dart';

import 'page/HomePage.dart';

import 'package:provider/provider.dart';

import 'viewmodel/ThemeViewModel.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(),
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
          title: 'Flutter Demo',
          initialRoute: "/",
          theme: ThemeData(
            appBarTheme: AppBarTheme(color: model.appBarTheme),
            primarySwatch: model.primarySwatch,
            primaryColor: model.primaryColor,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
