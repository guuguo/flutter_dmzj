import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/page/comicDetail.dart';
import 'package:flutter_demo/type/comicDetail.dart';

class ComicItem extends StatelessWidget {
  ComicItem(Map e, {key: Key}) {
    if (!e.containsKey('id')) {
      e['id'] = e['obj_id'];
      e['authors'] = e['sub_title'];
    }
    if (!e.containsKey('tag')) {
      var rng = new Random();
      e['tag'] = e['id'].toString() + rng.nextInt(100).toString();
    }
    this.comic = new ComicStore.fromMap(e);
    this.comic.tag = e['tag'];
  }

  ComicItem.Entry(this.comic, {key: Key}) {
    if (comic.tag.isEmpty) {
      var rng = new Random();
      this.comic.tag = comic.id.toString() + rng.nextInt(100).toString();
    }
  }

  ComicStore comic;

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
              tag: comic.tag,
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
            style: Theme.of(context).textTheme.body2,
          )
        ],
      ),
    );
    return item;
  }
}
