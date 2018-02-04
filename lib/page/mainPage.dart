import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/mainpage/recommend.dart';
import 'package:flutter_demo/page/searchPage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  Map<String, Widget> _allPages = {
    "推荐": new RecommendPage(),
    "最近": new EmptyPage(),
    "排行": new EmptyPage(),
    "分类": new EmptyPage(),
    "专题": new EmptyPage(),
  };
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _allPages.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _allPages.length,
      child: new Scaffold(
        appBar: new AppBar(
            iconTheme: Theme.of(context).primaryIconTheme,
            brightness: Brightness.dark,
            title: new TabBar(
                controller: _tabController,
                tabs: _allPages.keys.map((String str) {
                return new Tab(text: str);
              }).toList(),
            ),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute<Null>(
                            builder: (BuildContext context) => new SearchPage(),
                          ),
                        );
                  }),
            ]),
        body: new TabBarView(
          controller: _tabController,
          children: _allPages.keys.map((title) {
            return _allPages[title];
          }).toList(),
        ),
      ),
    );
  }
}
