// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/page/comicDetail.dart';
import 'package:flutter_demo/type/comicDetail.dart';
import 'package:flutter_demo/widgets/ComicItem.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  static const String routeName = '/list';

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textFieldController;
  GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;

  List _items = [];
  var page = 0;
  String _searchStr = "";
  var _isLoad = false;

  @override
  initState() {
    super.initState();
    _textFieldController =new TextEditingController();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels < 10 &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse && !_isLoad) {
        page++;
        loadData(_searchStr);
      }
    });
  }

  final GlobalKey<FormFieldState<String>> _searchFieldKey =
  new GlobalKey<FormFieldState<String>>();

  @override
  dispose() {
    super.dispose();
    _textFieldController.clear();
    _textFieldController.dispose();
    _scrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;

    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10.0,
          title: new Center(
            child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                padding: new EdgeInsets.symmetric(horizontal: 6.0),
                child: new Row(
                  children: <Widget>[
                    new GestureDetector(
                        child: new Padding(
                          padding: new EdgeInsets.only(right: 15.0),
                          child: new Icon(
                            Icons.arrow_back,
                            size: 22.0,
                            color: Colors.black26,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                    new Expanded(
                      child: new TextField(
                        controller: _textFieldController,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        style: Theme
                            .of(context)
                            .textTheme
                            .title,
                        key: _searchFieldKey,
                        decoration: new InputDecoration(
                          isDense: true,
                          hintText: '搜索',
                          hintStyle: new TextStyle(
                              color: Colors.black26, fontSize: 16.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _searchStr = value;
                          });
                          loadData(value);
                        },
                      ),
                    ),
                    _searchStr.isEmpty
                        ? new Text("")
                        : new GestureDetector(
                      child: new Padding(
                        child: new Icon(
                          Icons.close,
                          size: 18.0,
                          color: Colors.black26,
                        ),
                        padding: new EdgeInsets.all(6.0),
                      ),
                      onTap: () {
                        _textFieldController.clear();
                        setState(() {
                          _searchStr = "";
                          _items = [];
                        });
                      },
                    ),
                  ],
                )),
          ),
        ),
        body: _items.length > 0
            ? new CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            new SliverPadding(
              padding: new EdgeInsets.symmetric(horizontal: 6.0),
              sliver: new SliverGrid.count(
                crossAxisCount:
                (orientation == Orientation.portrait) ? 3 : 5,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio:
                (orientation == Orientation.portrait) ? 0.5 : 0.45,
                children: _items.map((comicMap) {
                  return new ComicItem(comicMap);
                }).toList(),
              ),
            ),
            new SliverToBoxAdapter(
              child: new Container(padding: new EdgeInsets.only(bottom: 4.0),
                child: new Text("加载更多", textAlign: TextAlign.center,),),),
          ],
        )
            : new Align(
          alignment: Alignment.topCenter,
          child: new Padding(
            child: new Text(
              "请输入内容以搜索",
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .caption
                  .apply(fontSizeFactor: 1.5),
            ),
            padding: new EdgeInsets.all(20.0),
          ),
        ));
  }

  void loadData(String value) {
    Api.searchComic(value, page, (s) {
      _isLoad = true;
      scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(s)));
    }).then((list) {
      setState(() {
        if (page == 0) {
          _items = list;
        }
        else {
          _items.addAll(list);
        }
        _isLoad = false;
      });
    });
  }

}
