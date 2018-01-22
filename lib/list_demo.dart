// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
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
                borderRadius: new BorderRadius.circular(4.0),
              ),
              padding: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new TextField(
                autofocus: true,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.title,
                key: _searchFieldKey,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: '搜索',
                  hintStyle: Theme.of(context).textTheme.caption,
                  hideDivider: true,
                ),
                onChanged: (String value) {
                  searchStr = value;
                  Api.searchComic(value, page, (s) {
                    Scaffold
                        .of(context)
                        .showSnackBar(new SnackBar(content: new Text(s)));
                  }).then((list) {
                    setState(() {
                      items = list;
                    });
                  });
                },
              ),
            ),
          ),
          actions: <Widget>[
            new Container(
              width: 50.0,
              child: new MaterialButton(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: new Text(
                  '取消',
                  style: Theme.of(context).primaryTextTheme.subhead,
                  softWrap: false,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
              ),
            ),
          ],
        ),
        body: new Column(children: <Widget>[
          new Expanded(
              child: new GridView.count(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(4.0),
            shrinkWrap: true,
            childAspectRatio: (orientation == Orientation.portrait) ? 0.5 : 1.5,
            children: items.map((Map comicMap) {
              return new GridComicItem(
                  comic: comicMap,
                  onComicTap: (Comic comic) {
                    setState(() {
//                            photo.isFavorite = !photo.isFavorite;
                    });
                  });
            }).toList(),
          ))
        ]));
  }
}

typedef void ComicTapCallback(Comic comic);

class GridComicItem extends StatelessWidget {
  GridComicItem({
    Key key,
    @required this.comic,
    @required this.onComicTap,
  })
      : assert(comic != null),
        assert(onComicTap != null),
        super(key: key);

  final Map comic;
  final ComicTapCallback
      onComicTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
//    Navigator.push(context, new MaterialPageRoute<Null>(
//        builder: (BuildContext context) {
//          return new Scaffold(
//            appBar: new AppBar(
//                title: new Text(comic.title)
//            ),
//            body: new SizedBox.expand(
//              child: new Hero(
//                tag: comic.authors,
//                child: new GridPhotoViewer(photo: photo),
//              ),
//            ),
//          );
//        }
//    ));
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
            style: Theme.of(context).textTheme.body2,
          )
        ],
      ),
    );
    return item;
  }
}
