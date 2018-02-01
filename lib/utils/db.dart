import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB{
  static Database db;

  static Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path+ "demo.db";

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table comicRead (
  id integer primary key,
  chapterID integer not null,
  chapterTitle text not null,
  page integer not null)
''');
        });
  }
  static Future close() async => db.close();

}