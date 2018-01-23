import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/searchPage.dart';
import 'package:flutter_demo/mainpage/recommend.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '动漫之家',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
//      routes: _kRoutes,
      home: new MyHomePage(title: '动漫之家'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String, Widget> _allPages = {
    "推荐": new RecommendPage(),
    "最近": new EmptyPage(),
    "排行": new EmptyPage(),
    "分类": new EmptyPage(),
    "专题": new EmptyPage(),
  };

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _allPages.length,
      child: new Scaffold(
        appBar: new AppBar(
            iconTheme: Theme.of(context).primaryIconTheme,
            brightness: Brightness.dark,
            title: new TabBar(
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
                          new CupertinoPageRoute<bool>(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => new ListDemo(),
                          ),
                        );
//                  Navigator.of(context).push(new PageRouteBuilder(
//                      opaque: false,
//                      pageBuilder: (BuildContext context, _, __) {
//                        return new ListDemo();
//                      },
//                      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//                        return new FadeTransition(
//                          opacity: animation,
//                          child: new RotationTransition(
//                            turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//                            child: child,
//                          ),
//                        );
//                      }
//                  ));

//                  Navigator.pushNamed(context, ListDemo.routeName);
                  }),
            ]),
        body: new TabBarView(
          children: _allPages.keys.map((title) {
            return _allPages[title];
          }).toList(),
        ),
      ),
    );
  }
}
