import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/chapterGridDelegate.dart';
import 'package:flutter_demo/comicContent.dart';
import 'package:meta/meta.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage({Key key, @required this.comic})
      : assert(comic != null),
        super(key: key);

  final Map comic;

  @override
  _ComicDetaiPageState createState() => new _ComicDetaiPageState();
}

const double _kMinFlingVelocity = 800.0;

class _ComicDetaiPageState extends State<ComicDetailPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  Map _detailData;

  @override
  void initState() {
    super.initState();
    _detailData = widget.comic;
    Api.getComicDetail(widget.comic["id"], (s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((list) {
      new Timer(new Duration(milliseconds: 50), () {
        setState(() {
          _detailData = list;
        });
      });
    });
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(widget.comic['id'].toString()),
          elevation: 0.0,
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border(
                    top: new BorderSide(width: 0.5, color: Colors.black12))),
            height: 50.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  width: 100.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0),
                  child: new MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      if (_detailData.containsKey('last_updatetime')) {
                        Navigator.of(context).push(new CupertinoPageRoute<Null>(
                          builder: (BuildContext context) =>
                          new ComicContentPage(
                            comicID: _detailData['id'],
                            chapterID: _detailData['chapters'][0]
                            ['data'][0]['chapter_id'],
                          ),
                        ));
                      } else {}
                    },
                    child: new Text(
                      "阅读",
                      style: Theme
                          .of(context)
                          .primaryTextTheme
                          .button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Positioned(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 50.0,
          child: new CustomScrollView(slivers: buildSlivers(context)),
        ),
      ],
    );
  }

  buildSlivers(BuildContext context) {
    var sliver = <Widget>[
      new SliverToBoxAdapter(
        child: new Container(
          height: 180.0,
          child: new Stack(
            children: <Widget>[
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: new Container(
                  color: Colors.red,
                  height: 35.0,
                ),
              ),
              new Positioned(
                  top: 0.0,
                  left: 14.0,
                  right: 0.0,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Card(
                        elevation: 4.0,
                        child: new Hero(
                          tag: widget.comic["title"],
                          child: new GestureDetector(
                            onScaleStart: _handleOnScaleStart,
                            onScaleUpdate: _handleOnScaleUpdate,
                            onScaleEnd: _handleOnScaleEnd,
                            child: new ClipRect(
                              child: new Transform(
                                transform: new Matrix4.identity()
                                  ..translate(_offset.dx, _offset.dy)
                                  ..scale(_scale),
                                child: new Image.network(
                                  widget.comic['cover'],
                                  width: 110.0,
                                  height: 150.0,
                                  headers: imageHeader,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 6.0),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 20.0),
                            ),
                            new Text(
                              widget.comic["title"],
                              maxLines: 2,
                              softWrap: true,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title,
                            ),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 3.0),
                            ),
                            new Text(
                              widget.comic['authors'],
                              style: new TextStyle(
                                  color: Colors.red, fontSize: 16.0),
                            ),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 3.0),
                            ),
                            new Text("战斗力: ${widget.comic['hot_hits']}"),
                          ],
                        ),
                      ),
                    ],
                  )),
              new Positioned(
                  right: 16.0,
                  top: 16.0,
                  child: new Text(
                    "${formatDate(_detailData['last_updatetime'])}更新",
                    style: Theme
                        .of(context)
                        .primaryTextTheme
                        .caption,
                  )),
            ],
          ),
        ),
      ),
      new SliverToBoxAdapter(
        child: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 14.0),
          child: new Text(_detailData['description'] ?? ''),
        ),
      ),
    ];
    sliver.addAll(buildChaptersOrProgress(context));
    return sliver;
  }

  buildChaptersOrProgress(BuildContext context) {
    if (_detailData.containsKey("chapters")) {
      return buildChapters();
    } else {
      return [
        new SliverToBoxAdapter(
          child: new CupertinoActivityIndicator(),
        ),
      ];
    }
  }

  List<Widget> buildChapters({bool concise = true}) {
    List<Widget> widgetList = [];
    var chapterDetailList = (_detailData['chapters'] as List<Map>);

    widgetList.add(
      new SliverPadding(
        padding: new EdgeInsets.fromLTRB(10.0,0.0,10.0,10.0),
        sliver: new SliverGrid(
            gridDelegate: new ChapterGridDelegate(
              chapters: chapterDetailList, concise: concise,),
            delegate: new SliverChildListDelegate(
              _buildAllChapterItems(
                  _detailData, chapterDetailList, concise, context),)
        ),
      ),
    );
    return widgetList;
  }

  String formatDate(int long) {
    if (long == null) return '';
    var now = new DateTime.fromMillisecondsSinceEpoch(long * 1000);
    return '${now.year}/${now.month}/${now.day}';
  }
}

_buildAllChapterItems(Map detailData, List<Map> chapterDetailList, bool concise,
    BuildContext context) {
  List<Widget> widgetList = [];
  var i = 0;
  chapterDetailList.forEach((chapter) {
    var displayNum = i == 0 ? 8 : 4;
    var chapterList = (chapter['data'] as List);
    displayNum =
    displayNum > chapterList.length ? chapterList.length : displayNum;
    widgetList.add(buildChapterTitle(chapter, context));
    widgetList.addAll(_buildChapterItems(
        detailData, chapterList, displayNum, concise, context));
    i++;
  });
  return widgetList;
}

List<Widget> _buildChapterItems(Map detailData, List chapterList, displayNum,
    bool concise, BuildContext context) {
  var _chapterList = chapterList;
  if (concise) {
    _chapterList = _chapterList.sublist(
        0,
        chapterList.length <= displayNum
            ? chapterList.length
            : displayNum - 1);
  }
  List<Widget> list = _chapterList.map((data) {
    return buildChapterItem(detailData, data, context);
  }).toList();
  if (list.length < displayNum) {
    list.add(buildChapterItem(
        detailData, {"chapter_title": "····", "chapter_id": 0}, context));
  }
  return list;
}

buildChapterTitle(Map chapter, BuildContext context) {
  return new Container(height: 40.0, child: new Center(
    child: new Text(
      "····  ${chapter['title']}  ····",
      style: Theme
          .of(context)
          .textTheme
          .caption,
    ),
  ),);
}

buildChapterItem(Map detailData, Map data, BuildContext context) {
  return new GestureDetector(
    onTap: () {
      if (data['chapter_id'] == 0) {
        Navigator.of(context).push(new CupertinoPageRoute<Null>(
          builder: (BuildContext context) => new ChaptersPage(detailData),
        ));
      } else {
        Navigator.of(context).push(new CupertinoPageRoute<Null>(
          builder: (BuildContext context) =>
          new ComicContentPage(
            comicID: detailData['id'],
            chapterID: data['chapter_id'],
          ),
        ));
      }
    },
    child: new Container(
      height: 40.0,
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.red),
      ),
      child: new Center(
        child: new Text(
          data['chapter_title'],
          maxLines: 2,
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.red),
        ),
      ),
    ),
  );
}


class ChaptersPage extends StatelessWidget {
  ChaptersPage(@required this.detailData) :super();
  Map detailData;

  @override Widget build(BuildContext context) {
    var chapterDetailList = (detailData['chapters'] as List<Map>);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(detailData['title']),
      ),
      body: new GridView(
        addRepaintBoundaries: false,
        padding: new EdgeInsets.all(10.0),
        children: _buildAllChapterItems(
            detailData, chapterDetailList, false, context),
        gridDelegate: new ChapterGridDelegate(
          chapters: chapterDetailList, concise: false,),),
    );
  }

}

