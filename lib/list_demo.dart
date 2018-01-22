// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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

  List<Comic> items = <Comic>[];

  String searchStr = "";

  final GlobalKey<FormFieldState<String>> _searchFieldKey =
      new GlobalKey<FormFieldState<String>>();

  _searchComic(String value) async {
    var url =
        'http://v2.api.dmzj.com/search/show/0/%E4%B8%80%E6%8B%B3%E8%B6%85%E4%BA%BA/0.json?channel=Android&version=2.7.003';
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        List<Comic> data = JSON.decode(json);
        setState(() {
          items = data;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('搜索失败:\nHttp status ${response.statusCode}')));
      }
    } catch (exception) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text('搜索失败')));
    }

    if (!mounted) return;
  }

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
                  _searchComic(value);
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
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(4.0),
            childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
            children: items.map((Comic comic) {
              return new GridComicItem(
                  comic: comic,
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

  final Comic comic;
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
    final Widget image = new GestureDetector(
        onTap: () {
          showPhoto(context);
        },
        child: new Hero(
            key: new Key(comic.id.toString()),
            tag: comic.title,
            child: new Image.network(
              comic.cover,
              fit: BoxFit.cover,
            )));

    return new GridTile(
      footer: new GridTileBar(
        backgroundColor: Colors.black45,
        title: new Text(comic.title),
        subtitle: new Text(comic.authors),
      ),
      child: image,
    );
  }
}
