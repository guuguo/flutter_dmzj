import 'dart:async';
import 'dart:io';

import 'package:dmzj_demo/type/comicDetail.dart';
import 'package:dmzj_demo/type/comicRead.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database db;

  static Future<String> initDb(String dbName) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    if (await Directory(dirname(path)).exists()) {
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  static Future open() async {
    String path = await initDb("demo.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(ComicRead.createSQL);
      await db.execute(ComicStore.createSQL);
    }, onUpgrade: (Database db, int version, int newVer) async {
      if (newVer == 2) await db.execute(ComicStore.createSQL);
    }, onDowngrade: (Database db, int version, int newVer) {
      deleteDatabase(path);
    });
  }

  static Future close() async => db.close();
}
