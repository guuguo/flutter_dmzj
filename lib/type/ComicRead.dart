import 'dart:async';
import 'package:flutter_demo/page/utils/db.dart';
import 'package:sqflite/src/sql_builder.dart';

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

  @override
  toString(){
    return "id:$id,chapterID:$chapterID,chapterTitle:$chapterTitle,page:$page";
  }
  static Future insert(ComicRead comicRead) async {
    var batch = DB.db.batch();
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
    await DB.db.query("comicRead", where: "id = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return new ComicRead.fromMap(maps.first);
    }
    return null;
  }

}
