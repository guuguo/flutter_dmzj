// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/comicDetail.dart';
import 'package:flutter_demo/types.dart';
import 'package:meta/meta.dart';

class ListDemo extends StatefulWidget {
  const ListDemo({Key key}) : super(key: key);

  static const String routeName = '/list';

  @override
  _ListDemoState createState() => new _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  List items = [];
  var page = 0;
  String searchStr = "";

  final GlobalKey<FormFieldState<String>> _searchFieldKey =
      new GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10.0,
          title: new Center(
            child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
                padding: new EdgeInsets.symmetric(horizontal: 6.0),
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.search,
                      size: 22.0,
                      color: Colors.black26,
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 10.0)),
                    new Expanded(
                      child: new TextField(
                        autofocus: true,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.title,
                        key: _searchFieldKey,
                        decoration: new InputDecoration(
                          isDense: true,
                          hintText: '搜索',
                          hintStyle: new TextStyle(
                              color: Colors.black26, fontSize: 16.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) {
                          searchStr = value;
                          Api.searchComic(value, page, (s) {
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(content: new Text(s)));
                          }).then((list) {
                            setState(() {
                              items = list;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ),
        body: new Column(children: <Widget>[
          new Expanded(
            child: items.length > 0
                ? new GridView.count(
//                controller: ,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 3 : 4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    padding: const EdgeInsets.all(4.0),
                    shrinkWrap: true,
                    childAspectRatio:
                        (orientation == Orientation.portrait) ? 0.5 : 1.5,
                    children: items.map((Map comicMap) {
                      return new GridComicItem(
                        comic: comicMap,
                      );
                    }).toList(),
                  )
                : new Center(
                    child: new Text(
                    "请输入内容以搜索",
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .apply(fontSizeFactor: 1.5),
                  )),
          )
        ]));
  }
}

typedef void ComicTapCallback(Comic comic);

class GridComicItem extends StatelessWidget {
  GridComicItem({
    Key key,
    @required this.comic,
  })
      : assert(comic != null),
        super(key: key);

  final Map comic;

  void showPhoto(BuildContext context) {
    Navigator.of(context).push(new CupertinoPageRoute<Null>(
          builder: (BuildContext context) => new ComicDetailPage(comic: comic),
        ));
  }

  @override
  Widget build(BuildContext context) {
    print(comic);
    final Widget item = new GestureDetector(
      onTap: () {
        showPhoto(context);
      },
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          new Card(
            elevation: 4.0,
            child: new Hero(
              key: new Key(comic["id"].toString()),
              tag: comic["title"],
              child: new Image.network(
                comic["cover"],
                width: 100.0,
                height: 150.0,
                fit: BoxFit.cover,
                headers: imageHeader,
              ),
            ),
          ),
          new Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          new Text(
            comic["title"],
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme.of(context).textTheme.body2,
          )
        ],
      ),
    );
    return item;
  }
}
