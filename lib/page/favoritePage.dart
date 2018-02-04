import 'package:flutter/material.dart';
import 'package:flutter_demo/page/mainpage/recommend.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);
  final String title = "推荐";

  @override
  _FavoritePageState createState() => new _FavoritePageState();
}

class _FavoritePageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(widget.title),
      ),
    );
  }
}