import 'package:flutter/material.dart';
import 'package:flutter_gank_app/viewmodel/GankContentViewModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

class GankContentPage extends StatelessWidget {
  String _url;

  GankContentPage(this._url);

  bool isLoading = false;

  WebViewController _webViewController;
  GankContentViewModel gankContentViewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<GankContentViewModel>(
        create: (_) => GankContentViewModel(_url),
        child: Builder(builder: (build_context) {
          gankContentViewModel =
              Provider.of<GankContentViewModel>(build_context);
          return Scaffold(
            appBar: AppBar(
              title:
                  Consumer<GankContentViewModel>(builder: (_, model, widget) {
                return Text(model.title);
              }),
            ),
            body: Builder(builder: (c_context) {
              return WebView(
                initialUrl: _url,
                onWebViewCreated: (control) {
                  _webViewController = control;
                },
                onPageStarted: (result) {
                  isLoading = false;
                  loadingTitle();
                },
                onPageFinished: (result) {
                  isLoading = true;
                  getTitle();
                },
              );
            }),
          );
        }));
  }

  void getTitle() async {
    String title = await _webViewController.getTitle();
    gankContentViewModel.title = title;
  }

  void loadingTitle() {
    gankContentViewModel.title = "Loading...";
  }
}
