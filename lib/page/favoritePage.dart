import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dmzj_demo/api.dart';
import 'package:dmzj_demo/page/comicDetail.dart';
import 'package:dmzj_demo/type/comicDetail.dart';
import 'package:dmzj_demo/widgets/ComicItem.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => new _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  _FavoritePageState() : super();
  List<ComicStore> _items = [];

  @override
  void initState() {
    super.initState();
    ComicStore.getFavoriteComics().then((d){
      setState(() {
        _items=d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("收藏"),
        ),
        body: new CustomScrollView(
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
                  return new ComicItem.Entry(comicMap);
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

