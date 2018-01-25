import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api.dart';
import 'package:flutter_demo/api.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage({Key key, this.comic}) : super(key: key);

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

  Map _detailData = null;

  @override
  void initState() {
    super.initState();
    _detailData = widget.comic;
    Api.getComicDetail(widget.comic["id"], (s) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(s)));
    }).then((list) {
      setState(() {
        _detailData = list;
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

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
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
          title: new Text(widget.comic['title']),
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
                    onPressed: () => {},
                    child: new Text(
                      "阅读",
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Positioned.fill(
          child: new ListView(
            children: <Widget>[
              new Container(
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
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              padding:
                                  new EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  widget.comic["title"],
                                  style: Theme.of(context).textTheme.title,
                                ),
                                new Padding(
                                  padding:
                                      new EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                new Text(
                                  widget.comic['authors'],
                                  style: new TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                ),
                                new Padding(
                                  padding:
                                      new EdgeInsets.symmetric(vertical: 3.0),
                                ),
                                new Text("战斗力: ${widget.comic['hot_hits']}"),
                              ],
                            )
                          ],
                        )),
                    new Positioned(
                        right: 16.0,
                        top: 16.0,
                        child: new Text(
                          "${formatDate(_detailData['last_updatetime'])}更新",
                          style: Theme.of(context).primaryTextTheme.caption,
                        )),
                  ],
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 14.0),
                child: new Text(_detailData['description'] ?? ''),
              ),
              buildChapters(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildChapters(BuildContext context) {
    if (_detailData.containsKey("chapters"))
      return new Column(
          children: (_detailData['chapters'] as List<Map>).map((chapter) {
        return new Column(
          children: <Widget>[
            new Text(chapter['title']),
            new Flex(
              direction: Axis.horizontal,
              children: (chapter['data'] as List).map((data){

              }).toList(),
            )
          ],
        );
      }).toList());
    else
      return new CupertinoActivityIndicator();
  }
  Widget buildChapterItem(Map data) {
      return new Column(
          children: (_detailData['chapters'] as List<Map>).map((chapter) {
            return new Column(
              children: <Widget>[
                new Text(chapter['title']),
                new Flex(
                  direction: Axis.horizontal,
                  children: (chapter['data'] as List).map((data){

                  }).toList(),
                )
              ],
            );
          }).toList());
  }
  String formatDate(int long) {
    if (long == null) return '';
    var now = new DateTime.fromMillisecondsSinceEpoch(long * 1000);
    return '${now.year}/${now.month}/${now.day}';
  }
}
