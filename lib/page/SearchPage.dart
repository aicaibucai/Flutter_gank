import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank_app/viewmodel/HomeViewModel.dart';
import 'package:flutter_gank_app/viewmodel/SearchViewModel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchState();
  }
}

class SearchState extends State<SearchPage> {
  SearchViewModel _searchViewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    HomeModel homeModel = Provider.of<HomeModel>(context, listen: false);
    return ChangeNotifierProvider<SearchViewModel>.value(
      value: _searchViewModel,
      child: SafeArea(
          child: Scaffold(
        body: Row(
          children: <Widget>[
            Selector<SearchViewModel, int>(builder: (_, index, widget) {
              return DropdownButton(
                  value: index,
                  underline: Container(),
                  items: _searchViewModel.category.map<DropdownMenuItem>((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: _searchViewModel.category.indexOf(e),
                    );
                  }).toList(),
                  onChanged: (item) {
                    _searchViewModel.changeTag(item);
                  });
            }, selector: (scontext, model) {
              return model.categoryIndex;
            }),
            Expanded(
              child:
                  Selector<SearchViewModel, String>(builder: (_, str, widget) {
                return TextField(
                  textInputAction: TextInputAction.search,
                  controller: _searchViewModel.searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: str.isEmpty
                        ? Container(
                            height: 24,
                            width: 24,
                          )
                        : InkWell(
                            child: Icon(CupertinoIcons.clear_thick_circled),
                            onTap: () {
                              _searchViewModel.searchController.clear();
                            },
                          ),
                  ),
                );
              }, selector: (scontext, model) {
                return model.searchContent;
              }),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("取消"),
            )
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchViewModel = SearchViewModel()..init();
  }
}
