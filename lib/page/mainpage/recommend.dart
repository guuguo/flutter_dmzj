import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dmzj_demo/api.dart';
import 'package:dmzj_demo/page/comicDetail.dart';
import 'package:dmzj_demo/type/comicDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendPage extends StatefulWidget {
  RecommendPage({Key key}) : super(key: key);

  @override
  _RecommendPageState createState() => new _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with SingleTickerProviderStateMixin {
  _RecommendPageState() : super();
  List _items = [];
  var _bannerString = "";
  TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    if (_tabController != null) _tabController.dispose();
    super.dispose();
  }

  Future<String> _handleRefresh() {
    return Api.getRecommend((s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    })
      ..then((json) {
        setState(() {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString("RECOMMEND_JSON", json);
          });
          _items = jsonDecode(json);
          _tabController =
              new TabController(length: _items[0]['data'].length, vsync: this);
          return null;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    SharedPreferences.getInstance().then((prefs) {
      var json = prefs.getString("RECOMMEND_JSON");
      if (json != null)
        setState(() {
          _items = jsonDecode(json);
          print(json);
        });
      else {
        _handleRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        child: _items.length > 0
            ? new ListView(
                children: buildList(),
              )
            : new Center(
                child: new CupertinoActivityIndicator(),
              ),
        onRefresh: _handleRefresh);
  }

  List<Widget> buildList() {
    return [
      new SizedBox(
        height: 190.0,
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new TabBarView(
                  controller: _tabController,
                  children: (_items[0]['data'] as List).map((item) {
                    return new Container(
                      key: new ObjectKey(item['obj_id']),
                      child: new Image.network(
                        item['cover'],
                        fit: BoxFit.fitWidth,
                        headers: imageHeader,
                      ),
                    );
                  }).toList()),
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 10.0,
              child: new Container(
                color: const Color(0x33000000),
                child: new Row(children: <Widget>[
                  new Text(_bannerString),
                  new TabPageSelector(controller: _tabController),
                ]),
              ),
            ),
          ],
        ),
      ),
    ]
      ..addAll(_items.sublist(1).map((e) {
        return buildRecommendItem(e);
      }).toList())
      ..add(
        buildGrayLine,
      );
  }

  Container get buildGrayLine {
    return new Container(
      color: Colors.grey.shade200,
      padding: new EdgeInsets.only(top: 10.0),
    );
  }

  Widget buildRecommendItem(Map bean) {
    List<Widget> list = [];
    list.addAll([
      buildGrayLine,
      new Row(
        children: <Widget>[
          new Padding(
            child: new Icon(
              Icons.subscriptions,
              size: 18.0,
            ),
            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          ),
          new Expanded(
              child: new Text(
            bean['title'],
            style: Theme.of(context).textTheme.title,
          )),
          new Icon(Icons.chevron_right)
        ],
      )
    ]);
    var dataS = bean['data'] as List;
    if (dataS.length % 3 == 0) {
      for (var i = 0; i <= (dataS.length - 1) ~/ 3; i++) {
        list.add(new Row(
            mainAxisSize: MainAxisSize.min,
            children:
                _getItems(dataS.sublist(i * 3, i * 3 + 3), bean['sort'])));
      }
    } else if (dataS.length % 2 == 0) {
      for (var i = 0; i <= (dataS.length - 1) ~/ 2; i++) {
        list.add(new Row(
            mainAxisSize: MainAxisSize.min,
            children:
                _getItems(dataS.sublist(i * 2, i * 2 + 2), bean['sort'])));
      }
    }
    return new Column(children: list);
  }

  _getItems(List list, int sort) {
    double height = 110.0;
    switch (list.length) {
      case 3:
        height = 150.0;
    }

    return list.map((e) {
      if (!e.containsKey('id')) {
        e['id'] = e['obj_id'];
        e['authors'] = e['sub_title'];
      }
      if (!e.containsKey('tag')) {
        var rng = new Random();
        e['tag'] = e['id'].toString() + rng.nextInt(100).toString();
      }
      var comic = new ComicStore.fromMap(e);
      comic.tag = e['tag'];
      List<Widget> columnList = [
        new Container(
          height: height,
          child: new ClipRRect(
            borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            child: new GestureDetector(
              child: new Hero(
                  key: new Key(e["id"].toString()),
                  tag: comic.tag,
                  child: new Image.network(
                    e['cover'],
                    headers: imageHeader,
                  )),
              onTap: () {
                if (list.length != 2) {
                  ComicDetailPage.intentTo(context, comic);
                }
              },
            ),
          ),
        ),
        new Text(
          e['title'],
          maxLines: 1,
        ),
      ];
      if (list.length != 2)
        columnList.add(new Align(
          child: new Text(
            e.containsKey('authors') ? e['authors'] : e['sub_title'],
            style: Theme.of(context).textTheme.caption,
            maxLines: 1,
          ),
        ));
      columnList.add(new Padding(padding: new EdgeInsets.only(top: 5.0)));
      return new Expanded(
          flex: 1,
          child: new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Column(
              children: columnList,
            ),
          ));
    }).toList();
  }
}

class EmptyPage extends StatefulWidget {
  EmptyPage({Key key}) : super(key: key);
  final String title = "推荐";

  @override
  _EmptyPageState createState() => new _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(widget.title),
      ),
    );
  }
}
