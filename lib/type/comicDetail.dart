import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/sql_builder.dart';

class Comic {
  var cover = "";
  var sub_title = "";
  var type = 0;
  var url = "";
  var title = "";
  var status = "";
  var obj_id = 40552;

  @override
  String toString() => 'Comic($title)';

  Comic.fromMap(Map<String, dynamic> map)
      : obj_id = map['obj_id'],
        status = map['status'],
        title = map['title'],
        url = map['url'],
        cover = map['cover'],
        sub_title = map['sub_title'],
        type = map['type'];
}

class ComicDetail {
  var id = 0;
  var status = "";
  var title = "";
  var last_name = "";
  var cover = "";
  var authors = "";
  String types;

  int hot_hits;

  var description;
  int last_updatetime;
  int copyright = 0;
  String first_letter;
  int hot_num = 0;
  int hit_num = 0;

  @override
  String toString() => 'ComicDetail($title)';

  ComicDetail.fromComic(Comic comic)
      : id = comic.obj_id,
        status = comic.status,
        title = comic.title,
        cover = comic.cover;

  ComicDetail.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        title = map['title'],
        last_name = map['last_name'],
        cover = map['cover'],
        authors = map['authors'],
        types = map['types'],
        hot_hits = map['hot_hits'];

  ComicDetail.fromDetailMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        title = map['title'],
        cover = map['cover'],
        authors = (map['authors'] as List<String>).join('/'),
        types = (map['types'] as List<String>).join('/'),
        description = map['description'],
        last_updatetime = map['last_updatetime'],
        hot_num = map['hot_num'],
        hit_num = map['hit_num'];
}

class ComicRead {
  int id;
  int chapterID;
  String chapterTitle;
  int page;

  ComicRead(this.id, this.chapterID, this.chapterTitle, this.page);

  ComicRead.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        chapterID = map['chapterID'],
        chapterTitle = map['chapterTitle'],
        page = map['page'];
}

class ComicProvider {
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

 static Future insert(ComicRead comicRead) async {
    var batch = db.batch();
    batch.insert(
        "comicRead",
        {
          "id": comicRead.id,
          "chapterID": comicRead.chapterID,
          "chapterTitle": comicRead.chapterTitle,
          "page": comicRead.page
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

 static Future<ComicRead> getComicRead(int id) async {
    List<Map> maps =
        await db.query("comicRead", where: "id = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return new ComicRead.fromMap(maps.first);
    }
    return null;
  }


 static Future close() async => db.close();
}
