import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';

class RecommendPage extends StatefulWidget {
  RecommendPage({Key key}) : super(key: key);

  @override
  _RecommendPageState createState() => new _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  List _items = [];
  var _bannerString = "";

  _RecommendPageState() : super() {
    Api.getRecommend((s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((list) {
      setState(() {
        _items = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new SizedBox(
            height: 184.0,
            child: new Column(
              children: <Widget>[
                 new Expanded(
                    child: new TabBarView(
                        children: _items.length > 0
                            ? _items[0]['data'].map((item) {
                                return new Container(
                                  key: new ObjectKey(item['obj_id']),
                                  child: new Image.network(
                                    item['cover'],
                                    headers: imageHeader,
                                  ),
                                );
                              }).toList()
                            : []),
                  ),
                new Container(
                  color:const Color(0x33000000),
                  child: new Row(children: <Widget>[
                    new Text(_bannerString),
                    new TabPageSelector(controller: controller),
                  ]),
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
      body: new Text(widget.title),
    );
  }
}
