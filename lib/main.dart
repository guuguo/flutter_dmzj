import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/IndexPage.dart';
import 'package:flutter_demo/page/mainPage.dart';

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
      home: new IndexPage(title: '动漫之家'),
    );
  }
}

