import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';

class RecommendPage extends StatefulWidget {
  RecommendPage({Key key}) : super(key: key);

  @override
  _RecommendPageState createState() => new _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with SingleTickerProviderStateMixin {
  _RecommendPageState() : super() {}
  List _items = [];
  var _bannerString = "";
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Api.getRecommend((s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((list) {
      setState(() {
        _items = list;
        _tabController = new TabController(
            length: (_items[0]['data'] as List).length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new SizedBox(
            height: 190.0,
            child: new Stack(
              children: <Widget>[
                new Positioned.fill(
                  child: new TabBarView(
                      controller: _tabController,
                      children: _items.length > 0
                          ? _items[0]['data'].map((item) {
                              return new Container(
                                key: new ObjectKey(item['obj_id']),
                                child: new Image.network(
                                  item['cover'],
                                  fit: BoxFit.fitWidth,
                                  headers: imageHeader,
                                ),
                              );
                            }).toList()
                          : []),
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
        ],
      ),
    );
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
