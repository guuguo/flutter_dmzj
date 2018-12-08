import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage({Key key}) : super(key: key);
  final String title = "推荐";

  @override
  _EmptyPageState createState() => new _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NimaActor(
        "assets/Robot.nma",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Flight",
      ),
    );
  }
}
