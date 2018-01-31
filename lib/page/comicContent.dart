import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/type/ComicRead.dart';
import 'package:flutter_demo/type/comicDetail.dart';
import 'package:flutter_demo/widgets/PlutoImage.dart';
import 'package:meta/meta.dart';

class ComicContentPage extends StatefulWidget {
   ComicContentPage({Key key, @required this.comicRead})
      : assert(comicRead != null),
        super(key: key){
    debugPrint(comicRead.toString());
  }

  final ComicRead comicRead;

  static intentTo(BuildContext context, ComicRead comicRead) {
    Navigator.of(context).push(new CupertinoPageRoute<Null>(
      builder: (BuildContext context) =>
      new ComicContentPage(comicRead: comicRead),
    ));
  }

  @override
  _ComicContentPageState createState() => new _ComicContentPageState();
}

class _ComicContentPageState extends State<ComicContentPage>
    with SingleTickerProviderStateMixin {
  var _comicContent = null;
  ScrollController _listController;

  @override
  void initState() {
    super.initState();
    _listController = new ScrollController();

    Api.getComicContent(widget.comicRead.id, widget.comicRead.chapterID, (s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((data) {
      setState(() {
        _comicContent = data;
      });
      new Timer(new Duration(milliseconds: 1), (){
//        _listController.position.jumpTo(200.0);
      });
//        ComicRead.insert(widget.comicRead);
    });
  }

  @override
  dispose() {
    super.dispose();
    _listController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _comicContent != null
          ? new Stack(
        children: <Widget>[
          new Positioned.fill(
            child: new ListView.builder(
              itemBuilder:(context,index){
                widget.comicRead.page=index;
                ComicRead.insert(widget.comicRead);
                debugPrint(index.toString());
                return  getImageView(_comicContent['page_url'][index]);
              },
              controller: _listController,
            ),
          ),
        ],
      )
          : new Center(child: new CupertinoActivityIndicator()),
    );
  }

  getImageView(String src) {
    return new Container(
      decoration:
      new BoxDecoration(border: new Border(bottom: new BorderSide())),
      child: new PlutoImage.networkWithPlaceholder(
        src,
        new Image.asset(
          'img/loading.png',
          height: 400.0,
          scale: 0.2,
          fit: BoxFit.none,
          color: Colors.black38,
        ),
        fit: BoxFit.cover,
        headers: imageHeader,
      ),
    );
  }
}
