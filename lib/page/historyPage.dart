import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/page/comicDetail.dart';
import 'package:flutter_demo/type/comicDetail.dart';
import 'package:flutter_demo/widgets/ComicItem.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  _HistoryPageState() : super();
  List<ComicStore> _items = [];

  @override
  void initState() {
    super.initState();
    ComicStore.getHistoryComics().then((d){
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
          title: new Text("历史"),
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
                  return new ComicMyItem(comicMap);
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

