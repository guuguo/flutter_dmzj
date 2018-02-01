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
  ComicContentPage(
      {Key key, @required this.comicRead, @required this.comicDetail})
      : assert(comicRead != null),
        super(key: key) {
    debugPrint(comicRead.toString());
  }

  final ComicRead comicRead;
  final Map comicDetail;

  static intentTo(BuildContext context, ComicRead comicRead, Map comicDetail) {
    Navigator.of(context).push(new CupertinoPageRoute<Null>(
      builder: (BuildContext context) =>
      new ComicContentPage(comicRead: comicRead, comicDetail: comicDetail,),
    ));
  }

  @override
  _ComicContentPageState createState() => new _ComicContentPageState();
}

class _ComicContentPageState extends State<ComicContentPage>
    with SingleTickerProviderStateMixin {
  var _comicContent = [];
  ScrollController _listController;
  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _listController = new ScrollController();
    loadData();
  }

  snack(String s) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(s)));
  }

  loadData() {
    Api.getComicContent(widget.comicRead.id, widget.comicRead.chapterID, (s) {
      snack(s);
    }).then((data) {

      setState(() {
        _comicContent.addAll(data['page_url']);
      });
      _listController.addListener((){
        debugPrint(_listController.position.toString());
      });
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
      key: scaffoldKey,
      body: _comicContent.isNotEmpty
          ? new Stack(
        children: <Widget>[
          new Positioned.fill(
            child: new ListView.builder(
              controller:_listController,
              itemCount: _comicContent.length,
              itemBuilder: (context, index) {
                widget.comicRead.page = index;
                ComicRead.insert(widget.comicRead);
//                debugPrint(index.toString());
                if (index == _comicContent.length - 1) {
                  var _chapters = widget.comicDetail['chapters'];
                  for (var j = 0; j < _chapters.length; j++) {
                    var chapter = _chapters[j];
                    var isBreak = false;
                    for (var i = 0; i < chapter['data'].length; i++) {
                      if (chapter['data'][i]['chapter_id'] ==
                          widget.comicRead.chapterID) {
                        if (i - 1 < 0) {
                          snack("已经是最后一章了");
                        } else {
                          widget.comicRead.chapterID =
                          chapter['data'][i - 1]['chapter_id'];
                          widget.comicRead.chapterTitle =
                          chapter['data'][i - 1]['chapter_title'];
                          widget.comicRead.page = 0;
                          loadData();
                        }
                        isBreak = true;
                        break;
                      }
                    }
                    if (isBreak)
                      break;
                  }
                }
                return getImageView(_comicContent[index]);
              },
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
