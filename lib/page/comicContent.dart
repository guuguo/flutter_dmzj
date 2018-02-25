import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/type/comicRead.dart';
import 'package:flutter_demo/type/comicDetail.dart';
import 'package:flutter_demo/widgets/PlutoImage.dart';
import 'package:meta/meta.dart';

class ComicContentPage extends StatefulWidget {
  ComicContentPage(
      {Key key, @required this.comicRead, @required this.comicDetail})
      : assert(comicRead != null),
        super(key: key) {
    ComicStore.read(comicDetail.id);
  }

  final ComicRead comicRead;
  final ComicDetail comicDetail;

  static intentTo(BuildContext context, ComicRead comicRead,
      ComicDetail comicDetail) {
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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScrollableState> _listKey = new GlobalKey<ScrollableState>();
  final GlobalKey<_TopBarState> _topBarKey = new GlobalKey<_TopBarState>();
  var _isShowFunction = false;

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
      if (widget.comicRead.page != 0) {
        setState(() {
          print(widget.comicRead.page.toString());
          _comicContent..addAll(data['page_url']);
        });
      } else {
        setState(() {
          _comicContent.addAll(data['page_url']);
        });
      }
    });
    _listController.addListener(() {
      if (_isShowFunction)
        _topBarKey.currentState.setPage(widget.comicRead.page);
//      _listKey.currentState.;
    });
  }

  @override
  dispose() {
    super.dispose();
    _listController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = new Scaffold(body: _comicContent.isNotEmpty
        ? new Stack(
      children: <Widget>[
        new Positioned.fill(
          child: new GestureDetector(
            onTap: () {
              setState(() {
                _isShowFunction = !_isShowFunction;
              });
            }
            , child: new ListView.builder(
            key: _listKey,
            controller: _listController,
            itemCount: _comicContent.length,
            itemBuilder: (context, index) {
              print(index.toString());
              widget.comicRead.page = index;
              ComicRead.insert(widget.comicRead);
              if (index == _comicContent.length - 1) {
                var _chapters = widget.comicDetail.chapters;
                for (var j = 0; j < _chapters.length; j++) {
                  var chapter = _chapters[j];
                  var isBreak = false;
                  for (var i = 0; i < chapter.data.length; i++) {
                    if (chapter.data[i].chapter_id ==
                        widget.comicRead.chapterID) {
                      if (i - 1 < 0) {
                        snack("已经是最后一章了");
                      } else {
                        widget.comicRead.chapterID =
                            chapter.data[i - 1].chapter_id;
                        widget.comicRead.chapterTitle =
                            chapter.data[i - 1].chapter_title;
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
          ),),
        ),
      ]
        ..addAll(_isShowFunction ? [
          new _TopBarWidget(key: _topBarKey,page:widget.comicRead.page,
            pages: _comicContent.length, title: widget.comicRead.chapterTitle,),
          new Positioned(
            child: new Row(children: <Widget>[new Text("")],),
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            height: 80.0,)
        ] : []),
    )
        : new Center(child: new CupertinoActivityIndicator()),);
    return w;
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

class _TopBarWidget extends StatefulWidget {
  const _TopBarWidget({Key key, this.page,this.title, this.pages}) :super(key: key);

  final String title;
  final int pages;
  final int page;

  @override
  _TopBarState createState() => new _TopBarState(page);

}

class _TopBarState extends State<_TopBarWidget> {

  int _page = 0;
  _TopBarState(this._page):super();

  setPage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      child: new AppBar(title: new Text(
          widget.title + " ${_page.toString()}/${widget.pages}")),
      left: 0.0,
      top: 0.0,
      right: 0.0,
      height: 80.0,);
  }


}