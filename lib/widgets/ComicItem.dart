import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/page/comicDetail.dart';
import 'package:flutter_demo/type/comicDetail.dart';

class ComicItem extends StatelessWidget{
  const ComicItem(this.comic,{key:Key});
  final Map comic;
  @override
  Widget build(BuildContext context) {
    final Widget item = new GestureDetector(
      onTap: () {
        ComicDetailPage.intentTo(context, new ComicStore.fromMap(comic));
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
            style: Theme
                .of(context)
                .textTheme
                .body2,
          )
        ],
      ),
    );
    return item;
  }
}
class ComicMyItem extends StatelessWidget{
  const ComicMyItem(this.comic,{key:Key});
  final ComicStore comic;
  @override
  Widget build(BuildContext context) {
    final Widget item = new GestureDetector(
      onTap: () {
        ComicDetailPage.intentTo(context, comic);
      },
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          new Card(
            elevation: 4.0,
            child: new Hero(
              key: new Key(comic.id.toString()),
              tag: comic.title,
              child: new Image.network(
                comic.cover,
                width: 100.0,
                height: 150.0,
                fit: BoxFit.cover,
                headers: imageHeader,
              ),
            ),
          ),
          new Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          new Text(
            comic.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme
                .of(context)
                .textTheme
                .body2,
          )
        ],
      ),
    );
    return item;
  }
}