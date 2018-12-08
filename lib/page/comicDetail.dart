import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dmzj_demo/api.dart';
import 'package:dmzj_demo/chapterGridDelegate.dart';
import 'package:dmzj_demo/page/comicContent.dart';
import 'package:dmzj_demo/type/comicRead.dart';
import 'package:dmzj_demo/type/comicDetail.dart';
import 'package:meta/meta.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage({Key key, @required this.comic})
      : assert(comic != null),
        super(key: key);

  final ComicStore comic;

  @override
  _ComicDetaiPageState createState() => new _ComicDetaiPageState();

  static intentTo(BuildContext context, ComicStore comic) {
    Navigator.of(context).push(new CupertinoPageRoute<Null>(
      builder: (BuildContext context) => new ComicDetailPage(comic: comic),
    ));
  }
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

  ComicDetail _comicDetail = new ComicDetail.noThing();
  ComicRead _comicRead;
  ComicStore _comicStore;

  bool _isLoad = true;

  @override
  void initState() {
    super.initState();
    widget.comic.getMyComicInfo().then((comic) => setState(() {
          _comicStore = comic;
        }));
    Api.getComicDetail(widget.comic.id, (s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((map) {
      var data = new ComicDetail(map);
      var bean = data.chapters[0].data.last;
        _comicStore = new ComicStore.fromComicDetail(data);
        _comicStore.saveInfo();
      ComicRead.getComicRead(data.id).then((res) {
        setState(() {
          _comicRead = res ??
              new ComicRead(data.id, bean.chapter_id, bean.chapter_title, 0);
          _comicDetail = data;
          _isLoad = false;
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
          title: new Text(widget.comic.id.toString()),
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
            //功能栏
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border(
                    top: new BorderSide(width: 0.5, color: Colors.black12))),
            height: 50.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new GestureDetector(
                  child: new Row(
                    children: <Widget>[
                      const Padding(padding: const EdgeInsets.only(left: 20.0)),
                      new Icon(
                        _isLoad || _comicStore.isFavorite == 0
                            ? Icons.favorite_border
                            : Icons.favorite,
                        color: _isLoad || _comicStore.isFavorite == 0
                            ? Colors.black87
                            : Colors.red,
                        size: 20.0,
                      ),
                      const Padding(padding: const EdgeInsets.only(left: 3.0)),
                      new Text(
                        "收藏",
                        style: new TextStyle(
                            color: _isLoad || _comicStore.isFavorite == 0
                                ? Colors.black87
                                : Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _comicStore.changeFavorite();
                    });
                  },
                ),
                new Container(
                  //阅读按钮
                  width: 100.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0),
                  child: new MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      if (!_isLoad) {
                        ComicContentPage.intentTo(
                            context, _comicRead, _comicDetail);
                      } else {}
                    },
                    child: new Text(
                      "阅读(${_comicRead == null ? '' : _comicRead.chapterTitle})",
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Positioned(
          //scrollView
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
                          tag: widget.comic.tag,
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
                                  _isLoad
                                      ? widget.comic.cover
                                      : _comicDetail.cover,
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
                              _comicDetail.title ?? '',
                              maxLines: 2,
                              softWrap: true,
                              style: Theme.of(context).textTheme.title,
                            ),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 3.0),
                            ),
                            new Text(
                              _isLoad
                                  ? widget.comic.authors
                                  : _comicDetail.authors
                                          .map((it) => it.tag_name)
                                          .join('/')
                                          .toString() ??
                                      "",
                              style: new TextStyle(
                                  color: Colors.red, fontSize: 16.0),
                            ),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 3.0),
                            ),
                            new Text("战斗力: ${_comicDetail.hot_num ?? ''}"),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 3.0),
                            ),
                            new Text(
                              _isLoad
                                  ? ''
                                  : _comicDetail.types
                                      .map((tag) => tag.tag_name)
                                      .join(' '),
                              style: new TextStyle(
                                  color: Colors.blue, fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              new Positioned(
                  right: 16.0,
                  top: 16.0,
                  child: new Text(
                    "${formatDate(_comicDetail.last_updatetime)}更新",
                    style: Theme.of(context).primaryTextTheme.caption,
                  )),
            ],
          ),
        ),
      ),
      new SliverToBoxAdapter(
        child: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 14.0),
          child: new Text(_comicDetail.description ?? ''),
        ),
      ),
    ];
    sliver.addAll(buildChaptersOrProgress(context));
    return sliver;
  }

  buildChaptersOrProgress(BuildContext context) {
    if (!_isLoad) {
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
    var chapterDetailList = _comicDetail.chapters;

    widgetList.add(
      new SliverPadding(
        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        sliver: new SliverGrid(
            gridDelegate: new ChapterGridDelegate(
              chapters: chapterDetailList,
              concise: concise,
            ),
            delegate: new SliverChildListDelegate(
              _buildAllChapterItems(_comicRead, _comicDetail, concise, context),
            )),
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

_buildAllChapterItems(ComicRead comicRead, ComicDetail detailData, bool concise,
    BuildContext context) {
  var chapterDetailList = detailData.chapters;
  List<Widget> widgetList = [];
  var i = 0;
  chapterDetailList.forEach((chapter) {
    var displayNum = i == 0 ? 8 : 4;
    var chapterList = chapter.data;
    displayNum =
        displayNum > chapterList.length ? chapterList.length : displayNum;
    widgetList.add(buildChapterTitle(chapter, context));
    widgetList.addAll(_buildChapterItems(
        comicRead, detailData, chapterList, displayNum, concise, context));
    i++;
  });
  return widgetList;
}

List<Widget> _buildChapterItems(
    ComicRead comicRead,
    ComicDetail comicDetail,
    List<ChapterBean> chapterList,
    displayNum,
    bool concise,
    BuildContext context) {
  var _chapterList = chapterList;
  if (concise) {
    _chapterList = _chapterList.sublist(0,
        chapterList.length <= displayNum ? chapterList.length : displayNum - 1);
  }
  if (_chapterList.length < displayNum) {
    _chapterList
        .add(new ChapterBean({"chapter_title": "····", "chapter_id": 0}));
  }
  List<Widget> list = _chapterList.map((data) {
    var isRead = data.chapter_id == comicRead.chapterID;
    return new GestureDetector(
      onTap: () {
        if (data.chapter_id == 0) {
          Navigator.of(context).push(new CupertinoPageRoute<Null>(
            builder: (BuildContext context) =>
                new ChaptersPage(comicRead, comicDetail),
          ));
        } else {
          comicRead.chapterID = data.chapter_id;
          comicRead.chapterTitle = data.chapter_title;
//          debugPrint(data.toString());
          ComicContentPage.intentTo(context, comicRead, comicDetail);
        }
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.red),
            color: isRead ? Colors.red : Colors.white),
        child: new Center(
          child: new Text(
            data.chapter_title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: new TextStyle(color: isRead ? Colors.white : Colors.red),
          ),
        ),
      ),
    );
  }).toList();
  return list;
}

buildChapterTitle(ChapterSectionBean chapter, BuildContext context) {
  return new Container(
    height: 40.0,
    child: new Center(
      child: new Text(
        "····  ${chapter.title}  ····",
        style: Theme.of(context).textTheme.caption,
      ),
    ),
  );
}

class ChaptersPage extends StatelessWidget {
  const ChaptersPage(@required this.comicRead, @required this.detailData)
      : super();
  final ComicDetail detailData;
  final ComicRead comicRead;

  @override
  Widget build(BuildContext context) {
    var chapterDetailList = detailData.chapters;
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(detailData.title),
      ),
      body: new GridView(
        addRepaintBoundaries: false,
        padding: new EdgeInsets.all(10.0),
        children: _buildAllChapterItems(comicRead, detailData, false, context),
        gridDelegate: new ChapterGridDelegate(
          chapters: chapterDetailList,
          concise: false,
        ),
      ),
    );
  }
}
