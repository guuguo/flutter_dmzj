// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum _MaterialListType {
  /// A list tile that contains a single line of text.
  oneLine,

  /// A list tile that contains a [CircleAvatar] followed by a single line of text.
  oneLineWithAvatar,

  /// A list tile that contains two lines of text.
  twoLine,

  /// A list tile that contains three lines of text.
  threeLine,
}

class ListDemo extends StatefulWidget {
  const ListDemo({Key key}) : super(key: key);

  static const String routeName = '/list';

  @override
  _ListDemoState createState() => new _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  PersistentBottomSheetController<Null> _bottomSheet;
  _MaterialListType _itemType = _MaterialListType.threeLine;
  bool _dense = false;
  bool _showAvatars = true;
  bool _showIcons = false;
  bool _showDividers = false;
  bool _reverseSort = false;
  List<String> items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
  ];

  void changeItemType(_MaterialListType type) {
    setState(() {
      _itemType = type;
    });
    _bottomSheet?.setState(() {});
  }

  String searchStr = "";

  final GlobalKey<FormFieldState<String>> _searchFieldKey =
      new GlobalKey<FormFieldState<String>>();

  Widget buildListTile(BuildContext context, String item) {
    Widget secondary;
    if (_itemType == _MaterialListType.twoLine) {
      secondary = const Text('Additional item information.');
    } else if (_itemType == _MaterialListType.threeLine) {
      secondary = const Text(
        'Even more additional list item information appears on line three.',
      );
    }
    return new MergeSemantics(
      child: new ListTile(
        isThreeLine: _itemType == _MaterialListType.threeLine,
        dense: _dense,
        leading: _showAvatars
            ? new ExcludeSemantics(
                child: new CircleAvatar(child: new Text(item)))
            : null,
        title: new Text('This item represents $item.'),
        subtitle: secondary,
        trailing: _showIcons
            ? new Icon(Icons.info, color: Theme.of(context).disabledColor)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String layoutText = _dense ? ' \u2013 Dense' : '';
    String itemTypeText;
    switch (_itemType) {
      case _MaterialListType.oneLine:
      case _MaterialListType.oneLineWithAvatar:
        itemTypeText = 'Single-line';
        break;
      case _MaterialListType.twoLine:
        itemTypeText = 'Two-line';
        break;
      case _MaterialListType.threeLine:
        itemTypeText = 'Three-line';
        break;
    }

    Iterable<Widget> listTiles =
        items.map((String item) => buildListTile(context, item));
    if (_showDividers)
      listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Center(
//          child: new Expanded(
//            child: new TextFormField(
//              key: _searchFieldKey,
//              decoration: const InputDecoration(
//                hintText: '搜索',
//              ),
//              obscureText: true,
//              onSaved: (String value) {
//                searchStr = value;
//              },
//            ),
//          ),
        ),
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: _dense ? 4.0 : 8.0),
          children: listTiles.toList(),
        ),
      ),
    );
  }
}
