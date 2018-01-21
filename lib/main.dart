import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/list_demo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Widget _applyScaleFactor(Widget child) {
//      return new Builder(
//        builder: (BuildContext context) => new MediaQuery(
//              data: MediaQuery.of(context).copyWith(),
//              child: child,
//            ),
//      );
//    }

//    final Map<String, WidgetBuilder> _kRoutes = <String, WidgetBuilder>{
//      ListDemo.routeName: (BuildContext context) =>
//          new ListDemo()
//    };

    return new MaterialApp(
      title: '动漫之家',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          iconTheme: Theme.of(context).primaryIconTheme,
          brightness: Brightness.dark,
          title: new Align(
              alignment: Alignment.centerLeft, child: new Text(widget.title)),
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
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '按键次数:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
