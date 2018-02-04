import 'dart:async';
import 'dart:io';

import 'package:flutter_demo/type/comicDetail.dart';
import 'package:flutter_demo/type/comicRead.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB{
  static Database db;

  static Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path+ "demo.db";

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(ComicRead.createSQL);
          await db.execute(ComicStore.createSQL);
        });
  }
  static Future close() async => db.close();

}